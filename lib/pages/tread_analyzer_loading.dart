import 'package:bourboneur/common/login_wrapper.dart';
import 'package:flutter/material.dart';

class TreadAnalyzerLoadingPage extends StatefulWidget {
  TreadAnalyzerLoadingPage({
    super.key,
    required this.givingPrice,
    required this.receivingPrice
  });

  double givingPrice;
  double receivingPrice;

  @override
  State<TreadAnalyzerLoadingPage> createState() => _TreadAnalyzerLoadingPageState();
}

class _TreadAnalyzerLoadingPageState extends State<TreadAnalyzerLoadingPage> {

  double difference = 0;

  @override
  void initState() {
    difference = widget.receivingPrice - widget.givingPrice;
    print(widget.givingPrice);
    print(widget.receivingPrice);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoginWrapper(
      child: Center(
        child: Text("Total Value: " + difference.toString()),
      ),
    );
  }
}