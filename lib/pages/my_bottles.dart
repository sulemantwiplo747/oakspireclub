import 'package:bourboneur/common/login_wrapper.dart';
import 'package:bourboneur/common/staggered_item_animation.dart';
import 'package:bourboneur/pages/my_bottles/filter_bottom_sheet.dart';
import 'package:bourboneur/pages/my_bottles/my_bottles_list.dart';
import 'package:flutter/material.dart';

class MyBottles extends StatefulWidget {
  const MyBottles({super.key});

  @override
  State<MyBottles> createState() => _MyBottlesState();
}

class _MyBottlesState extends State<MyBottles> {
  final List<Map<String, dynamic>> dummyBottles = [
    {
      'title': 'Johnnie Walker Blue Label Ghost & Rare',
      'price': '450',
      'quantity': 3,
      'image': 'assets/images/bottle.png',
      'selected': true,
    },
    {
      'title': 'Macallan 18 Year Old Sherry Oak',
      'price': '320',
      'quantity': 8,
      'image': 'assets/images/bottle.png',
      'selected': false,
    },
    {
      'title': 'Glenfiddich 21 Year Old Reserva Rum Cask Finish',
      'price': '185',
      'quantity': 12,
      'image': 'assets/images/bottle.png',
      'selected': false,
    },
    {
      'title': 'Hennessy XO Cognac Limited Edition',
      'price': '240',
      'quantity': 5,
      'image': 'assets/images/bottle.png',
      'selected': true,
    },
    {
      'title': 'Patrón Añejo Tequila Extra Aged',
      'price': '95',
      'quantity': 21,
      'image': 'assets/images/bottle.png',
      'selected': false,
    },
    {
      'title': 'Dom Pérignon Vintage Champagne 2013',
      'price': '380',
      'quantity': 2,
      'image': 'assets/images/bottle.png',
      'selected': false,
    },
    {
      'title': 'Dom Pérignon Vintage Champagne 2013',
      'price': '380',
      'quantity': 2,
      'image': 'assets/images/bottle.png',
      'selected': false,
    },
    {
      'title': 'Dom Pérignon Vintage Champagne 2013',
      'price': '380',
      'quantity': 2,
      'image': 'assets/images/bottle.png',
      'selected': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 15),
            StaggeredItemAnimation(
              index: 0,
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "My Bottles",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xfffe8003),
                      ),
                      softWrap: true,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Image.asset("assets/images/wheel.png", width: 40),
                  ),
                  const SizedBox(width: 7),
                  GestureDetector(
                    onTap: () {},
                    child: Image.asset("assets/images/plus.png", width: 30),
                  ),
                  const SizedBox(width: 7),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true, // important for nice look
                        backgroundColor: Colors.transparent,
                        builder: (context) => const FilterBottomSheet(),
                      );
                    },
                    child: Image.asset("assets/images/filter.png", width: 40),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // === SEARCH AREA ===== //
            TextField(
              // onChanged: _onSearchChanged,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                height: 2.5,
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(
                  top: 5,
                  bottom: 5,
                  left: 36, // ← space for icon
                  right: 12,
                ),
                hintText: "Search thousands of bottles",
                hintStyle: TextStyle(
                  color: Color.fromARGB(255, 180, 180, 180),
                  fontSize: 18,
                  height: 2.5,
                  fontWeight: FontWeight.bold,
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Icon(
                    Icons.search_rounded,
                    color: Color.fromARGB(
                      255,
                      255,
                      255,
                      255,
                    ), // matching your orange theme
                    size: 22,
                  ),
                ),
                prefixIconConstraints: BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 255, 255, 255),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 255, 255, 255),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 255, 255, 255),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                isDense: true,
                filled: false,
              ),
            ),

            // ==== LIST ====
            Expanded(
              child: Container(
                color: Colors.black,
                padding: const EdgeInsets.only(top: 15),
                child: MyBottlesList(bottles: dummyBottles, onBottleTap: () {}),
              ),
            ),

            // ==== IMPORT EXPORT BUTTON ====
            StaggeredItemAnimation(
              index: 2,
              child: Container(
                padding: EdgeInsetsGeometry.only(top: 15, bottom: 15),
                child: GestureDetector(
                  onTap: () {
                    // Get.to(() => BlueBook());
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.white),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: const Text(
                      "Import or Export",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
