import 'package:bourboneur/Core/Apis/Collection.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/common/login_wrapper.dart';
import 'package:bourboneur/common/staggered_item_animation.dart';
import 'package:bourboneur/pages/bottles_list.dart';
import 'package:bourboneur/pages/chart_page/chart_widget.dart';
import 'package:bourboneur/pages/chart_page/choose_bottle_wiskey.dart';
import 'package:bourboneur/pages/my_bottles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  Controller controller = Get.find<Controller>();
  List chartData = [];
  String valuation = "0.00";
  String ytd = "0.00";
  String overall = "0.00";
  List marketIndex = ['up', 00.00];

  bool isChartLoading = true;

  @override
  void initState() {
    getData();

    super.initState();
  }

  getData() async {
    Map<String, dynamic> data = await CollectionApi.getChartData(
      controller.user.value.id!,
    );
    chartData = data['data'];

    // valuation = double.parse("23123").toString();
    // final formatter = NumberFormat('#,##0.00'); // Format with commas and 2 decimal places
    final NumberFormat formatter = NumberFormat.compact(locale: 'en_us')
      ..maximumFractionDigits = 2;
    // formatter.maximumIntegerDigits = 2;
    valuation = formatter.format(double.parse(data['last_price']));

    ytd = double.parse(data['trend_ytd']).toStringAsFixed(2);
    overall = double.parse(data['trend_overall']).toStringAsFixed(2);

    isChartLoading = false;

    if (data['index'] != null) {
      marketIndex.clear();
      marketIndex.add(data['index']['trend']);
      marketIndex.add(
        double.parse(data['index']['movement'].toString()).toStringAsFixed(2),
      );
      // marketIndex.add(double.parse(data['index']['movement'].toString()).toStringAsFixed(2));
    }
    setState(() {});
  }

  Future onBack(value) {
    return getData();
  }

  @override
  Widget build(BuildContext context) {
    int _animatedIndex = 0;
    return LoginWrapper(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StaggeredItemAnimation(
                index: ++_animatedIndex,
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "My Bottles",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xfffe8003),
                        ),
                        softWrap: true,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.menu,
                        color: Color(0xfffe8003),
                        size: 35,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              StaggeredItemAnimation(
                index: ++_animatedIndex,
                fadeOnly: true,
                child: ChartWidget(
                  data: chartData,
                  isLoading: isChartLoading,
                  valuation: valuation,
                  ytd: ytd,
                  overall: overall,
                ),
              ),
              const SizedBox(height: 10),

              // GestureDetector(
              //   onTap: () {
              //     Get.to(() => BottlesList());
              //   },
              //   child: Container(
              //       decoration: BoxDecoration(
              //           border: Border.all(
              //               color: const Color(0xffe17f2f), width: 1),
              //           borderRadius:
              //               const BorderRadius.all(Radius.circular(15))),
              //       padding: const EdgeInsets.all(15),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.stretch,
              //         children: [
              //           Row(
              //             mainAxisAlignment: MainAxisAlignment.end,
              //             children: [
              //               if ( marketIndex.isNotEmpty )
              //               Icon(
              //                 marketIndex[0] == 'down' ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
              //                 color: marketIndex[0] == 'down' ? Colors.red : const Color(0xffe17f2f),
              //                 size: 26,
              //               ),
              //               if ( marketIndex.isNotEmpty )
              //               Text("${marketIndex[1]}% YTD",
              //                   textAlign: TextAlign.right,
              //                   style: const TextStyle(
              //                       fontFamily: 'Arial',
              //                       fontWeight: FontWeight.bold,
              //                       color: Color(0xffe17f2f),
              //                       // letterSpacing: 2.5,
              //                       fontSize: 18,
              //                       height: 1.2))
              //             ],
              //           ),
              //           const SizedBox(
              //             height: 5,
              //           ),
              //           const Text("BOURBONEUR SECONDARY MARKET INDEX",
              //                   textAlign: TextAlign.right,
              //                   style: TextStyle(
              //                       fontFamily: 'Arial',
              //                       fontWeight: FontWeight.bold,
              //                       color: Color(0xffe17f2f),
              //                       // letterSpacing: 2.5,
              //                       fontSize: 13,
              //                       height: 1.2))
              //         ],
              //       )),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // GestureDetector(
              //   onTap: () {
              //     Get.to(() => ChooseBottleWhiskey())?.then(onBack);
              //   },
              //   child: Container(
              //       decoration: BoxDecoration(
              //           border: Border.all(
              //               color: const Color(0xffe17f2f), width: 1),
              //           borderRadius:
              //               const BorderRadius.all(Radius.circular(15))),
              //       padding: const EdgeInsets.all(15),
              //       child: const Column(
              //         children: [
              //           Text("BOTTLES",
              //               textAlign: TextAlign.center,
              //               style: TextStyle(
              //                   fontFamily: 'Arial',
              //                   fontWeight: FontWeight.bold,
              //                   color: Colors.white,
              //                   letterSpacing: 4,
              //                   fontSize: 35,
              //                   height: 1.2)),
              //           Text("CLICK TO UPDATE",
              //               textAlign: TextAlign.center,
              //               style: TextStyle(
              //                   fontFamily: 'Arial',
              //                   fontWeight: FontWeight.bold,
              //                   color: Color(0xffe17f2f),
              //                   // letterSpacing: 2.5,
              //                   fontSize: 13,
              //                   height: 1.2)),
              //         ],
              //       )),
              // ),
              StaggeredItemAnimation(
                index: ++_animatedIndex,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.white),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CollectionPercent(
                        percentage: 6.40,
                        label: "Collection",
                        positiveColor: Color(0xff92d050),
                        negativeColor: Color(0xff92d050),
                      ),
                      CollectionPercent(
                        percentage: 4.25,
                        label: "S&P",
                        positiveColor: Color(0xff699ebf),
                        negativeColor: Color(0xff699ebf),
                      ),
                      CollectionPercent(
                        percentage: 5.13,
                        label: "BSMI",
                        positiveColor: Color(0xffff7520),
                        negativeColor: Color(0xffff7520),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CollectionPercent extends StatelessWidget {
  final double percentage; // e.g. 6.90, -2.45, 12.8
  final String label; // e.g. "Collection", "Return", "Change"
  final Color? positiveColor; // optional - color when positive
  final Color? negativeColor; // optional - color when negative

  const CollectionPercent({
    super.key,
    required this.percentage,
    this.label = "Collection",
    this.positiveColor,
    this.negativeColor,
  });

  @override
  Widget build(BuildContext context) {
    // Determine color based on value
    final bool isPositive = percentage >= 0;
    final Color textColor = isPositive
        ? (positiveColor ?? const Color(0xff92d050)) // green
        : (negativeColor ?? const Color(0xfff44336)); // red

    // Format percentage with 2 decimal places + % sign
    final String displayValue = "${percentage.toStringAsFixed(2)}%";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          displayValue,
          style: TextStyle(
            fontSize: 35,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 19,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
