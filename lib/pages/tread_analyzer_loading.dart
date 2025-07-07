import 'package:bourboneur/common/login_wrapper.dart';
import 'package:bourboneur/pages/tread_analyzer_result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TreadAnalyzerLoadingPage extends StatefulWidget {
  const TreadAnalyzerLoadingPage({
    super.key,
    required this.givingPrice,
    required this.receivingPrice,
  });

  final double givingPrice;
  final double receivingPrice;

  @override
  State<TreadAnalyzerLoadingPage> createState() =>
      _TreadAnalyzerLoadingPageState();
}

class _TreadAnalyzerLoadingPageState extends State<TreadAnalyzerLoadingPage> {
  final RxInt activeBar = 0.obs;
  double difference = 0;

  @override
  void initState() {
    super.initState();
    difference = widget.receivingPrice - widget.givingPrice;

    _startAnimation();
    Future.delayed(const Duration(seconds: 3), () {
      Get.off(() => TreadAnalyzerResultPage(
            result: difference,
          ));
    });
  }

  void _startAnimation() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      activeBar.value = (activeBar.value + 1) % 9;
      return true;
    });
  }

  Widget buildBar(int index) {
    return Obx(() {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 10,
        height: 20,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: index <= activeBar.value
              ? const Color(0xffe17f2f)
              : const Color(0xffe17f2f).withOpacity(0.3),
          borderRadius: BorderRadius.circular(2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoginWrapper(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                "assets/images/analyzer.png",
                height: 200,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "LOADING...",
                  style: TextStyle(
                    color: Color(0xffe17f2f),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffe17f2f)),
                  ),
                  child: Row(
                    children: List.generate(9, (index) => buildBar(index)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
