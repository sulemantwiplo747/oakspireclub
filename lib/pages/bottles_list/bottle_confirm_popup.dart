import 'package:bourboneur/pages/bottles_search.dart';
import 'package:flutter/material.dart';

class BottleConfirmPopup extends StatelessWidget {
  BottleConfirmPopup({
    super.key,
      this.value,
      this.text,
      this.onConfirm,
      this.disableThirdButton
    });

  Widget? text;
  String? value;
  void Function(int)? onConfirm;
  bool? disableThirdButton;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: ContinuousRectangleBorder(
        side: const BorderSide(width: 2, color: Color(0xffe17f2f)),
        borderRadius: BorderRadius.circular(0),
      ),
      backgroundColor: Colors.black,
      content: Container(
          padding: const EdgeInsets.only(left: 0, top: 10, right: 0),
          child: text),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // one more pop if disable third button is not true.

                if (onConfirm != null) onConfirm!(1);
              },
              child: const Text(
                'Yes',
                style: TextStyle(
                    color: Color(0xffe17f2f),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        if ( disableThirdButton != true )
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (onConfirm != null) onConfirm!(2);
              },
              child: const Text(
                'Add more than one',
                style: TextStyle(
                    color: Color(0xffe17f2f),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        )
      ],
    );
  }
}

class BottleAddPopup extends StatelessWidget {
  BottleAddPopup(
    {super.key,
      required this.value,
      required this.onConfirm,
      required this.searchPageType,
      this.disableThirdButton
    });

  String value;
  void Function(int)? onConfirm;
  SearchPageType searchPageType;
  bool? disableThirdButton;  

  TextSpan _text() {
    String text1 = "";
    String text2 = "";
    switch (searchPageType) {
      case SearchPageType.wishlist:
        text1 = "Add ";
        text2 = " to your wishlist?";
        break;
      case SearchPageType.normal:
        text1 = "Add ";
        text2 = " to your collection?";
        break;
      case SearchPageType.trade:
        text1 = "Add ";
        text2 = " to your trade evaluation?";
        break;
      default:
        text1 = "Select ";
        text2 = "?";
        break;
    }

    return TextSpan(
        text: text1,
        style: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(color: Color(0xffe17f2f)),
          ),
          TextSpan(text: text2)
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return BottleConfirmPopup(
      text: RichText(
        textAlign: TextAlign.center,
        text: _text(),
      ),
      onConfirm: onConfirm,
      disableThirdButton: disableThirdButton,
      value: value,
    );
  }
}

class BottleRemovePopup extends StatelessWidget {
  BottleRemovePopup(
      {super.key,
      required this.value,
      required this.isWishList,
      required this.onConfirm});

  String value;
  bool isWishList;
  void Function(int)? onConfirm;

  @override
  Widget build(BuildContext context) {
    return BottleConfirmPopup(
      disableThirdButton: true,
      text: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: "Remove ",
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(color: Color(0xffe17f2f)),
              ),
              TextSpan(
                  text: isWishList != true
                      ? " from your collection?"
                      : " from your wishlist?")
            ]),
      ),
      onConfirm: onConfirm,
      value: value,
    );
  }
}
