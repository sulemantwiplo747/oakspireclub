import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/Core/Controllers/BlueBooks.dart';
import 'package:bourboneur/Core/Controllers/GroupedCollection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class MyBottlesList extends StatelessWidget {
  final List<GroupedCollection> bottles;
  final Function(GroupedCollection)? onBottleTap; // passing bottle data
  Controller controller = Get.find<Controller>();
  Future<bool?> Function(DismissDirection, GroupedCollection) confirmDismiss;

  MyBottlesList({
    super.key,
    required this.bottles,
    required this.onBottleTap,
    required this.confirmDismiss
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.only(top: 15),
      child: ListView.separated(
        itemCount: bottles.length,
        separatorBuilder: (context, index) => const SizedBox(height: 7),
        itemBuilder: (context, index) {
          final bottle = bottles[index];

          return Dismissible(
            key: ValueKey(bottle.blueBook!.bottleName.toString() + index.toString()),

            // Background when swiping from left → right (start)
            background: Container(              
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              decoration: const BoxDecoration(
                color: Color(0xff92d050),
                borderRadius: BorderRadius.all(Radius.circular(15))
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 32,
              ),
              
            ),

            // Secondary background when swiping from right → left (end)
            secondaryBackground: Container(              
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
               decoration: const BoxDecoration(
                color: Color(0xffff0000),
                borderRadius: BorderRadius.all(Radius.circular(15))
              ),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
                size: 32,
              ),
            ),

            // Which directions are allowed
            direction: DismissDirection.horizontal,

            // Optional: You can ask for confirmation (especially useful for delete)
            confirmDismiss:  (DismissDirection d)  async {
                return await confirmDismiss(d, bottle);
            },

            // This is called when the item is fully swiped away
            // onDismissed: (direction) {
              
            //   if (direction == DismissDirection.endToStart) {
            //     print("Delete");
            //   }
            // },

            child: MyBottlesItem(
              onTap: onBottleTap,
              imagePlaceHolder: controller.config.value.pourImagePlaceHolder!,
              imageUrl:  controller.config.value.uploadUrl!,
              collections: bottle
            ),
          );
        },
      ),
    );
  }
}


class MyBottlesItem extends StatelessWidget {  
  final Function(GroupedCollection)? onTap;   
  final GroupedCollection collections;
  String? imagePlaceHolder;
  String? imageUrl;

  MyBottlesItem({
    super.key,
    required this.collections,    
    this.onTap,        
    this.imagePlaceHolder,
    this.imageUrl
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if ( onTap != null ) onTap!(collections);
      },
      child: Container(
        // margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xff2d2d2d),
          borderRadius: BorderRadius.circular(15),                  
        ),
        child: Row(
          children: [
            // Image container
            Container(
              padding: const EdgeInsets.all(4),
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.network(
                collections.image == null ? imagePlaceHolder! : imageUrl! + '/' + collections.image!,
                fit: BoxFit.contain
              ),
            ),

            const SizedBox(width: 14),

            // Flexible text area
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    collections.blueBook!.bottleName.toString() ,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                     "\$${collections.pricePaid} (${collections.count})",
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Status icon
            Icon(
              Icons.check_circle_outline,
              size: 24,
              color: Colors.grey[700],
            ),
          ],
        ),
      ),
    );
  }
}
