import 'dart:async';
import 'dart:math' as math;
import 'package:bourboneur/Core/Apis/Collection.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/Core/Controllers/BlueBooks.dart';
import 'package:bourboneur/Core/Controllers/GroupedCollection.dart';
import 'package:bourboneur/pages/bottles_list/number_increment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';

class BottleListTable extends StatefulWidget {
  BottleListTable({
    super.key,
    this.collections,
    this.sortMode,
    this.editMode = true,
    // this.isWishList = false,
    this.onPressRemove,
    this.onCountChange
  });

  String? sortMode;
  RxList<GroupedCollection>? collections;
  bool editMode;
  void Function(GroupedCollection collection)? onPressRemove;
  void Function(GroupedCollection collection)? onCountChange;
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
            onPressRemove: widget.onPressRemove,
            onUpdateComplete: widget.onCountChange,
        );
      }).toList());
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(child:  Container(            
        // constraints: BoxConstraints.,
        decoration: BoxDecoration(          
            border: Border.all(color: const Color(0xffe17f2f), width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(7))),
        padding: const EdgeInsets.all(15),
        child: widget.collections != null && widget.collections!.isNotEmpty ? SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _prepareCollections(),
        ),
        ): const Text(
          "SEARCH ABOVE TO ADD YOUR BOTTLES",
          style: TextStyle(
            color: Color(0xffe17f2f),
            fontSize: 15,
            fontWeight: FontWeight.bold
          ),
        )));
  }
}

class BottleListTableItem extends StatefulWidget {
   BottleListTableItem(
      {
        super.key,
        required this.collection,
        required this.editMode,
        this.onPressRemove,
        this.onUpdateComplete
      });

  GroupedCollection collection;
  bool editMode;
  void Function(GroupedCollection)? onPressRemove;
  void Function(GroupedCollection)? onUpdateComplete;

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
    updateCount();
    super.initState();
  }

  void updateCount() {
    count = int.parse(widget.collection.count!);        
    setState(() {
      initCount = count;
    });
  }

  @override
  void didUpdateWidget(covariant BottleListTableItem oldWidget) {
    if ( oldWidget.collection.count != widget.collection.count! ) {
      updateCount();
    }
    super.didUpdateWidget(oldWidget);
  }

  // @override
  // void didChangeDependencies() {
  //   print(widget.collection.blueBook!.bottleName!);
  //   print(count);
  //   super.didChangeDependencies();
  // }

  @override
  void dispose() {
    _debounceTimer?.cancel(); // Clean up timer
    super.dispose();
  }

   // Debounced API call
  void _debouncedUpdate() {
    _debounceTimer?.cancel(); // Cancel any existing timer
    _debounceTimer = Timer(Duration(seconds: 1),  () async {
      await CollectionApi.addBulk(
        widget.collection.blueBook!.id!,
        controller.user.value.id,
        widget.collection.type == CollectionType.normal.name ?
          CollectionType.normal :
          CollectionType.wishlist,
        // params
        quantity: count
      );

      if ( widget.onUpdateComplete != null ) widget.onUpdateComplete!(widget.collection);
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
