import 'package:bourboneur/Core/Apis/Collection.dart';
import 'package:bourboneur/Core/Apis/Favorite.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/Core/Controllers/Collection.dart';
import 'package:bourboneur/common/login_wrapper.dart';
import 'package:bourboneur/pages/bottles_list/bottle_confirm_popup.dart';
import 'package:bourboneur/pages/favorite_pour/favorite_pour_table.dart';
import 'package:bourboneur/pages/wheel_of_destiny.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class FavoritePour extends StatefulWidget {
  FavoritePour({super.key, this.isWishlist = false});

  bool isWishlist;

  @override
  State<FavoritePour> createState() => _FavoritePourState();
}

class _FavoritePourState extends State<FavoritePour> {
  Controller controller = Get.find<Controller>();

  bool isWishlist = false;
  bool isLoading = false;
  
  @override
  void initState() {
  
    getListItems();
    super.initState();
  }


  getListItems() async {
    setState(() {
      isLoading = true;
    });
    
    await FavoriteApi.all(controller.user.value.id!);
    setState(() {
      isLoading = false;
    });
  }

  Future onBack(value) {
    print(value.toString());
    return getListItems();
  }

  Future<void> _showConfirm({void Function()? onConfirm, String? value}) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return BottleRemovePopup(
              value: value!, isWishList: isWishlist, onConfirm: onConfirm);
        });
  }

  @override
  Widget build(BuildContext context) {
    return LoginWrapper(
        child: Stack(
      children: [
        SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 270,
                  padding: EdgeInsets.only(left: 130, top: 50),
                  decoration: const BoxDecoration(
                      //color: Colors.red,
                      image: DecorationImage(
                          image: AssetImage("assets/images/favourite-banner.jpg"),
                          alignment: Alignment.center,
                          repeat: ImageRepeat.noRepeat)),
                  child: Text(
                    //"Elevate\nYour Spirit",
                    "",
                    style: TextStyle(
                        fontFamily: 'Arial',
                        color: Theme.of(context).textTheme.titleMedium?.color,
                        fontSize: 35,
                        height: 1.2),
                  ),
                ),
               Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: [
                     Container(
                  alignment: Alignment.centerLeft,
                  child: Image.asset('assets/images/favorite_pours.png',
                      width: 330),
                ),
                SizedBox(
                  height: 10,
                ),
                // BottleListSort(
                //   onChange: _handleOnSortChange,
                //   labels: sortLabels,
                //   defaultSelected: 0,
                // ),
                // const SizedBox(height: 20),
                FavoritePourTable(
                  favorites: controller.favorites,
                  sortMode: 'NEWEST'
                ),
                const SizedBox(height: 20),
                // CustomButton(text: "Export Data to Excel")
                // GestureDetector(
                //     onTap: () {
                //       if (isWishlist) {
                //         launchUrl(Uri.parse('https://brbnfndr.com'));
                //         return;
                //       }else {
                //         Get.to(() => WheelOfDestiny( exportCollection: true ));
                //       }
                //     },
                //     child: Container(
                //         decoration: BoxDecoration(
                //             border: Border.all(
                //                 color: const Color(0xffe17f2f), width: 1),
                //             borderRadius:
                //                 const BorderRadius.all(Radius.circular(7))),
                //         padding: const EdgeInsets.all(15),
                //         child: Text(
                //            "EXPORT DATA TO EXCEL",
                //             textAlign: TextAlign.center,
                //             style: TextStyle(
                //                 fontFamily: 'Arial',
                //                 fontWeight: FontWeight.bold,
                //                 color: Colors.white,
                //                 fontSize: isWishlist == false ? 20 : 30,
                //                 letterSpacing: isWishlist == false ? null : 2.9,
                //                 height: 1.2))))
                  ],
                ),
               )
              ],
            ),
        ),
        if ( isLoading )
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black,
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
