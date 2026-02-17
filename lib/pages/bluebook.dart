import 'dart:async';

import 'package:bourboneur/Core/Apis/Bluebook.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/Core/Controllers/BlueBooks.dart' as ctrl; 
import 'package:bourboneur/common/login_wrapper.dart';
import 'package:bourboneur/pages/bluebook/bluebook_single.dart';
import 'package:bourboneur/pages/bluebook/bluebook_table.dart';
import 'package:bourboneur/pages/bluebook/personal_use.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:bourboneur/pages/home/home_content.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class BlueBook extends StatefulWidget {
  BlueBook({super.key, this.changeTab, this.pageData});

  void Function(int, dynamic)? changeTab;
  dynamic pageData;

  @override
  State<BlueBook> createState() => _BlueBookState();
}

class _BlueBookState extends State<BlueBook> {
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Container(height: double.infinity),
          Positioned.fill(
            bottom: 0,
            child: Image.asset(
              'assets/images/new_bg.png',
              fit: BoxFit
                  .fitWidth, // or BoxFit.contain if you don't want cropping
              alignment: Alignment.bottomCenter,
            ),
          ),
          Container(
            color: Colors.black.withAlpha(
              100
            ),
          ),
          BlueBookContent(
            changeTab: widget.changeTab
          ),
          // Container(
          // //   color: Colors.red,
          // //   height: double.infinity,
          // // ),
        ],
      );
  }
}

class BlueBookContent extends StatefulWidget {
  BlueBookContent({super.key, this.changeTab});

   void Function(int, dynamic)? changeTab;

  @override
  State<BlueBookContent> createState() => _BlueBookContentState();
}

class _BlueBookContentState extends State<BlueBookContent> {
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
    showAdaptiveDialog(
      context: context,
      builder: (BuildContext context) {
        return PersonalUse();
      },
    );
  }

  void getTimeData() async {
    await BlueBookApi.lastUpdatedAt();
    setState(() {});
  }

  void getListData(page) async {
    if (isListLoading) return;

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
    if (!hasListData) return;
    getListData(pageToLoad);
  }

  void _handleOnClickItem(ctrl.BlueBook bluebook) {
    
    Get.to(() => BlueBookSinglePage( blueBook: bluebook, changeTab: widget.changeTab ));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: const BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage("assets/images/bbb-banner.jpg"),
            //   repeat: ImageRepeat.noRepeat,
            //   alignment: Alignment.topCenter,
            //   fit: BoxFit.fitWidth,
            // ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 15),

              // Title with ®
              Text.rich(
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontFamily: 'Arial',
                  color: Colors.white,
                  fontSize: 35,
                  height: 1,
                  fontWeight: FontWeight.bold,
                ),
                TextSpan(
                  text: "Bourbon Blue Book",
                  children: [
                    WidgetSpan(
                      child: Transform.translate(
                        offset: const Offset(2, -5),
                        child: const Text('®', style: TextStyle(fontSize: 25)),
                      ),
                    ),
                  ],
                ),
              ),

              // Text(
              //   "Real, Accurate Values.\nSearch thousands of recent secondary sales\nprices for coveted bottles of brownwater",
              //   textAlign: TextAlign.left,
              //   style: TextStyle(
              //     fontFamily: 'Arial',
              //     color: Theme.of(context).textTheme.titleMedium!.color,
              //     fontSize: 12,
              //     height: 1.3,
              //   ),
              // ),

              // const SizedBox(height: 8),
              Text(
                controller.lastUpdate.value.bluebook_readable != null
                    ? "Updated ${controller.lastUpdate.value.bluebook_readable}"
                    : "Loading...",
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontFamily: 'Arial',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 15),

              // ── Search Field with Icon ───────────────────────────────
              TextField(
                onChanged: _onSearchChanged,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  height: 2.5,
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(
                    top: 5,
                    bottom: 5,
                    left: 36, // ← space for icon
                    right: 12,
                  ),
                  hintText: "Search thousands of bottles",
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 180, 180, 180),
                    fontSize: 18,
                    height: 2.5,
                    fontWeight: FontWeight.bold,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Icon(
                      Icons.search_rounded,
                      color: Color.fromARGB(
                        255,
                        255,
                        255,
                        255,
                      ), // matching your orange theme
                      size: 22,
                    ),
                  ),
                  prefixIconConstraints: BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 255, 255, 255),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.zero,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 255, 255, 255),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.zero,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 255, 255, 255),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.zero,
                  ),
                  isDense: true,
                  filled: false,
                ),
              ),

              const SizedBox(height: 8),

              // ── New instruction text ───────────────────────────────
              Text(
                "Click on the bottle to get whiskey wise",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  // fontStyle: FontStyle.italic,
                  letterSpacing: 0.3,
                ),
              ),

              const SizedBox(height: 12),

              // Table container
              Container(
                constraints: const BoxConstraints(maxHeight: 400),
                child: BlueBookTable(
                  onReachedBottom: _handleScrollReachedBottom,
                  showLoading: hasListData,
                  keyword: keyword,
                  bluebooks: controller.bluebooks.toList(),
                  onTap: _handleOnClickItem,
                ),
              ),

              const SizedBox(height: 5),

              GestureDetector(
                onTap: _onTapPersonalUse,
                child: SizedBox(
                  height: 16,
                  child: Text(
                    "*Personal Use Only",
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffe17f2f),
                      // decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.solid,
                      decorationThickness: 1,
                      decorationColor: const Color(0xffe17f2f),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
