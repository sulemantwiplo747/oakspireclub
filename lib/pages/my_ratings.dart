import 'dart:math' as math;
import 'package:bourboneur/Core/Apis/Collection.dart';
import 'package:bourboneur/Core/Apis/Rating.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/Core/Controllers/Collection.dart';
import 'package:bourboneur/common/custom_button.dart';
import 'package:bourboneur/common/login_wrapper.dart';
import 'package:bourboneur/pages/bottles_list/bottle_confirm_popup.dart';
import 'package:bourboneur/pages/bottles_list/bottle_list_sort.dart';
import 'package:bourboneur/pages/bottles_list/bottle_list_table.dart';
import 'package:bourboneur/pages/bottles_list/search_input.dart';
import 'package:bourboneur/pages/bottles_search.dart';
import 'package:bourboneur/pages/my_ratings/my_ratings_table.dart';
import 'package:bourboneur/pages/pour.dart';
import 'package:bourboneur/pages/wheel_of_destiny.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MyRatings extends StatefulWidget {
  MyRatings({super.key, this.isWishlist = false});

  bool isWishlist;

  @override
  State<MyRatings> createState() => _MyRatingsState();
}

class _MyRatingsState extends State<MyRatings> {
  Controller controller = Get.find<Controller>();

  bool isLoading = false;    
  bool isFirstTimeLoading = true;

  List<String> sortLabels = ["HIGHEST", "NAME A-Z", "NAME Z-A", "LOWEST"];
  String? sortSelected;  

  @override
  void initState() {    
    sortSelected = sortLabels[0];

    getListItems();
    super.initState();
  }

  void _handleOnSortChange(int index) {
    if (sortSelected != sortLabels[index]) {
      setState(() {
        sortSelected = sortLabels[index];
      });
    }
  }


  getListItems() async {
    setState(() {
      isLoading = true;
    });    
    await RatingApi.all(controller.user.value.id!);
    setState(() {
      isLoading = false;
      isFirstTimeLoading = false;
    });
  }

  Future onBack(value) {
    print(value.toString());
    return getListItems();
  }

  _handleOnTapRating(String id) {    
    Get.to(() => PourPage(
      id: id
    ))?.then(onBack);
  }

  // Future<void> _showConfirm({void Function()? onConfirm, String? value}) {
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return BottleRemovePopup(
  //           value: value!,
  //           isWishList: isWishlist,
  //           onConfirm: onConfirm
  //       );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return LoginWrapper(
        child: Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image.asset('assets/images/bb-rating.png', height: 100),
                // const SizedBox(
                //   height: 50,
                // ),
                if ( !isLoading )
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text("My",
                      textAlign: TextAlign.center,   
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                        height: 1.2
                      )
                    ),
                    Text.rich( 
                      textAlign: TextAlign.center,                     
                      TextSpan(
                        text: "${controller.ratings.length} ",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 50,
                            height: 1,
                            
                        ),
                        children: const [
                          TextSpan(
                            text: "Bourbon",
                            style: TextStyle(
                              color: Color(0xffe48235)
                            )
                          )
                        ]
                      )
                    ),
                    const Text("Ratings",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                        height: 1.2,
                      )
                    )
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                BottleListSort(
                  onChange: _handleOnSortChange,
                  labels: sortLabels,
                  defaultSelected: 0,
                ),
                const SizedBox(height: 20),
                MyRatingsTable(
                  ratings: controller.ratings,
                  sortMode: sortSelected,
                  onTapRating: _handleOnTapRating                  
                  // onPressRemove: _handleCollectionRemove,
                ),
                const SizedBox(height: 20),
                // if (isWishlist)
                const Text(
                "Click your ratings for details or to edit.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.normal
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // CustomButton(text: "Export Data to Excel")
                GestureDetector(
                    onTap: () {
                      String url = controller.config.value.ratingExportUrl! + controller.user.value.id!;
                      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                      // if (isWishlist) {
                      //   launchUrl(Uri.parse('https://brbnfndr.com'));
                      //   return;
                      // }else {
                      //   Get.to(() => WheelOfDestiny( exportCollection: true ));
                      // }
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xffe17f2f), width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(7))),
                        padding: const EdgeInsets.all(15),
                        child: const Text(
                           "EXPORT DATA TO EXCEL",
                            textAlign: TextAlign.center,                            
                            style: TextStyle(
                                fontFamily: 'Arial',
                                fontWeight: FontWeight.bold,                                
                                color: Colors.white,
                                // fontSize: isWishlist == false ? 20 : 30,
                                // letterSpacing: isWishlist == false ? null : 2.9,
                                height: 1.2))))
              ],
            ),
          ),
        ),
        if ( isLoading || isFirstTimeLoading )
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: isFirstTimeLoading ? Colors.black : const Color.fromARGB(52, 0, 0, 0),
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
