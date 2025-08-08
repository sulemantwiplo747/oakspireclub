import 'package:bourboneur/Core/Apis/Collection.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/Core/Controllers/BlueBooks.dart';
import 'package:bourboneur/pages/bottles_list/number_increment_widget.dart';
import 'package:bourboneur/pages/bottles_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddMultiplePopup extends StatefulWidget {
  AddMultiplePopup({
    super.key,
    required this.bluebook,
    required this.pageType
  });

  BlueBook bluebook;
  SearchPageType pageType;

  @override
  State<AddMultiplePopup> createState() => _AddMultiplePopupState();
}

class _AddMultiplePopupState extends State<AddMultiplePopup> {
  Controller controller = Get.find<Controller>();
  int number = 1;
  bool isAdding = false;

  void _handleOnTapIncrement(isIncrement) {
    if (isIncrement) {
      number += 1;
    } else if (number > 1) {
      number -= 1;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: ContinuousRectangleBorder(
        side: const BorderSide(width: 2, color: Color(0xffe17f2f)),
        borderRadius: BorderRadius.circular(0),
      ),
      backgroundColor: Colors.black,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: "Add ",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: widget.bluebook.bottleName,
                    style: const TextStyle(color: Color(0xffe17f2f)),
                  ),
                ]),
          ),
          const SizedBox(
            height: 20,
          ),
          NumberIncrementWidget(
              number: number.toString(), onTap: _handleOnTapIncrement)
        ],
      ),
      actions: [        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if ( isAdding )
            const Text(
              'Adding...',
              style: TextStyle(
                  color: Color(0xffe17f2f),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            if ( !isAdding )
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text(
                'Cancel',
                style: TextStyle(
                    color: Color(0xffe17f2f),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            if ( !isAdding )
            TextButton(
              onPressed: () async {                       
                setState(() {
                  isAdding = true;
                });
                await CollectionApi.addBulk(
                  widget.bluebook.id!,
                  controller.user.value.id!,
                  widget.pageType,
                  quantity: number
                );   
                setState(() {
                  isAdding = false;
                });
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                'Ok',
                style: TextStyle(
                    color: Color(0xffe17f2f),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
