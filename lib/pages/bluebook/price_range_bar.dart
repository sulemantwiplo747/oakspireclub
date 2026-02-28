import 'package:flutter/material.dart';

class PriceRangeBar extends StatefulWidget {
  final double lowPrice;
  final double highPrice;
  final double? currentPrice;

  const PriceRangeBar({
    super.key,
    required this.lowPrice,
    required this.highPrice,
    this.currentPrice,
  });

  @override
  State<PriceRangeBar> createState() => _PriceRangeBarState();
}

class _PriceRangeBarState extends State<PriceRangeBar> {
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateProgress();
  }

  @override
  void didUpdateWidget(covariant PriceRangeBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentPrice != widget.currentPrice) {
      _calculateProgress();
    }
  }

  void _calculateProgress() {
    final current = widget.currentPrice ?? 0;
    double newProgress = 0.0;
    if ( widget.lowPrice == widget.highPrice ) {
      newProgress = 1.0;
    }else if (current <= widget.lowPrice) {
      newProgress = 0.0;
    } else if (current >= widget.highPrice) {
      newProgress = 1.0;
    } else {
      newProgress = (current - widget.lowPrice) / (widget.highPrice - widget.lowPrice);
    }

    setState(() {
      _progress = newProgress.clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.white),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Light background (whole range)
          Container(
            margin: const EdgeInsets.only(left: 44),
            decoration: BoxDecoration(
              color: const Color(0xfffdb400).withOpacity(0.18),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(9),
                bottomRight: Radius.circular(9),
              ),
            ),
          ),

          // Animated filled progress
          AnimatedContainer(
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutCubic,
            width: double.infinity,
            child: FractionallySizedBox(
              widthFactor: _progress,
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 44),
                decoration: BoxDecoration(
                  color: const Color(0xfffdb400),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(9),
                    bottomRight: Radius.circular(9),
                  ),
                ),
              ),
            ),
          ),

          // Left marker (LOW)
          Container(
            width: 44,
            decoration: BoxDecoration(
              color: const Color(0xfffdb400),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
          ),

          // Labels
          Positioned(
            left: 8,
            top: 10,
            child: Text(
              "\$${widget.lowPrice.toStringAsFixed(0)}\nLOW",
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ),
          Positioned(
            right: 12,
            top: 10,
            child: Text(
              "\$${widget.highPrice.toStringAsFixed(0)}\nHIGH",
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}