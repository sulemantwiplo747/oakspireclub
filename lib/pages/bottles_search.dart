import 'dart:async';
import 'dart:isolate';

import 'package:bourboneur/Core/Apis/Bluebook.dart';
import 'package:bourboneur/Core/Apis/Collection.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/Core/Controllers/BlueBooks.dart';
import 'package:bourboneur/Core/Utils.dart';
import 'package:bourboneur/common/login_wrapper.dart';
import 'package:bourboneur/pages/bottles_list/bottle_create.dart';
import 'package:bourboneur/pages/bottles_list/bottle_confirm_popup.dart';
import 'package:bourboneur/pages/bottles_list/search_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SearchPageType { wishlist, normal, rating, trade }

class BottlesSearchPage extends StatefulWidget {
  BottlesSearchPage({
    super.key,
    required this.pageType,    
    this.onSelect
  });

  SearchPageType pageType;
  void Function(BlueBook)? onSelect;

  @override
  State<BottlesSearchPage> createState() => _BottlesSearchPageState();
}

class _BottlesSearchPageState extends State<BottlesSearchPage> {
  Timer? _debounce;
  String? keyword;

  Controller controller = Get.find<Controller>();
  bool isListLoading = false;

  bool isConfirmLoading = false;

  @override
  void initState() {
    getListData(1);

    super.initState();
  }

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      keyword = query;
      getListData(1);
    });
  }

  _handleConfirm(BlueBook bluebook) async {    
    Navigator.pop(context);

    // If the page type is search we are going to call only confirm
    if ( widget.pageType == SearchPageType.trade ) {
        if ( widget.onSelect != null ) widget.onSelect!(bluebook);        
        Utils().showToast('Success', "You bottle is now added.");
        return;
    }

    // else process with other code

    setState(() {
      isConfirmLoading = true;
    });

    if (
      widget.pageType == SearchPageType.wishlist ||
      widget.pageType == SearchPageType.normal
    ) {
      CollectionType type = widget.pageType == SearchPageType.wishlist ? CollectionType.wishlist : CollectionType.normal;
      await CollectionApi.add(bluebook.id!, controller.user.value.id, type);
    }

    setState(() {
      isConfirmLoading = false;
    });

    if (
      widget.pageType == SearchPageType.wishlist ||
      widget.pageType == SearchPageType.normal
    ) {
      Utils().showToast("Success", "You bottle is now added.");
    } else {
      // Navigator.pop(context);
      if ( widget.onSelect != null ) widget.onSelect!(bluebook);
    }
  }

  void getListData(page) async {
    if (isListLoading) return;

    setState(() {
      isListLoading = true;
    });

    bool response = await BlueBookApi.all(page.toString(), keyword, "200");
    if (!response) {
      setState(() {
        isListLoading = false;
      });
      return;
    }

    setState(() {
      isListLoading = false;
    });
  }

  _handleCreateConfirm(BlueBook bluebook) {    
     if (
      widget.pageType == SearchPageType.wishlist ||
      widget.pageType == SearchPageType.normal
    ) {
      Utils().showToast("Success", "You bottle is now added.");
    } else {
      // Navigator.pop(context);
      if ( widget.onSelect != null ) widget.onSelect!(bluebook);
    }     
  }

  @override
  Widget build(BuildContext context) {
    return LoginWrapper(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(17),
              child: Column(
                children: [
                  BottlesSearchInput(
                    autoFocus: true,
                    onChange: _onSearchChanged,
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),
                  if (isListLoading)
                    const CircularProgressIndicator(
                      strokeCap: StrokeCap.round,
                      strokeWidth: 3,
                      color: Color(0xffe17f2f),
                    ),
                  if (!isListLoading)
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: _prepareListItems())
                ],
              ),
            ),
          ),
          if (isConfirmLoading)
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: const Color.fromARGB(52, 0, 0, 0),
              child: const Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Color(0xffe17f2f),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  List<Widget> _prepareListItems() {
    List<Widget> data = [];
    // int i = 0;
    data.addAll(controller.bluebooks.map((BlueBook value) {
      // i++;
      return BottleSearchItem(
        text: value.bottleName!,
        onTap: () {
          _showConfirm(
            value: value.bottleName!,
            onConfirm: () {
              _handleConfirm(value);
          });
        },
        // isAdded: i % 3 != 0,
      );
    }).toList());

    if ( widget.pageType != SearchPageType.trade )
    {
      data.add(GestureDetector(
        onTap: () {
          _showCreate(onConfirm: _handleCreateConfirm);
        },
        child: const Row(children: [
          Expanded(
            child: Text(
              "DON'T SEE IT?  ADD YOUR OWN",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 18, height: 2, color: Color(0xffe17f2f)),
            ),
          ),
          SizedBox(width: 20),
          Icon(Icons.add_circle, color: Color(0xffe17f2f))
        ]),
      ));

    }

    
      if ( data.isEmpty ) 
      {
        data.add(Center(
          child: Text("Nothing found.."),
        ));
      }
    

    return data;
  }

  Future<void> _showConfirm({void Function()? onConfirm, String? value}) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return BottleAddPopup(
              value: value!,
              searchPageType: widget.pageType,              
              onConfirm: onConfirm);
        });
  }

  Future<void> _showCreate({void Function(BlueBook)? onConfirm}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BottleCreate(
              searchPageType: widget.pageType,
              onConfirm: onConfirm
            );
        });
  }
}

class BottleSearchItem extends StatelessWidget {
  BottleSearchItem({super.key, required this.text, this.isAdded, this.onTap});

  String text;
  bool? isAdded;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Row(
          children: [
            Expanded(
              child: Text(
                text,
                // overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 18,
                    height: 2,
                    color: isAdded == true
                        ? Colors.grey
                        : Theme.of(context).textTheme.bodyMedium?.color),
              ),
            ),
            SizedBox(width: 20),
            Icon(isAdded == true ? Icons.check_circle : Icons.add_circle,
                color: isAdded == true ? Colors.grey : Color(0xffe17f2f))
          ],
        ),
        Divider(
          color: const Color.fromARGB(255, 31, 31, 31),
        )
      ]),
    );
  }
}
