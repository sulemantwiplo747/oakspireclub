import 'package:bourboneur/common/login_wrapper.dart';
import 'package:bourboneur/pages/tread_analyzer/tread_analyzer_form.dart';
import 'package:flutter/material.dart';

class TradeAnalyzerPage extends StatefulWidget {
  TradeAnalyzerPage({super.key});

  @override
  State<TradeAnalyzerPage> createState() => _TradeAnalyzerPageState();
}

class _TradeAnalyzerPageState extends State<TradeAnalyzerPage> {
  @override
  Widget build(BuildContext context) {
    return LoginWrapper(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text("Trade\nAnalyzer",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 65,
                      height: 1.3,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffe48235))),
              const SizedBox(
                height: 20,
              ),
              const Text(
                  "Add your proposed trade bottles below to see how fair the deal is.",
                  textAlign: TextAlign.left,                  
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.white)),
              const SizedBox(
                height: 20,
              ),
              TreadAnalyzerForm()
            ],
          ),
        ),
      ),
    );
  }
}
