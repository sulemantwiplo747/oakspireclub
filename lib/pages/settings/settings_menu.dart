import 'package:flutter/material.dart';

class SettingMenu extends StatelessWidget {
  SettingMenu({
    super.key,
    required this.items,
    this.title = "Accounts",
    this.showTitle = true,
    this.color,
  });

  final List<Widget> items;
  final String title;
  final bool showTitle;
  Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showTitle) ...[
          Padding(
            padding: const EdgeInsets.only(left: 15, bottom: 8),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          // const SizedBox(height: 4),
        ],
        Container(
          // padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: color,
            border: Border.all(width: 2, color: Colors.white),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _buildChildrenWithDividers(),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildChildrenWithDividers() {
    if (items.isEmpty) return [];

    final List<Widget> children = [];

    for (int i = 0; i < items.length; i++) {
      children.add(items[i]);
      // Add divider after every item except the last one
      if (i < items.length - 1) {
        children.add(
          const Divider(color: Colors.black, height: 0, thickness: 1),
        );
      }
    }

    return children;
  }
}

class SettingsMenuItem extends StatelessWidget {
  SettingsMenuItem({
    super.key,
    required this.label,
    required this.subLabel,
    required this.asset,
    required this.onTap,
  });
  String label;
  String subLabel;
  String asset;
  void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsetsGeometry.only(left: 15, top: 15, bottom: 15, right: 15),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(asset, width: 50, height: 50),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                subLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff94bfbf),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      )
      ),
    );
  }
}
