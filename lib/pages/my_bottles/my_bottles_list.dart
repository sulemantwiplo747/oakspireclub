import 'package:flutter/material.dart';

class MyBottlesList extends StatelessWidget {
  final List<Map<String, dynamic>> bottles;
  final Function() onBottleTap; // passing bottle data

  const MyBottlesList({
    super.key,
    required this.bottles,
    required this.onBottleTap,
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
            key: ValueKey(bottle['title'].toString() + index.toString()),

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
            confirmDismiss: (direction) async {
              // For now we allow both directions without confirmation
              // Later you can add dialog only for delete direction
              // return true;
              return false;
            },

            // This is called when the item is fully swiped away
            onDismissed: (direction) {
              // For now - just empty placeholder
              // You will later remove item from list here
              // Example:
              // if (direction == DismissDirection.endToStart) {
              //   // delete action
              // }
            },

            child: MyBottlesItem(
              title: bottle['title'] as String,
              priceText: "\$${bottle['price']} (${bottle['quantity']})",
              imagePath: bottle['image'] as String,
              onTap: () => onBottleTap(),
            ),
          );
        },
      ),
    );
  }
}


class MyBottlesItem extends StatelessWidget {
  final String title; // Main name/description (long text)
  final String priceText; // e.g. "\$243 (11)"
  final String? imagePath; // Optional - custom image path  
  final VoidCallback? onTap; // Optional tap handler

  const MyBottlesItem({
    super.key,
    required this.title,
    required this.priceText,
    this.imagePath = "assets/images/bottle.png",
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
              child: Image.asset(imagePath!, fit: BoxFit.contain),
            ),

            const SizedBox(width: 14),

            // Flexible text area
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
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
                    priceText,
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
