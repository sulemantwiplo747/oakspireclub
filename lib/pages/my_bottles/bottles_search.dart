import 'package:flutter/material.dart';

class BottlesSearchInput extends StatelessWidget {
  BottlesSearchInput({
    super.key,
    this.readOnly,
    this.autoFocus,
    this.onTap,
    this.onChange,
    this.hintText
  });

  bool? readOnly;
  bool? autoFocus;
  void Function()? onTap;
  void Function(String)? onChange;
  String? hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: onTap,
      onChanged: onChange,
      readOnly: readOnly != null && readOnly == true,
      autofocus: autoFocus != null && autoFocus == true,
      // onChanged: _onSearchChanged,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        height: 2.5,
        color: Colors.white,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(
          top: 5,
          bottom: 5,
          left: 36, // ← space for icon
          right: 12,
        ),
        hintText: hintText ?? "Search thousands of bottles",
        hintStyle: const TextStyle(
          color: Color.fromARGB(255, 180, 180, 180),
          fontSize: 18,
          height: 2.5,
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 12),
          child: Icon(
            Icons.search_rounded,
            color: Color.fromARGB(
              255,
              255,
              255,
              255,
            ), // matching your orange theme
            size: 22,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 24, minHeight: 24),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 255, 255, 255),
            width: 2,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 255, 255, 255),
            width: 2,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 255, 255, 255),
            width: 2,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        isDense: true,
        filled: false,
      ),
    );
  }
}
