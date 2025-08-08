import 'dart:ffi';
import 'dart:math' as math;
import 'package:bourboneur/Core/Apis/Collection.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/Core/Controllers/Collection.dart';
import 'package:bourboneur/Core/Controllers/GroupedCollection.dart';
import 'package:bourboneur/common/login_wrapper.dart';
import 'package:bourboneur/pages/bottles_list/bottle_confirm_popup.dart';
import 'package:bourboneur/pages/bottles_list/bottle_list_sort.dart';
import 'package:bourboneur/pages/bottles_list/bottle_list_table.dart';
import 'package:bourboneur/pages/bottles_list/search_input.dart';
import 'package:bourboneur/pages/bottles_search.dart';
import 'package:bourboneur/pages/wheel_of_destiny.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class BottlesList extends StatefulWidget {
  BottlesList({super.key, this.isWishlist = false});

  bool isWishlist;

  @override
  State<BottlesList> createState() => _BottlesListState();
}

class _BottlesListState extends State<BottlesList> {
  Controller controller = Get.find<Controller>();

  bool isWishlist = false;
  bool isLoading = false;
  bool isRemoving = false;
  bool isEditing = false;
  bool isFirstTimeLoading = true;

  List<String> sortLabels = [
    "NEWEST",
    "NAME A-Z",
    "NAME Z-A",
    "OLDEST",
    "PRICE HIGH TO LOW",
    "PRICE LOW TO HIGH"
  ];
  String? sortSelected;

  @override
  void initState() {
    isWishlist = widget.isWishlist;
    sortSelected = sortLabels[0];

    getListItems();

    super.initState();
  }

  void _handleOnTapEdit() {
    if (isEditing) {
      getListItems();
    }

    setState(() {
      isEditing = !isEditing;
    });
  }

  void _handleOnSortChange(int index) {
    if (sortSelected != sortLabels[index]) {
      setState(() {
        sortSelected = sortLabels[index];
      });
    }
  }

  void _handleCollectionRemove(GroupedCollection collection) {
    _showConfirm(
        value: collection.blueBook!.bottleName!,
        onConfirm: (int button) async {
          // Navigator.pop(context);
          setState(() {
            isRemoving = true;
          });

          await CollectionApi.removeByUserBottle(
              collection.blueBook!.id!,
              controller.user.value.id!,
              collection.type == CollectionType.normal.name
                  ? CollectionType.normal
                  : CollectionType.wishlist);

          setState(() {
            isRemoving = false;
          });

          getListItems();
        });
  }

  getListItems() async {
    setState(() {
      isLoading = true;
    });
    CollectionType type =
        isWishlist ? CollectionType.wishlist : CollectionType.normal;
    await CollectionApi.grouped(controller.user.value.id!, type);
    setState(() {
      isLoading = false;
      isFirstTimeLoading = false;
    });
  }

  Future onBack(value) {
    return getListItems();
  }

  Future<void> _showConfirm({void Function(int)? onConfirm, String? value}) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return BottleRemovePopup(
            value: value!,
            isWishList: isWishlist,
            onConfirm: onConfirm,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return LoginWrapper(
        child: Stack(
      children: [
        Column(
          children: [
            Flexible(
                child: Container(                  
              child: Padding(
                  padding: EdgeInsets.all(17),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (isWishlist)
                        const SizedBox(
                          height: 70,
                          child: Text("WISHLIST",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35)),
                        ),
                      BottlesSearchInput(
                        readOnly: true,
                        onTap: () {
                          Get.to(() => BottlesSearchPage(
                                pageType: isWishlist
                                    ? SearchPageType.wishlist
                                    : SearchPageType.normal,
                              ))?.then(onBack);
                        },
                      ),
                      const SizedBox(height: 20),
                      ButtonListCounter(
                        count: controller.groupedCollections.length,
                        onTapEdit: _handleOnTapEdit,
                        isEditing: isEditing,
                      ),
                      const SizedBox(height: 20),
                      BottleListSort(
                        onChange: _handleOnSortChange,
                        labels: sortLabels,
                        defaultSelected: 0,
                      ),
                      const SizedBox(height: 20),
                      BottleListTable(
                        collections: controller.groupedCollections,
                        sortMode: sortSelected,
                        editMode: isEditing,
                        onPressRemove: _handleCollectionRemove,
                      ),
                      if ( isWishlist )
                      const SizedBox(height: 20),
                      if (isWishlist)
                        const Text(
                          "SOMETIMES, WISHES DO COME TRUE…",
                          style: TextStyle(
                              color: Color(0xffe17f2f),
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                ),
            )),
            Container(
                padding: const EdgeInsets.only(
                    top: 15, bottom: 15, left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                        onTap: () {
                          String? url =
                              controller.config.value.collectionDownloadUrl;
                          String? userId = controller.user.value.id;
                          if (isWishlist) {
                            launchUrl(
                                Uri.parse(url! +
                                    '?&user_id=' +
                                    userId! +
                                    "&type=wishlist"),
                                mode: LaunchMode.externalApplication);
                          } else {
                            launchUrl(
                                Uri.parse(url! +
                                    '?&user_id=' +
                                    userId! +
                                    "&type=normal"),
                                mode: LaunchMode.externalApplication);
                          }
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color(0xffe17f2f), width: 1),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(7))),
                            padding: const EdgeInsets.all(15),
                            child: Text("EXPORT TO EXCEL",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    // fontSize: isWishlist == false ? 20 : 30,
                                    fontSize: 20,
                                    // letterSpacing:
                                    //     isWishlist == false ? null : 2.9,
                                    height: 1.2)))),
                    SizedBox(height: 20),
                    GestureDetector(
                        onTap: () {
                          if (isWishlist) {
                            launchUrl(Uri.parse('https://brbnfndr.com'));
                            return;
                          } else {
                            Get.to(
                                () => WheelOfDestiny(exportCollection: true));
                          }
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color(0xffe17f2f), width: 1),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(7))),
                            padding: const EdgeInsets.all(15),
                            child: Text(
                                isWishlist == false
                                    ? "EXPORT TO WHEEL OF DESTINY"
                                    : "BRBNFNDR.COM",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 25,
                                    letterSpacing:
                                        isWishlist == false ? null : 2.9,
                                    height: 1.2))))
                  ],
                )),
          ],
        ),
        if (isRemoving || isLoading || isFirstTimeLoading)
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: isFirstTimeLoading
                ? Colors.black
                : const Color.fromARGB(52, 0, 0, 0),
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
    ));
  }
}

class ButtonListCounter extends StatelessWidget {
  ButtonListCounter(
      {super.key, required this.count, this.onTapEdit, this.isEditing});

  int count;
  void Function()? onTapEdit;
  bool? isEditing;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffe17f2f), width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(7))),
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                style: const TextStyle(
                    fontFamily: 'Arial',
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    fontSize: 35,
                    height: 1.2),
                text: "$count ",
                children: const [
                  TextSpan(
                      text: "Bottles",
                      style: TextStyle(color: Color(0xffe17f2f)))
                ]),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onTapEdit,
            child: Icon(isEditing == true ? Icons.done : Icons.edit,
                color: const Color(0xffe17f2f)),
          )
        ],
      ),
    );
  }
}
