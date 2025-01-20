import 'package:bourboneur/Core/Apis/Bluebook.dart';
import 'package:bourboneur/Core/Apis/Collection.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/Core/Utils.dart';
import 'package:bourboneur/common/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BottleCreate extends StatefulWidget {
  BottleCreate({
    super.key,
    required this.isWishList,
    required this.onConfirm
  });
  
  bool isWishList;
  void Function()? onConfirm;

  @override
  State<BottleCreate> createState() => _BottleCreateState();
}

class _BottleCreateState extends State<BottleCreate> {
  Controller controller = Get.find<Controller>();
  Utils utils = Utils();

  bool isLoading = false;

  TextEditingController controllerBottleName = TextEditingController();
  TextEditingController controllerBottlePrice = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _handleConfirm() async {

    if (
      controllerBottleName.value.text == '' ||
      controllerBottlePrice.value.text == ''
    ) {
      utils.showToast("Error", "Please fill the form.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    dynamic bluebook = await BlueBookApi.create(
      controllerBottleName.text,
      controllerBottlePrice.text,
      controller.user.value.id!
    );

    if ( bluebook != false ) {      
      // add to collection
      await CollectionApi.add(
        bluebook.id,
        controller.user.value.id!,
        widget.isWishList ? CollectionType.wishlist : CollectionType.normal
      );

      Navigator.pop(context);
      if ( widget.onConfirm != null ) widget.onConfirm!();
    }
    
    
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
     return StatefulBuilder(builder: (BuildContext context, setState) {
      return AlertDialog(
        
        actionsAlignment: MainAxisAlignment.center,
        backgroundColor: Colors.black,
        shape: ContinuousRectangleBorder(
          side: const BorderSide(width: 2, color: Color(0xffe17f2f)),
          borderRadius: BorderRadius.circular(0),
        ),
        title: const Text(
          "CREATE A CUSTOM ENTRY",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold
          ),
        ),
        content: Container(
          // constraints: BoxConstraints.
          padding: const EdgeInsets.only(left: 0, top: 10, right: 0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BottleCreateInput(
                  label: "BOTTLE",
                  controller: controllerBottleName,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 30,
                ),
                BottleCreateInput(
                  label: "PRICE",
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  controller: controllerBottlePrice,
                )
              ],
            )
        ),
        actions: [
          if (isLoading)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Color(0xffe17f2f),
              ),
            ),
          if (!isLoading)
            TextButton(
              onPressed: _handleConfirm,
              child: const Text(
                'CONFIRM',
                style: TextStyle(
                    color: Color(0xffe17f2f),
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),            
          if (!isLoading)
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text(
                'CANCEL',
                style: TextStyle(
                    color: Color(0xffe17f2f),
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                  ),
              ),
            ),
          
        ],
      );
    });
  }
}

class BottleCreateInput extends StatelessWidget {
  BottleCreateInput({
    super.key,
    this.controller,
    required this.label,
    this.inputFormatters,
    this.keyboardType
  });

  TextEditingController? controller;
  String label;
  List<TextInputFormatter>? inputFormatters;
  TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white
          )
        ),
        const SizedBox(
          height: 5,
        ),
        TextField(
          keyboardType: keyboardType,  
          controller: controller,      
          maxLines: 1,
          inputFormatters: inputFormatters,
          onChanged: (String value) {

          },
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(fontSize: 12, fontFamily: 'Arial'),
          decoration: const InputDecoration(
              isDense: true,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.zero),
                  borderSide: BorderSide(color: Color(0xffe07e2f), width: 1)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.zero),
                  borderSide: BorderSide(color: Color(0xffe07e2f), width: 1))),
        )
      ],
    );
  }
}

