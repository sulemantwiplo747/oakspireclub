import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CustomButtonStyle {

  BlendMode? backgroundBlendMode;
  Color? color;
  BorderRadius? borderRadius;
  TextStyle? textStyle;
  EdgeInsetsGeometry? padding;

  CustomButtonStyle({
    this.backgroundBlendMode,
    this.borderRadius,
    this.color,
    this.textStyle,
    this.padding
  });
}

class CustomButton extends StatefulWidget {
  CustomButton(
      {super.key, required this.text, this.onTap, this.isLoading = false, this.style});

  final String text;
  void Function()? onTap;
  bool isLoading;
  CustomButtonStyle? style;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: widget.style?.padding ?? EdgeInsets.only(top: 10, bottom: 10),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            color: Color(0xFFff8202),
            borderRadius: BorderRadius.all(Radius.circular(10))).copyWith(
              color: widget.style?.color ,
              backgroundBlendMode: widget.style?.backgroundBlendMode,
              borderRadius: widget.style?.borderRadius,
            ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.text,
              style: widget.style?.textStyle ?? Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.background),
            ),
            if ( widget.isLoading )
            SizedBox(width: 10),
            if ( widget.isLoading )
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeCap: StrokeCap.round,
                color: Theme.of(context).colorScheme.background,
                strokeWidth: 2,
              ),
            )
          ],
        ),
      ),
    );
  }
}
