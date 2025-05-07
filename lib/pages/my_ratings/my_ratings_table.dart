import 'dart:math' as math;
import 'package:bourboneur/Core/Controllers/Rating.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyRatingsTable extends StatefulWidget {
  MyRatingsTable({
    super.key,
    this.ratings,
    this.sortMode,
    this.onTapRating
  });

  String? sortMode;
  RxList<Rating>? ratings;  
  void Function(String)? onTapRating;

  @override
  State<MyRatingsTable> createState() => _MyRatingsTableState();
}

class _MyRatingsTableState extends State<MyRatingsTable> {


  List<MyRatingsTableItem> _prepareCollections() {

    List<MyRatingsTableItem> list = [];
    if (widget.ratings != null) {
      RxList<Rating> sortedList =
          RxList<Rating>.from(widget.ratings!);

      switch (widget.sortMode) {
        case 'HIGHEST':
          sortedList.sort((item1, item2) {
            double nose1 = double.parse(item1.nose!);
            double palate1 = double.parse(item1.palate!);
            double finish1 = double.parse(item1.finish!);

            double nose2 = double.parse(item2.nose!);
            double palate2 = double.parse(item2.palate!);
            double finish2 = double.parse(item2.finish!);

            double total1 = nose1 + palate1 + finish1;
            double total2 = nose2 + palate2 + finish2;

            return total2.compareTo(total1);
          });
          break;
        case 'NAME A-Z':
          sortedList.sort((item1, item2) {
            return item1.blueBook!.bottleName!
                .toLowerCase()
                .compareTo(item2.blueBook!.bottleName!.toLowerCase());
          });
          break;
        case 'NAME Z-A':
          sortedList.sort((item1, item2) {
            return item2.blueBook!.bottleName!
                .toLowerCase()
                .compareTo(item1.blueBook!.bottleName!.toLowerCase());
          });
          break;
        case 'LOWEST':
          sortedList.sort((item1, item2) {
            double nose1 = double.parse(item1.nose!);
            double palate1 = double.parse(item1.palate!);
            double finish1 = double.parse(item1.finish!);

            double nose2 = double.parse(item2.nose!);
            double palate2 = double.parse(item2.palate!);
            double finish2 = double.parse(item2.finish!);

            double total1 = nose1 + palate1 + finish1;
            double total2 = nose2 + palate2 + finish2;

            return total1.compareTo(total2);
          });
          break;
      }

      list.addAll(sortedList.map((element) {

        double nose = double.parse(element.nose!);
        double palate = double.parse(element.palate!);
        double finish = double.parse(element.finish!);

        return MyRatingsTableItem(
          title: element.blueBook!.bottleName!,
          rating: (nose + palate + finish).toInt().toString(),
          id: element.id!,
          onTap: widget.onTapRating,
        );
        
      }).toList());
    }

    // list.addAll([
    //   MyRatingsTableItem(
    //     title: "George T Stagg 2024 15 123 123 123 123 123 123 123",
    //     rating: "15",
    //     id: "1",
    //   ),
    //   MyRatingsTableItem(
    //     title: "George T Stagg 2024 15",
    //     rating: "15",
    //     id: "2",
    //   ),
    // ]);

    return list;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        constraints: const BoxConstraints(minHeight: 200),
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffe17f2f), width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(7))),
        padding: const EdgeInsets.all(15),
        child: widget.ratings != null && widget.ratings!.isNotEmpty ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _prepareCollections(),
        ): const Text(
          "Nothing found",
          style: TextStyle(
            color: Color(0xffe17f2f),
            fontSize: 15,
            fontWeight: FontWeight.bold
          ),
        ));
  }
}

class MyRatingsTableItem extends StatelessWidget {
  MyRatingsTableItem(
  {
      super.key,
      required this.title,
      required this.rating,
      required this.id,
      this.onTap
  });

  String title;
  String rating;
  String id;

  void Function(String)? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
         if (onTap != null) onTap!(id);
      },
      child: Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              child: Text(
            title,
            textAlign: TextAlign.left,
            overflow: TextOverflow.clip,            
          )),
          Text(
            rating,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    ),
    );
  }
}
