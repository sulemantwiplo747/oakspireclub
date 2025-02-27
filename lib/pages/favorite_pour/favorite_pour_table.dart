import 'dart:math' as math;
import 'package:bourboneur/Core/Controllers/BlueBooks.dart';
import 'package:bourboneur/Core/Controllers/Collection.dart';
import 'package:bourboneur/Core/Controllers/Favorite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritePourTable extends StatefulWidget {
  FavoritePourTable({
    super.key,
    this.favorites,
    this.sortMode
  });

  String? sortMode;
  RxList<Favorite>? favorites;  
  void Function(Collection collection)? onPressRemove;
  // bool isWishList;

  @override
  State<FavoritePourTable> createState() => _FavoritePourTableState();
}

class _FavoritePourTableState extends State<FavoritePourTable> {



  List<MyFavoriteTableItem> _prepareCollections() {

    List<MyFavoriteTableItem> list = [];
    if (widget.favorites != null) {
      RxList<Favorite> sortedList =
          RxList<Favorite>.from(widget.favorites!);

      switch (widget.sortMode) {
        case 'NEWEST':
          sortedList.sort((item1, item2) {
            return item2.createdAt!
                .toString()
                .compareTo(item1.createdAt!.toString());
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
        case 'OLDEST':
          sortedList.sort((item1, item2) {
            return item1.createdAt!
                .toString()
                .compareTo(item2.createdAt!.toString());
          });
          break;
      }

      list.addAll(sortedList.map((element) {
        return MyFavoriteTableItem(
            id: element.id!,
            title: element.blueBook!.bottleName!,
        );
      }).toList());
    }

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
        child: widget.favorites != null && widget.favorites!.isNotEmpty ? Column(
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

class MyFavoriteTableItem extends StatelessWidget {
  MyFavoriteTableItem(
    {super.key,
      required this.title,      
      required this.id,    
    });

  String title;  
  String id;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              child: Text(
            title,
            textAlign: TextAlign.left,
            overflow: TextOverflow.clip,            
          )),          
        ],
      ),
    );
  }
}
