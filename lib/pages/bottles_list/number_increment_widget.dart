
import 'package:flutter/material.dart';

class NumberIncrementWidget extends StatelessWidget {
  final String number;
  final void Function(bool isIncrement) onTap;

  const NumberIncrementWidget({
    super.key,
    required this.number,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_left, size: 32, color: Colors.white),
          onPressed: () => onTap(false), // Pass decrement event
          tooltip: 'Decrement',
        ),
        Text(
          '$number',   
          style: TextStyle( color: Colors.white ),       
        ),
        IconButton(
          icon: const Icon(Icons.arrow_right, size: 32, color: Colors.white),
          onPressed: () => onTap(true), // Pass increment event
          tooltip: 'Increment',
        ),
      ],
    );
  }
}