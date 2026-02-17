
import 'package:flutter/material.dart';

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
            fontSize: 22,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
