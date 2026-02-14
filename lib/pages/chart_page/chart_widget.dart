import 'package:bourboneur/pages/chart_page/chart.dart';
import 'package:flutter/material.dart';

class ChartWidget extends StatefulWidget {
  const ChartWidget({
    super.key,
    required this.data,
    required this.indexData,
    required this.isLoading,
    required this.valuation,    
    required this.onDateChange,
    required this.invested
  });

  final List data;
  final List indexData;
  final bool isLoading;
  final String valuation;
  final String invested;
  final void Function(int) onDateChange;

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  bool _showDetails = false;
  String selectedDate = '1Y';

  double priceChange = 0;

  int toDays(String time) {
    int data = 365;
    switch(time.toLowerCase()) {
      case '3d':
        data = 3;
        break;
      case '7d':
        data = 7;
        break;
      case '1m':
        data = 30;
        break;
      case '3m':
        data = 90;
        break;    
    }
    return data;
  }

  @override
  void initState() {
    // if ( widget.data.isNotEmpty ) {
    //   print("==PRICE CHANGE===");
    //   print(widget.data[0]);
    // }
    
    super.initState();
  }

  void _handleDateChange(String item) {
    setState(() {
      selectedDate = item;
    });
    
    widget.onDateChange(toDays(item));
  }

  @override
  Widget build(BuildContext context) {    
    
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header - tappable area
          GestureDetector(
            onTap: () {
              setState(() {
                _showDetails = !_showDetails;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 17),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Icon row
                  Row(
                    children: [
                      const Text(
                        "Collection Value",
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      AnimatedRotation(
                        turns: _showDetails ? 0.5 : 0,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        child: const Icon(
                          Icons.expand_more,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  // Collapsible section with smooth height animation
                  ClipRect(
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.easeInOutCubicEmphasized,
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        height: _showDetails ? null : 0,
                        child: _showDetails
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  top: 16,
                                  bottom: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Main valuation - always visible
                                    Text(
                                      "\$${widget.valuation}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Arial',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 38,
                                        height: 1.1,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    // Invested amount - always visible
                                    Text(
                                      "Invested: \$${widget.invested}",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.85),
                                        fontFamily: 'Arial',
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Chart container
          Container(
            height: 220,
            padding: const EdgeInsets.only(
              left: 4,
              right: 4,
              top: 10,
              bottom: 20,
            ),
            child: widget.data.isNotEmpty && !widget.isLoading
                ? Chart(data: widget.data, index: widget.indexData)
                : Center(
                    child: Text(
                      widget.isLoading ? "Syncing..." : "No data available",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Indicator(color: Color(0xff92d050), text: "Market Value"),
              SizedBox(width: 20),
              Indicator(color: Color(0xffbfbfbf), text: "S&P 500"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Indicator(
                color: Color(0xffff7520),
                text: "Bourboneur Secondary Market Index",
                isDotted: true,
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TimeRangeFilter(
                onPeriodChanged: _handleDateChange,
                selectedPeriod: selectedDate,
              ),
            ],
          ),
          SizedBox(height: 15),
          
        ],
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  Indicator({
    super.key,
    required this.color,
    required this.text,
    this.isDotted = false,
  });
  Color color;
  String text;
  bool isDotted;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(isDotted ? Icons.more_horiz : Icons.horizontal_rule, color: color),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            // fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class TimeRangeFilter extends StatelessWidget {
  final String selectedPeriod;
  final ValueChanged<String> onPeriodChanged;

  // You can easily add/remove periods here
  static const List<String> periods = ['3D', '7D', '1M', '3M', '1Y'];

  const TimeRangeFilter({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: periods.length,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemBuilder: (context, index) {
          final period = periods[index];
          final isSelected = period == selectedPeriod;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: FilterChip(
              label: Text(
                period,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.grey[300],
                ),
              ),
              backgroundColor: Colors.black,
              selectedColor: Color(0xff4c6c29),
              showCheckmark: false,
              selected: isSelected,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(
                  color: isSelected ? Color(0xff4c6c29) : Colors.black,
                  width: 1.2,
                ),
              ),
              onSelected: (_) => onPeriodChanged(period),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          );
        },
      ),
    );
  }
}
