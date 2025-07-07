import 'dart:async';
import 'dart:math' as math;
import 'package:bourboneur/Core/Apis/Collection.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/Core/Controllers/BlueBooks.dart';
import 'package:bourboneur/Core/Controllers/GroupedCollection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottleListTable extends StatefulWidget {
  BottleListTable({
    super.key,
    this.collections,
    this.sortMode,
    this.editMode = true,
    // this.isWishList = false,
    this.onPressRemove
  });

  String? sortMode;
  RxList<GroupedCollection>? collections;
  bool editMode;
  void Function(GroupedCollection collection)? onPressRemove;
  // bool isWishList;

  @override
  State<BottleListTable> createState() => _BottleListTableState();
}

class _BottleListTableState extends State<BottleListTable> {



  List<BottleListTableItem> _prepareCollections() {

    List<BottleListTableItem> list = [];
    if (widget.collections != null) {
      RxList<GroupedCollection> sortedList =
          RxList<GroupedCollection>.from(widget.collections!);

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
        case 'PRICE HIGH TO LOW':
          sortedList.sort((item1, item2) {
            double price1 = double.parse(item1.price!);
            double price2 = double.parse(item2.price!);
            return price2.compareTo(price1);
          });
          break;
        case 'PRICE LOW TO HIGH':
          sortedList.sort((item1, item2) {
            double price1 = double.parse(item1.price!);
            double price2 = double.parse(item2.price!);
            return price1.compareTo(price2);
          });
          break;
      }

      list.addAll(sortedList.map((element) {
        return BottleListTableItem(
            collection: element,
            editMode: widget.editMode,
            onPressRemove: widget.onPressRemove
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
        child: widget.collections != null && widget.collections!.isNotEmpty ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _prepareCollections(),
        ): const Text(
          "SEARCH ABOVE TO ADD YOUR BOTTLES",
          style: TextStyle(
            color: Color(0xffe17f2f),
            fontSize: 15,
            fontWeight: FontWeight.bold
          ),
        ));
  }
}

class BottleListTableItem extends StatefulWidget {
   BottleListTableItem(
      {super.key,
      required this.collection,
      required this.editMode,
      this.onPressRemove});

  GroupedCollection collection;
  bool editMode;
  void Function(GroupedCollection)? onPressRemove;

  @override
  State<BottleListTableItem> createState() => _BottleListTableItemState();
}

class _BottleListTableItemState extends State<BottleListTableItem> {

  int count = 1;
  int? initCount;
  Timer? _debounceTimer;

  Controller controller = Get.find<Controller>();

  @override
  void initState() {
    
    count = int.parse(widget.collection.count!);    
    initCount = count;

    super.initState();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel(); // Clean up timer
    super.dispose();
  }

   // Debounced API call
  void _debouncedUpdate() {
    _debounceTimer?.cancel(); // Cancel any existing timer
    _debounceTimer = Timer(Duration(seconds: 1), () {
      CollectionApi.addBulk(
        widget.collection.blueBook!.id!,
        controller.user.value.id,
        widget.collection.type == CollectionType.normal.name ?
          CollectionType.normal :
          CollectionType.wishlist,
        // params
        quantity: count
      );
    });
  }

  _handleCountChange(bool isIncrement) {
    if ( isIncrement ) {
      setState(() {
        count = count + 1;
      });
    } else {
      if ( count == 1 ) return;
      setState(() {
        count = count - 1;
      });
    }

    _debouncedUpdate();
  }

  @override
    Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child:  Text(
            widget.collection.blueBook!.bottleName!,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          )),
          if ( widget.editMode )
          NumberIncrementWidget(
            number: count.toString(),
            onTap: _handleCountChange,
          ),
          if (!widget.editMode)
          Container(
            width: 30,            
            alignment: Alignment.center,
            child: Text("${count}"),
          ),   
          if (!widget.editMode)
          Container(
            width: 60,            
            alignment: Alignment.topRight,
            child: Text("\$${widget.collection.price!}", style: TextStyle( color: Colors.white ),),
          ),  
         
          if (widget.editMode)
            GestureDetector(
              onTap: () {
                if (widget.onPressRemove != null) widget.onPressRemove!(widget.collection);
              },
              child: const Icon(
                Icons.delete_forever,
                color: Color(0xffe17f2f),
                size: 25,
              ),
            )
        ],
      ),
    );
  }
}

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
