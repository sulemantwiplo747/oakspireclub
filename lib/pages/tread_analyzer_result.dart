import 'package:flutter/material.dart';

import '../common/login_wrapper.dart';
import 'bluebook/personal_use.dart';

class TreadAnalyzerResultPage extends StatefulWidget {
  const TreadAnalyzerResultPage({
    super.key,
    required this.result,
  });

  final double result;

  @override
  State<TreadAnalyzerResultPage> createState() =>
      _TreadAnalyzerLoadingPageState();
}

class _TreadAnalyzerLoadingPageState extends State<TreadAnalyzerResultPage> {
  String resultText = '';
  Color resultColor = Colors.white;
  String resultImage = '';
  _onTapPersonalUse() {
    showAdaptiveDialog(
        context: context,
        builder: (BuildContext context) {
          return const PersonalUse();
        });
  }

  @override
  void initState() {
    super.initState();
    if (widget.result >= 21) {
      resultText = "That’s a great deal, for you!";
      resultColor = Colors.green;
      resultImage = 'assets/images/good.png';
    } else if (widget.result <= -21) {
      resultText =
          "Not the best deal for you.  Might need another bottle or a kicker";
      resultColor = Colors.red;
      resultImage = 'assets/images/bad.png';
    } else {
      resultText = "Pretty close…probably worth shaking on.";
      resultColor = Colors.amber;
      resultImage = 'assets/images/avg.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoginWrapper(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            const Center(
              child: Text("Trade\nAnalyzer",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 45,
                      height: 1.2,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffe48235))),
            ),            
            const Text("RESULTS",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    color: Colors.white)),
            const SizedBox(
              height: 25,
            ),
            Image(
              image: AssetImage(resultImage),
              height: 100,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              resultText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              (widget.result >= 0
                  ? "+ \$${widget.result.toInt()}"
                  : "- \$${widget.result.abs().toInt()}"),
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
                color: resultColor,
              ),
            ),
            const SizedBox(
              height: 55,
            ),
            GestureDetector(
              onTap: _onTapPersonalUse,
              child: SizedBox(
                height: 20,
                child: Text(
                  "*Personal Use Only",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xffe17f2f),
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.solid,
                      decorationThickness: 2,
                      decorationColor: const Color(0xffe17f2f)),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
