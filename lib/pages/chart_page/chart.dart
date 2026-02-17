import 'package:bourboneur/Core/Apis/Collection.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  Chart({super.key, required this.data, required this.index, required this.snp });

  double maxPrice = 0;
  double minPrice = 0;

  double maxY = 8;
  double maxX = 0;

  String firstDate = "12-01-1";
  String lastDate = "12-12-31";

  List data;
  List index;
  List snp;

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

  List<List<double>> indexPrices = [
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

  List<List<double>> snpPrices = [
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

  List<List<double>> originalPrices = [];
  List<List<double>> originalIndexPrices = [];
  List<List<double>> originalSnpPrices = [];

  double? priceGap;
  double? dayGap;

  DateTime? first;
  DateTime? last;

  _prepareData() {
    if (data.isNotEmpty) {
      first = DateTime.parse(data.first['date']);
      last = DateTime.parse(data.last['date']);

      var d = last!.difference(first!).inDays;
      int i = 0;

      Map mapData = _listToMap(data);
      double price = 0;

      while (i <= d) {
        String date = DateFormat(
          'yyyy-MM-dd',
        ).format(first!.add(Duration(days: i)));

        if (mapData.containsKey(date)) {
          price = double.parse(mapData[date]);
        }

        if (maxPrice < price) {
          maxPrice = price.toDouble();
        }

        if (minPrice > price) {
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

    if (index.isNotEmpty) {
      first = DateTime.parse(data.first['date']);
      last = DateTime.parse(data.last['date']);

      var d = last!.difference(first!).inDays;
      int i = 0;

      Map indexData = _listToMap(index);
      double price = 0;

      while (i <= d) {
        String date = DateFormat(
          'yyyy-MM-dd',
        ).format(first!.add(Duration(days: i)));

        if (indexData.containsKey(date)) {
          price = double.parse(indexData[date]);
        }

        // if ( maxPrice < price ) {
        //   maxPrice = price.toDouble();
        // }

        // if ( minPrice > price ) {
        //   minPrice = price.toDouble();
        // }

        indexPrices.add([i.toDouble(), price]);

        i++;
      }

      // maxX = d.toDouble();

      indexPrices = indexPrices.reversed.toList();
      // print("===INDEX DATA====");
      // print(indexPrices);
      // priceGap = maxPrice - minPrice;
      // priceGap = (priceGap! / maxY).ceilToDouble();
      // priceGap = priceGap == 0 ? 1 : priceGap;
      // dayGap = (maxX / 4).ceil().toDouble();
      // print(dayGap);
    }

    if ( snp.isNotEmpty )
    {
      first = DateTime.parse(data.first['date']);
      last = DateTime.parse(data.last['date']);

      var d = last!.difference(first!).inDays;
      int i = 0;

      Map snpData = _listToMap(snp, priceIndex: 'close');
      double price = 0;

      while (i <= d) {
        String date = DateFormat(
          'yyyy-MM-dd',
        ).format(first!.add(Duration(days: i)));

        if (snpData.containsKey(date)) {
          price = double.parse(snpData[date]);
        }

        // if ( maxPrice < price ) {
        //   maxPrice = price.toDouble();
        // }

        // if ( minPrice > price ) {
        //   minPrice = price.toDouble();
        // }

        snpPrices.add([i.toDouble(), price]);

        i++;
      }

      // maxX = d.toDouble();

      snpPrices = snpPrices.reversed.toList();
    }

    originalPrices = List.from(prices.map((e) => List<double>.from(e)));
    originalIndexPrices = List.from(indexPrices.map((e) => List<double>.from(e)));
    originalSnpPrices = List.from(snpPrices.map((e) => List<double>.from(e)));

    if (prices.isNotEmpty) {
      final double priceBase = prices.first[1]; // first price value
      for (int j = 0; j < prices.length; j++) {
        double original = prices[j][1];
        // prices[j][1] = ((original - priceBase) / priceBase) * 100; // % change
        prices[j][1] = original / priceBase;
      }
    }

    if (snpPrices.isNotEmpty) {
      final double snpBase = snpPrices.first[1]; // first price value
      for (int j = 0; j < snpPrices.length; j++) {
        double original = snpPrices[j][1];
        // prices[j][1] = ((original - priceBase) / priceBase) * 100; // % change
        snpPrices[j][1] = original / snpBase;
      }
    }

    if (indexPrices.isNotEmpty) {
      final double indexBase = indexPrices.first[1];
      for (int j = 0; j < indexPrices.length; j++) {
        double original = indexPrices[j][1];
        // indexPrices[j][1] = ((original - indexBase) / indexBase) * 100;
        indexPrices[j][1] = original / indexBase;
      }
    }
  }

  Map<String, String> _listToMap(data, { priceIndex = 'price' }) {
    Map<String, String> output = {};
    data.forEach((element) {
      output[element['date']] = element[priceIndex].toString();
    });

    return output;
  }

  @override
  Widget build(BuildContext context) {
    _prepareData();

    return LineChart(sampleData1, duration: const Duration(milliseconds: 250));
  }

  LineChartData get sampleData1 => LineChartData(
    lineTouchData: lineTouchData1,
    gridData: gridData,
    titlesData: titlesData1,
    borderData: borderData,
    lineBarsData: lineBarsData1,
    // minX: 0,
    // maxX: maxX,
    // maxY: maxPrice,
    // minY: minPrice,
  );

  LineTouchData get lineTouchData1 => LineTouchData(
      handleBuiltInTouches: true,
      touchTooltipData: LineTouchTooltipData(
        // tooltipBgColor: Colors.black.withOpacity(0.75),
        tooltipRoundedRadius: 8,
        fitInsideHorizontally: true,
        fitInsideVertically: true,
        tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        getTooltipItems: (List<LineBarSpot> touchedSpots) {
          return touchedSpots.map((LineBarSpot touchedSpot) {

            final double value = touchedSpot.y;
            final int dayIndex = touchedSpot.x.toInt();
            double displayValue  = 0;
            String label = "";
            String formattedValue;
            Color color;
            // final double displayValue;
            switch( touchedSpot.barIndex )
            {
              case 2:  // 2 snp bar index
                displayValue = originalSnpPrices[snpPrices.length - 1 - dayIndex][1];
                label = "S&P";
                final formatter = NumberFormat.currency(
                  locale: 'en_US',
                  symbol: '\$',
                  decimalDigits: 0,
                );
                formattedValue = formatter.format(displayValue);
                color = Color(0xff699ebf);
              case 1: // 1 = index
                displayValue = originalIndexPrices[indexPrices.length - 1 - dayIndex][1];
                label = "Index";
                formattedValue = '${displayValue.toStringAsFixed(2)}%';
                color = Color(0xff92d050);
                break;
              default:
                displayValue = originalPrices[prices.length - 1 - dayIndex][1];
                label = "Price";
                final formatter = NumberFormat.currency(
                  locale: 'en_US',
                  symbol: '\$',
                  decimalDigits: 0,
                );
                formattedValue = formatter.format(displayValue);
                color = Color(0xffff7520);
              
            }
            

            // Reconstruct the date
            DateTime date = first!.add(Duration(days: dayIndex));
            String dateStr = DateFormat('MMM d, yyyy').format(date);

            
            


            return LineTooltipItem(
              '$dateStr\n$label: $formattedValue',
              TextStyle(
                color: color, // purple for index
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            );
          }).toList();
        },
      ),
    );

  FlTitlesData get titlesData1 => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: false,
        reservedSize: 40,
        maxIncluded: true,
        minIncluded: true,
        interval: dayGap! <= 0 ? null : dayGap,
        getTitlesWidget: bottomTitleWidgets,
      ),
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(
        // showTitles: true,
        // reservedSize: 50
      ),
    ),
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    leftTitles: AxisTitles(
      axisNameSize: 150,
      sideTitles: SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: false,
        interval: priceGap,
        reservedSize: 60,
        // minIncluded: true
      ),
    ),
  );

  List<LineChartBarData> get lineBarsData1 => [
    lineChartBarData1_1,
    lineChartBarDataIndex,
    lineChartBarDataSnp
  ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      // fontWeight: FontWeight.bold,
      fontSize: 12,
      color: Colors.grey,
    );

    final NumberFormat formatter = NumberFormat.compact(locale: 'en_us')
      ..maximumFractionDigits = 1;
    // formatter.maximumIntegerDigits = 2;
    final String formatted = formatter.format(value);

    return Text(
      '\$' + formatted,
      style: style,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
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
          style: TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ),
    );
  }

  List<FlSpot> get spots {
    List<FlSpot> spots = [];
    spots = prices.map((element) {
      // print(prices);

      // double y = element.last * (1/minPrice);
      return FlSpot(element.first, element.last);

      // element
    }).toList();

    // print(y.toString());

    return spots;
  }

  List<FlSpot> get indexSpots {
    List<FlSpot> spots = [];
    spots = indexPrices.map((element) {
      // print(prices);

      // double y = element.last * (1/minPrice);
      return FlSpot(element.first, element.last);

      // element
    }).toList();

    // print(y.toString());

    return spots;
  }

  List<FlSpot> get snpSpots {
     List<FlSpot> spots = [];
    spots = snpPrices.map((element) {
      // print(prices);

      // double y = element.last * (1/minPrice);
      return FlSpot(element.first, element.last);

      // element
    }).toList();

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
    color: Color(0xff92d050),
    barWidth: 2,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: spots,
  );

  LineChartBarData get lineChartBarDataIndex => LineChartBarData(
    isCurved: true,    
    // isStrokeJoinRound: true,
    curveSmoothness: .5,
    color: Color(0xffff7520),
    barWidth: 2,
     dashArray: [3, 6],
    isStrokeCapRound: true,    
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: indexSpots,
  );

  LineChartBarData get lineChartBarDataSnp => LineChartBarData(
    isCurved: true,    
    // isStrokeJoinRound: true,
    curveSmoothness: .5,
    color: Color(0xff699ebf),
    barWidth: 2,
    //  dashArray: [3, 6],
    isStrokeCapRound: true,    
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: snpSpots,
  );
}
