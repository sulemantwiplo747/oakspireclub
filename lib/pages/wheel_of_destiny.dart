import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:bourboneur/Core/Apis/Collection.dart';
import 'package:bourboneur/Core/Apis/WOD.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/Core/Controllers/Collection.dart';
import 'package:bourboneur/Core/Utils.dart';
import 'package:bourboneur/common/login_wrapper.dart';
import 'package:bourboneur/pages/wheel_of_destiney/open_popup.dart';
import 'package:bourboneur/pages/wheel_of_destiney/save_popup.dart';
import 'package:bourboneur/pages/wheel_of_destiney/wheel.dart';
import 'package:bourboneur/pages/wheel_of_destiney/wheel_text_field.dart';
import 'package:bourboneur/pages/wheel_of_destiney/wining_popup.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WheelOfDestiny extends StatefulWidget {
  WheelOfDestiny({
    super.key,
    this.exportCollection = false
  });

  bool exportCollection;

  @override
  State<WheelOfDestiny> createState() => _WheelOfDestinyState();
}

class _WheelOfDestinyState extends State<WheelOfDestiny> {
  List<String> items = ["Add Item", "Add Item"];

  Utils utils = Utils();
  Controller controller = Get.find<Controller>();

  final StreamController<int> _streamController = StreamController<int>();

  int? winingIndex;

  bool isEditing = false;
  bool isSaveLoading = false;
  bool isOpenLoading = false;
  bool isExporting = false;
  String? name;
  String? id;

  TextEditingController data = TextEditingController();

  @override
  void initState() {
    getCreatedWheels();

    if ( widget.exportCollection ) getCollections();
    
    super.initState();
  }

  void getCreatedWheels() async {
    await WODApi.byUserId(controller.user.value.id!);
    setState(() {});
  }

  getCollections() async {
    setState(() {
      isExporting = true;
    });
    // only normal can be exported
    await CollectionApi.all(controller.user.value.id!, CollectionType.normal);

    // now loop 
    List<String> items = controller.collections.map((element) {
      return element.blueBook!.bottleName!; 
    }).toList();
    // now jkoin loop
    String text = items.join("\n");
    data.value = TextEditingValue(text: text);
    _handleOnTextChange(text);
    setState(() {
      isExporting = false;
    });
  }

  void _handleOnTextChange(String text) {
    List<String> arr = text.split("\n");
    arr = arr
        .where((element) {
          return element.isNotEmpty && element.trim() != "";
        })
        .toList()
        .map((e) {
          return e.trim();
        })
        .toList();

    if (arr.isEmpty) {
      items = ["Add Item", "Add Item"];
    } else {
      items = arr;
    }

    setState(() {});
  }

