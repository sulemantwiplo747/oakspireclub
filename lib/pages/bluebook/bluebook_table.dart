import 'package:bourboneur/Core/Apis/Bluebook.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/Core/Controllers/BlueBooks.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BlueBookTable extends StatefulWidget {
  BlueBookTable(
      {
        super.key,
        this.keyword,
        required this.showLoading,
        required this.onReachedBottom,
        required this.bluebooks
      });

  String? keyword;
  bool showLoading;
  VoidCallback? onReachedBottom;
  List<BlueBook> bluebooks;

  @override
  State<BlueBookTable> createState() => _BlueBookTableState();
}

class _BlueBookTableState extends State<BlueBookTable> {
  Controller controller = Get.find<Controller>();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = 100.0; // or something else..
      if (maxScroll - currentScroll <= delta) {
        // whatever you determine here
        if (widget.onReachedBottom != null) widget.onReachedBottom!();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          child: Table(
            border: TableBorder.symmetric(
                inside: BorderSide.none, outside: BorderSide.none),
            columnWidths: const {
              0: FixedColumnWidth(170),
              1: FlexColumnWidth(),
              2: FlexColumnWidth(),
              3: FlexColumnWidth(),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                decoration: BoxDecoration(
                    color: Theme.of(context).textTheme.titleMedium!.color),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 12, top: 12, bottom: 12, right: 12),
                    child: Text(
                      "Bottle",
                      style: TextStyle(
                          fontFamily: 'BebasNeue',
                          // fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.background),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 12),
                    child: Text(
                      "Average",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'BebasNeue',
                          // fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.background),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 12),
                    child: Text(
                      "Low",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'BebasNeue',
                          // fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.background),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 12, bottom: 12, right: 12),
                    child: Text(
                      "High",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'BebasNeue',
                          // fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.background),
                    ),
                  )
                ],
              ),
            ]..addAll(_prepareTableRows(controller.bluebooks)),
          ),
        ),
        Container(
          color: Theme.of(context).textTheme.titleMedium!.color,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 170,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 12, top: 12, bottom: 12, right: 12),
                  child: Text(
                    "Bottle",
                    style: TextStyle(
                        fontFamily: 'BebasNeue',
                        // fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.background),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  child: Text(
                    "Average",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'BebasNeue',
                        // fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.background),
                  ),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: Text(
                  "Low",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'BebasNeue',
                      // fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.background),
                ),
              )),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12, right: 12),
                child: Text(
                  "High",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'BebasNeue',
                      // fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.background),
                ),
              ))
            ],
          ),
        )
      ],
    );
  }

  List<TableRow> _prepareTableRows(List<BlueBook> result) {
    List<TableRow> list = [];

    for (BlueBook bluebook in result) {
      // if (widget.keyword != null && widget.keyword != "") {
      //   var bottleName = bluebook.bottleName!;
      //   if (!bottleName.toUpperCase().contains(widget.keyword!.toUpperCase()))
      //     continue;
      // }

      list.add(TableRow(
          decoration: const BoxDecoration(
              border: BorderDirectional(
                  bottom: BorderSide(
                      color: Color.fromARGB(255, 73, 73, 73), width: 1))),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 12, top: 12, bottom: 12, right: 12),
              child: Text(
                bluebook.bottleName!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              child: Text(
                bluebook.average!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              child: Text(
                bluebook.low!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12, right: 12),
              child: Text(
                bluebook.high!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            )
          ]));
    }

    if (widget.showLoading) {
      list.add(TableRow(
          decoration: const BoxDecoration(
              border: BorderDirectional(
                  bottom: BorderSide(
                      color: Color.fromARGB(255, 73, 73, 73), width: 1))),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 12, top: 12, bottom: 12, right: 12),
              child: Text(
                "Loading...",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              child: Text(
                "",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              child: Text(
                '',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12, right: 12),
              child: Text(
                "",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            )
          ]));
      return list;
    }

    return list;
  }
}
