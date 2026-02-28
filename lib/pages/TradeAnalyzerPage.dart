import 'package:bourboneur/common/login_wrapper.dart';
import 'package:bourboneur/common/staggered_item_animation.dart';
import 'package:bourboneur/pages/tread_analyzer/tread_analyzer_form.dart';
import 'package:flutter/material.dart';

class TradeAnalyzerPage extends StatefulWidget {
  TradeAnalyzerPage({super.key, this.changeTab, this.pageData});

  void Function(int, dynamic)? changeTab;
  dynamic pageData;

  @override
  State<TradeAnalyzerPage> createState() => _TradeAnalyzerPageState();
}

class _TradeAnalyzerPageState extends State<TradeAnalyzerPage> {
  @override
  void initState() {
    super.initState();
  }

  int _animateIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(height: double.infinity),
        Positioned.fill(
          bottom: 0,
          child: Image.asset(
            'assets/images/new_bg_cropped.png',
            fit:
                BoxFit.fitWidth, // or BoxFit.contain if you don't want cropping
            alignment: Alignment.bottomCenter,
          ),
        ),
        // Container(color: Colors.black.withAlpha(100)),
        SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 30),
                  StaggeredItemAnimation(
                    index: ++_animateIndex,
                    child: const Text(
                      "Trade Analyzer Tool",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 30,
                        height: 1.2,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  StaggeredItemAnimation(
                    index: ++_animateIndex,
                    child: const Text(
                      "Powered by the Bourbon Blue Book®",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        // fontStyle: FontStyle.italic,
                        color: Color(0xffe38333),
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  StaggeredItemAnimation(
                    index: ++_animateIndex,
                    child: const Text(
                      "See how fair the deal is.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                        height: 1.2,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  StaggeredItemAnimation(
                    index: ++_animateIndex,
                    fadeOnly: true,
                    child: TreadAnalyzerForm(blueBook: widget.pageData),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