  void _handleSave() {
    if (data.value.text.trim() == "") {
      utils.showToast("Error", "Textarea cant not be empty");
      return;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SavePopup(
            name: name,
            onSubmit: _handleSubmit,
          );
        });
  }

  void _handleSubmit(String name) async {
    if (isSaveLoading) return;
    Navigator.of(context).pop();

    setState(() {
      isSaveLoading = true;
    });

    var response = isEditing
        ? await WODApi.update(
            id!, controller.user.value.id!, name, data.value.text)
        : await WODApi.create(controller.user.value.id!, name, data.value.text);

    if (response != false) {
      setState(() {
        id = response;
        this.name = name;
        isEditing = true;
        isSaveLoading = false;
      });
      utils.showToast("Success", "Saved successfully");
    } else {
      setState(() {
        isSaveLoading = false;
      });
    }
  }

  void _handleImport() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null) {
      String name = result.files.single.name;
      List<String> arr = name.split(".");
      if (arr.last != "csv") {
        utils.showToast("Error", "Please select a csv file");
        return;
      }

      // now the csv file is selected.
      // Csv
      String input = await File(result.files.single.path!).readAsString();
      List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter()
          .convert(input, eol: "\n", convertEmptyTo: '');
      List finalValue = rowsAsListOfValues.map((e) {
        return e.join(" ");
      }).toList();
      String text = finalValue.join("\n");
      data.value = TextEditingValue(text: text);
      _handleOnTextChange(text);

      return;
    } else {
      // User canceled the picker
    }
  }

  void _handleOpen() {
    if (isOpenLoading) return;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return OpenPopup(
            onTapDelete: _deleteById,
            onTapOpen: _loadById,
          );
        });
  }

  void _handleSpinEnd() {
    String text = items.elementAt(winingIndex!).toString();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return WiningPopup(text: text);
        });
  }

  void _loadById(String id) async {
    setState(() {
      isOpenLoading = true;
    });

    bool response = await WODApi.getById(id);
    if (!response) {
      setState(() {
        isOpenLoading = false;
      });
      return;
    }

    this.id = controller.wod.value.id!;
    name = controller.wod.value.name!;
    data.value = TextEditingValue(text: controller.wod.value.data!);
    isEditing = true;
    _handleOnTextChange(data.value.text);
    setState(() {
      isOpenLoading = false;
    });
  }

  void _deleteById(String id) async {
    setState(() {
      isOpenLoading = true;
    });

    bool response = await WODApi.deleteById(id);
    if (!response) {
      setState(() {
        isOpenLoading = false;
      });
      return;
    }

    if (this.id == id) {
      // close the data
      this.id = null;
      name = null;
      data.value = TextEditingValue();
      _handleOnTextChange("");
      isEditing = false;
    }

    setState(() {
      isOpenLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoginWrapper(
      showBottomNavigator: false,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 0, right: 0, top: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text(
                  "stop thinking,",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: 'Arial',
                      color: Theme.of(context).textTheme.bodySmall?.color,
                      fontSize: 35,
                      height: 1),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                  "start drinking!",
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(                            
                            fontSize: 17,
                            fontFamily: 'Arial'),
                ),
              ),
              Wheel(
                controller: _streamController,
                texts: items,
                onSpinEnd: _handleSpinEnd,
                onTapSpin: () {
                  if (items.length <= 1) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    color: Colors.black,
                                    padding: EdgeInsets.all(30),
                                    child: Column(
                                      children: [
                                        Text("Enter Two Items before spin",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                    color: Colors.white)),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Text("OK",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                          color: const Color(
                                                              0xffe07e2f))),
                                            ))
                                      ],
                                    ),
                                  )
                                ],
                              ));
                        });
                  } else {
                    final _random = new math.Random();
                    winingIndex = _random.nextInt(items.length);
                    _streamController.add(winingIndex!);
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                        "add your bottles to the list below\nand spin to select your drink",
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(                            
                            fontSize: 17,
                            fontFamily: 'Arial')),
                    const SizedBox(
                      height: 17,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        WheelActionButtons(
                          image: "assets/images/save_button.png",
                          text: isEditing ? "UPDATE" : "SAVE",
                          onTap: _handleSave,
                          isLoading: isSaveLoading,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        WheelActionButtons(
                          image: "assets/images/import_button.png",
                          text: "IMPORT",
                          onTap: _handleImport,
                        ),
                        if (controller.wods.isNotEmpty)
                          const SizedBox(
                            width: 20,
                          ),
                        if (controller.wods.isNotEmpty)
                          WheelActionButtons(
                            image: "assets/images/import_button.png",
                            text: "OPEN",
                            onTap: _handleOpen,
                            isLoading: isOpenLoading,
                          )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    WheelTextField(
                      onChanged: _handleOnTextChange,
                      controller: data,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class WheelActionButtons extends StatelessWidget {
  WheelActionButtons({
    super.key,
    required this.image,
    required this.text,
    this.isLoading = false,
    this.onTap,
  });

  final String image;
  final String text;
  final bool isLoading;

  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Row(
          children: [
            isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xffe07e2f),
                    ))
                : Image.asset(
                    image,
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                  ),
            const SizedBox(width: 7),
            Text(
              text,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffe07e2f)),
            )
          ],
        ),
      ),
    );
  }
}
