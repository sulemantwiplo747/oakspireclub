import 'package:bourboneur/Core/Apis/Collection.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  Chart({
    super.key,
    required this.data
  });

  double maxPrice = 0;
  double minPrice = 0;

  double maxY = 8;
  double maxX = 0;

  String firstDate = "12-01-1";
  String lastDate = "12-12-31";

  List data;

  List<List<double>> prices = [
    // [10, 200],
    // [9, 201],
    // [8, 210],
    // [7, 260],
    // [6, 320],
    // [5.5, 370],
    // [5, 350],
    // [4.3, 470],
    // [3.7, 480],
    // [3, 490],
    // [1, 472]
  ];

  double? priceGap;
  double? dayGap;

  DateTime? first;
  DateTime? last;


  _prepareData() {

    if ( data.isNotEmpty )
    {

      first = DateTime.parse(data.first['date']);
      last = DateTime.parse(data.last['date']);

      var d = last!.difference(first!).inDays;      
      int i = 0;

      Map mapData = _listToMap(data);
      double price = 0;      

      while( i <= d ) {
        String date = DateFormat('yyyy-MM-dd').format(first!.add(Duration( days: i )));

        if ( mapData.containsKey(date) ) {
          price = double.parse(mapData[date]);
        }

        if ( maxPrice < price ) {
          maxPrice = price.toDouble();
        }

        if ( minPrice > price ) {
          minPrice = price.toDouble();
        }

        prices.add([i.toDouble(), price]);

        i++;
      }

      // return;

      // minPrice = double.parse(data.last['price']);

      // data.forEach((element ) {

      //   int price = int.parse(element['price']);
      //   if ( maxPrice < price ) {
      //     maxPrice = price.toDouble();
      //   }

      //   if ( minPrice > price ) {
      //     minPrice = price.toDouble();
      //   }

      //   prices.add([i.toDouble(), double.parse(element['price'])]);

      //   i++;

      // });

      maxX = d.toDouble();

      
      prices = prices.reversed.toList();
      priceGap = maxPrice - minPrice;
      priceGap = (priceGap! / maxY).ceilToDouble();
      priceGap = priceGap == 0 ? 1 : priceGap;
      dayGap = (maxX / 4).ceil().toDouble();
      // print(dayGap);

    }

    
  }

  Map<String, String> _listToMap( data ) {
    Map<String, String> output = {};
    data.forEach((element ) {
      output[element['date']] = element['price'];
    });

    return output;
  }

  @override
  Widget build(BuildContext context) {
    _prepareData();

    return LineChart(
      sampleData1,
      duration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: maxX,
        maxY: maxPrice,
        minY: minPrice,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) =>
              const Color(0xffe17f2f).withOpacity(0.3),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            maxIncluded: true,
            minIncluded: true,
            interval: dayGap! <= 0 ? null : dayGap,
            getTitlesWidget: bottomTitleWidgets
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            // showTitles: true,
            // reservedSize: 50
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          axisNameSize: 150,          
          sideTitles: SideTitles(            
              getTitlesWidget: leftTitleWidgets,
              showTitles: true,
              interval: priceGap,              
              reservedSize: 60,
              // minIncluded: true
          ),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      // fontWeight: FontWeight.bold,
      fontSize: 12,
      color: Colors.grey
    );

    final NumberFormat formatter = NumberFormat.compact(
      locale: 'en_us',      
    )..maximumFractionDigits = 1;
    // formatter.maximumIntegerDigits = 2;    
    final String formatted = formatter.format(value);

    return Text('\$' + formatted  , style: style, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    // print(value);
    // Widget text;    
    // switch (value.toInt()) {
    //   case 2:
    //     text = const Text('SEPT', style: style);
    //     break;
    //   case 7:
    //     text = const Text('OCT', style: style);
    //     break;
    //   case 12:
    //     text = const Text('DEC', style: style);
    //     break;
    //   default:
    //     text = const Text('');
    //     break;
    // }

    // String currentYear = DateTime.now().year.toString();
    // String startDate = DateFormat('yyyy-MM-dd').format(first);

    // DateTime date = DateTime.parse(startDate);
    DateTime date = first!.add(Duration(days: value.toInt()));

    String formattedDate = DateFormat('MMMd').format(date);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      angle: 45,      
      fitInside: SideTitleFitInsideData.disable(),
      space: 10,
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Text(
        formattedDate,
        style: TextStyle(
          fontSize: 10,
          color: Colors.grey
        ),
      ),
      ),
    );
  }

  List<FlSpot> get spots {
    List<FlSpot> spots = [];
    spots = prices.map((element) {
      print(prices);

      // double y = element.last * (1/minPrice);
      return FlSpot(element.first, element.last);

      // element
    }).toList();

    // print(y.toString());

    return spots;
  }

  FlGridData get gridData => FlGridData(
        show: false,
        drawVerticalLine: true,
        drawHorizontalLine: true,
        horizontalInterval: priceGap,
        verticalInterval: 1,
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
        border: const Border(
          bottom: BorderSide(color: Colors.red, width: 2),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        // isStrokeJoinRound: true,
        curveSmoothness: .05,
        color: Colors.red,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: spots,
      );
}
