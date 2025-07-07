import 'package:flutter/material.dart';

class BottleListSort extends StatefulWidget {
  BottleListSort(
      {super.key,
      required this.labels,
      this.defaultSelected = 0,
      this.onChange});

  List<String> labels;
  int defaultSelected;
  void Function(int)? onChange;

  @override
  State<BottleListSort> createState() => _BottleListSortState();
}

class _BottleListSortState extends State<BottleListSort> {
  int? selectedValue;

  @override
  void initState() {
    selectedValue = widget.defaultSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
              color: Color(0xffe17f2f),
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _prepareItems(widget.labels.take(4).toList()),
          ),
        ),
        const SizedBox(height: 20),
        Container(
            decoration: const BoxDecoration(
                color: Color(0xffe17f2f),
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _prepareItems(widget.labels.skip(4).take(4).toList()),
            ))
      ],
    );
  }

  List<BottleListSortItem> _prepareItems(List<String> labels) {
    List<BottleListSortItem> items = [];
    items = labels.map(_SortItem).toList();
    return items;
  }

  BottleListSortItem _SortItem(String value) {
    return BottleListSortItem(
      text: value,
      value: value,
      isSelected: widget.labels.indexOf(value) == selectedValue,
      onTap: (String value) {
        setState(() {
          selectedValue = widget.labels.indexOf(value);
        });
        if (widget.onChange != null) widget.onChange!(selectedValue!);
      },
    );
  }
}

class BottleListSortItem extends StatefulWidget {
  BottleListSortItem(
      {super.key,
      required this.text,
      required this.value,
      this.onTap,
      this.isSelected = false});

  String text;
  String value;
  void Function(String)? onTap;
  bool isSelected;

  @override
  State<BottleListSortItem> createState() => _BottleListSortItemState();
}

class _BottleListSortItemState extends State<BottleListSortItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) widget.onTap!(widget.value);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        color: widget.isSelected ? Color.fromARGB(255, 189, 107, 39) : null,
        child: Text(
          widget.text,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: widget.isSelected ? Colors.black : Colors.white),
        ),
      ),
    );
  }
}
