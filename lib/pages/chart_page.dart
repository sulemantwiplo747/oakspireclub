import 'package:bourboneur/Core/Apis/Collection.dart';
import 'package:bourboneur/Core/Apis/Market.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/common/login_wrapper.dart';
import 'package:bourboneur/common/staggered_item_animation.dart';
import 'package:bourboneur/pages/bottles_list.dart';
import 'package:bourboneur/pages/chart_page/chart_widget.dart';
import 'package:bourboneur/pages/chart_page/choose_bottle_wiskey.dart';
import 'package:bourboneur/pages/chart_page/collection_parcent.dart';
import 'package:bourboneur/pages/my_bottles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChartPage extends StatefulWidget {
  ChartPage({super.key, this.changeTab});
  void Function(int, dynamic)? changeTab;
  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  Controller controller = Get.find<Controller>();
  List chartData = [];
  List indexData = [];
  List snpData = [];

  String valuation = "0.00";
  String invested = "0.00";  
  List marketIndex = ['up', 00.00];
  int _animatedIndex = 0;

  bool isChartLoading = true;

  int lookBack = 365;

  @override
  void initState() {
    getData(lookBack);

    super.initState();
  }

  getData(int lookBack) async {
    isChartLoading = true;
    setState(() {});
    Map<String, dynamic> data = await CollectionApi.getChartData(
      controller.user.value.id!,
      lookBack
    );
    chartData = data['data'];
    indexData = data['index_data'];

    List snp = await MarketApi.snp(lookBack);
    snpData = snp;

    final NumberFormat formatter = NumberFormat.compact(locale: 'en_us')
      ..maximumFractionDigits = 2;

    valuation = formatter.format(double.parse(data['last_price']));
    invested = formatter.format(double.parse(data['invested_value']));

    isChartLoading = false;

    if (data['index'] != null) {
      marketIndex.clear();
      marketIndex.add(data['index']['trend']);
      marketIndex.add(
        double.parse(data['index']['movement'].toString()).toStringAsFixed(2),
      );

    }
    setState(() {});
  }

  List<double> _buildTrend() {
    List<double> data = [0, 0, 0];

    double priceDiff = 0;
    double indexDiff = 0;

    if ( chartData.isNotEmpty ) {
      Map first = chartData[0];
      Map last = chartData[chartData.length - 1];
       data[0] = 100 - (double.parse(first['price']) * 100 / double.parse(last['price']));
    }

    if ( indexData.isNotEmpty ) {
      Map first = indexData[0];
      Map last = indexData[indexData.length - 1];
       data[1] = 100 - (double.parse(first['price']) * 100 / double.parse(last['price']));
      // Map last = indexData[indexData.length - 1];
      // data[1] = double.parse(last['price'].toString());
    }

    if ( snpData.isNotEmpty ) {
      Map first = snpData[0];
      Map last = snpData[snpData.length - 1];
      data[2] = 100 - (double.parse(first['close'].toString()) * 100 / double.parse(last['close'].toString()));
    }

    return data;
  }

  void _handleOnChangeDate(int lookback) {
    getData(lookback);
  }

  Future onBack(value) {
    return getData(lookBack);
  }

  @override
  Widget build(BuildContext context) {
    List data = _buildTrend();


    return LoginWrapper(
      showBottomNavigator: false,
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
                      onTap: () {
                        Navigator.pop(context);
                        widget.changeTab!(0, null);
                        // Get.to(() => )
                      },
                      child: Image.asset("assets/images/bottom/menu.png", width: 35),                      
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
                  indexData: indexData,
                  snpData: snpData,
                  isLoading: isChartLoading,
                  valuation: valuation,
                  invested: invested,
                  onDateChange: _handleOnChangeDate,
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
                        percentage: data[0],
                        label: "Collection",
                        positiveColor: Color(0xff92d050),
                        negativeColor: Color(0xff92d050),
                      ),
                      CollectionPercent(
                        percentage: data[2],
                        label: "S&P",
                        positiveColor: Color(0xff699ebf),
                        negativeColor: Color(0xff699ebf),
                      ),
                      CollectionPercent(
                        percentage: data[1],
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
