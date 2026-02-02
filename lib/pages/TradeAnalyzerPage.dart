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
    return SafeArea(
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
                  "Trade Analyzer\nTool",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 35,
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Color(0xffea8333),
                  ),
                ),
              ),

              StaggeredItemAnimation(
                index: ++_animateIndex,
                child: const Text(
                  "See how fair the deal is.",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 30,
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              StaggeredItemAnimation(
                index: ++_animateIndex,
                fadeOnly: true,
                child: TreadAnalyzerForm(
                  blueBook: widget.pageData,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
