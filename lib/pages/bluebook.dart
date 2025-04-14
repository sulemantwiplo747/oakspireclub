import 'dart:async';

import 'package:bourboneur/Core/Apis/Bluebook.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/common/login_wrapper.dart';
import 'package:bourboneur/pages/bluebook/bluebook_table.dart';
import 'package:bourboneur/pages/bluebook/personal_use.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BlueBook extends StatefulWidget {
  const BlueBook({super.key});

  @override
  State<BlueBook> createState() => _BlueBookState();
}

class _BlueBookState extends State<BlueBook> {
  Timer? _debounce;
  String? keyword;

  TextEditingController searchController = TextEditingController();

  Controller controller = Get.find<Controller>();
  bool isListLoading = false;
  bool hasListData = true;
  int pageToLoad = 1;

  @override
  void initState() {
    getTimeData();
    getListData(pageToLoad);
    super.initState();
  }

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      keyword = query;
      hasListData = true;
      pageToLoad = 1;
      getListData(pageToLoad);
    });
  }

  _onTapPersonalUse() {
    showAdaptiveDialog(context: context, builder: (BuildContext context) {
      return PersonalUse();
    });
  }

  void getTimeData() async {
    await BlueBookApi.lastUpdatedAt();
    setState(() {});
  }

  void getListData( page ) async {
    if ( isListLoading ) return;
     
    setState(() {
      isListLoading = true;
    });
    bool response = await BlueBookApi.all(page.toString(), keyword, "10");
    if (!response) {
      setState(() {
        isListLoading = false;
        hasListData = false;
      });
      return;
    }

    pageToLoad++;

    setState(() {
      isListLoading = false;
    });
  }

  void _handleScrollReachedBottom() {
    if ( !hasListData ) return;
    getListData(pageToLoad);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoginWrapper(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: const BoxDecoration(
              // color: Colors.red,
              image: DecorationImage(
                  image: AssetImage("assets/images/bbb-banner.jpg"),
                  repeat: ImageRepeat.noRepeat,
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fitWidth)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 62,
              ),
              Text.rich(
                textAlign: TextAlign.left,
                style: TextStyle(
                      fontFamily: 'Arial',
                      color: Theme.of(context).textTheme.bodySmall?.color,
                      fontSize: 32,
                      height: 1),
                TextSpan(
                  text: "Bourbon Blue Book",
                  children: [
                    WidgetSpan(
                      
                      child: Transform.translate(
                        offset: Offset(2, -5),
                        child: Text('®', style: TextStyle(
                          fontSize: 25
                        ),),
                      ),
                    )
                  ]
                )
              ),
              Text(
                  "Real, Accurate Values.\nSearch thousands of recent secondary sales\nprices for coveted bottles of brownwater",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: 'Arial',
                      color: Theme.of(context).textTheme.titleMedium!.color,
                      fontSize: 12,
                      height: 1.3)),              
              const SizedBox(
                height: 8,
              ),
              Text(controller.lastUpdate.value.bluebook_readable != null ? "Updated ${controller.lastUpdate.value.bluebook_readable}" : "Loading...",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: 'Arial',
                      color: Theme.of(context).textTheme.titleMedium!.color,
                      fontSize: 12,
                      height: 1.3)),
              const SizedBox(
                height: 62,
              ),
              TextField(
                onChanged: _onSearchChanged,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.only(top: 7, bottom: 7, left: 7, right: 7),
                  hintText: "Search",
                  hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      height: 2.5,
                      fontWeight: FontWeight.normal),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(92, 195, 109, 39), width: 1),
                      borderRadius: BorderRadius.zero),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(92, 195, 109, 39), width: 1),
                      borderRadius: BorderRadius.zero),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(92, 195, 109, 39), width: 1),
                      borderRadius: BorderRadius.zero),
                  isDense: true,
                  filled: false,
                ),
              ),
              Container(
                constraints: const BoxConstraints(maxHeight: 360),
                child: BlueBookTable(
                  onReachedBottom: _handleScrollReachedBottom,
                  showLoading: hasListData,
                  keyword: keyword,
                  bluebooks: controller.bluebooks.toList(),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              // Text(
              //   "Developed by a Certified Bourbon Professional, use this Tool to search Thousands of Recent Secondary Sales\nPrices for Coveted Bottles of Brown Water*\nA Regularly Updated Resource for Bourbon (and Rye) Valuation",
              //   textAlign: TextAlign.center,
              //   style: Theme.of(context)
              //       .textTheme
              //       .bodySmall
              //       ?.copyWith(fontSize: 10, color: Color(0xffe17f2f)),
              // ),
              GestureDetector(
                onTap: _onTapPersonalUse,
                child: SizedBox(
                  height: 12,
                  child: Text(
                "*Personal Use Only",
                textAlign: TextAlign.center,                
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                      fontSize: 10, 
                      color: Color(0xffe17f2f), 
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.solid,
                      decorationThickness: 1,
                      decorationColor: Color(0xffe17f2f)
                    ),
              ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
