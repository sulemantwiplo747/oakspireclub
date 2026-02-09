import 'package:bourboneur/Core/Apis/Collection.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/Core/Controllers/BlueBooks.dart';
import 'package:bourboneur/Core/Controllers/GroupedCollection.dart';
import 'package:bourboneur/common/login_wrapper.dart';
import 'package:bourboneur/common/staggered_item_animation.dart';
import 'package:bourboneur/pages/bottles_search.dart';
import 'package:bourboneur/pages/my_bottles/bottles_search.dart';
import 'package:bourboneur/pages/my_bottles/filter_bottom_sheet.dart';
import 'package:bourboneur/pages/my_bottles/add_to_collection.dart';
import 'package:bourboneur/pages/my_bottles/my_bottles_list.dart';
import 'package:bourboneur/pages/my_bottles/my_bottles_single.dart';
import 'package:bourboneur/pages/wheel_of_destiny.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyBottles extends StatefulWidget {
  MyBottles({super.key, this.changeTab, this.pageData});
  void Function(int, dynamic data)? changeTab;
  dynamic pageData;

  @override
  State<MyBottles> createState() => _MyBottlesState();
}

class _MyBottlesState extends State<MyBottles> {
  Controller controller = Get.find<Controller>();
  bool isLoading = true;
  String currentSort = 'name_asc';

  final RxString searchQuery = ''.obs;
  final RxList<GroupedCollection> groupedFiltered = <GroupedCollection>[].obs;

  @override
  void initState() {
    super.initState();

    getListItems();

    debounce(searchQuery, (query) {
      filterBottles(query);
    }, time: const Duration(milliseconds: 350));
  }

  void applySort(String sortKey) {
    setState(() {
      currentSort = sortKey;
    });

    // Re-apply current filter + new sort
    filterBottles(searchQuery.value);
  }

  void filterBottles(String query) {
    List<GroupedCollection> baseList;

    if (query.isEmpty) {
      baseList = List.from(controller.groupedCollections);
    } else {
      final lowerQuery = query.toLowerCase().trim();
      baseList = controller.groupedCollections.where((group) {
        if (group.blueBook?.bottleName?.toLowerCase().contains(lowerQuery) ??
            false) {
          return true;
        }

        return false;
      }).toList();
    }

    // ─── Apply sorting ───────────────────────────────
    baseList.sort((a, b) {
      switch (currentSort) {
        case 'name_asc':
          return (a.blueBook?.bottleName ?? '').toLowerCase().compareTo(
            (b.blueBook?.bottleName ?? '').toLowerCase(),
          );

        case 'name_desc':
          return (b.blueBook?.bottleName ?? '').toLowerCase().compareTo(
            (a.blueBook?.bottleName ?? '').toLowerCase(),
          );

        // ── Time (assuming you have .createdAt or .addedAt as DateTime) ──
        case 'time_desc':
          final da = double.parse(a.createdAt!);
          final db = double.parse(b.createdAt!);
          return db.compareTo(da);

        case 'time_asc':
          final da = double.parse(a.createdAt!);
          final db = double.parse(b.createdAt!);
          return da.compareTo(db);

        case 'price_desc':
          final pa = double.parse(b.blueBook!.average!);
          final pb = double.parse(b.blueBook!.average!);
          return pb.compareTo(pa);

        case 'price_asc':
          final pa = double.parse(b.blueBook!.average!);
          final pb = double.parse(b.blueBook!.average!);
          return pa.compareTo(pb);

        case 'fullest':
          final qa = double.parse(a.fill!);
          final qb = double.parse(b.fill!);
          return qa.compareTo(qb);

        case 'emptiest':
          final qa = double.parse(a.fill!);
          final qb = double.parse(b.fill!);
          return qb.compareTo(qa);

        default:
          return 0; // no change
      }
    });

    groupedFiltered.assignAll(baseList);
  }

  getListItems() async {
    setState(() {
      isLoading = true;
    });

    await CollectionApi.grouped(
      controller.user.value.id!,
      CollectionType.normal,
    );

    groupedFiltered.assignAll(controller.groupedCollections);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    searchQuery.close();
    groupedFiltered.close();
    super.dispose();
  }

  onBottleTap(GroupedCollection collection) {
    Get.to(() => MyBottlesSingle(collection: collection));
  }

  Future<bool?> onSwipe(DismissDirection d, GroupedCollection collection) async {
    int q = int.parse(collection.count!);
    bool isDeleteAll = false;
    setState(() {
      isLoading = true;
    });
    if ( d == DismissDirection.endToStart ) {
      int newQ = q - 1;
      isDeleteAll = newQ == 0;
      await CollectionApi.add(
        collection.blueBook!.id!,
        controller.user.value.id!,
        CollectionType.normal,
        quantity: newQ,
        fill: double.parse(collection.fill!).toInt(),
        paidPrice: double.tryParse(collection.pricePaid!) ?? 0.0,
        image: collection.image ?? collection.blueBook!.image!
      );
      
    } else {
      int newQ = q + 1;
       await CollectionApi.add(
        collection.blueBook!.id!,
        controller.user.value.id!,
        CollectionType.normal,
        quantity: newQ,
        fill: double.parse(collection.fill!).toInt(),
        paidPrice: double.tryParse(collection.pricePaid!) ?? 0.0,
        image: collection.image ?? collection.blueBook!.image!
      );
    }

    getListItems();

    filterBottles(searchQuery.value);
    
    setState(() {
      isLoading = false;
    });

    return isDeleteAll;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Padding(
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
                        onTap: () {
                          Get.to(() => WheelOfDestiny());
                        },
                        child: Image.asset(
                          "assets/images/wheel.png",
                          width: 40,
                        ),
                      ),
                      const SizedBox(width: 7),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => AddToCollection())?.then((v) {
                            getListItems();
                          });
                        },
                        child: Image.asset("assets/images/plus.png", width: 30),
                      ),
                      const SizedBox(width: 7),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true, // important for nice look
                            backgroundColor: Colors.transparent,
                            builder: (context) => FilterBottomSheet(
                              initialSort: currentSort,
                              onApply: applySort,
                            ),
                          );
                        },
                        child: Image.asset(
                          "assets/images/filter.png",
                          width: 40,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // === SEARCH AREA ===== //
                BottlesSearchInput(
                  // readOnly: true,
                  onChange: (v) {
                    searchQuery.value = v;
                    // print(v);
                    //  Get.to(() => BottlesSearchPage(
                    //             pageType: SearchPageType.normal,
                    //           ))?.then(onBack);
                  },
                ),

                // ==== LIST ====
                Expanded(
                  child: Container(
                    color: Colors.black,
                    padding: const EdgeInsets.only(top: 15),
                    child: groupedFiltered.isEmpty && searchQuery.isNotEmpty
                        ? const Center(
                            child: Text(
                              "No bottles found",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                            ),
                          )
                        : Obx((() {
                            return MyBottlesList(
                              confirmDismiss: onSwipe,
                              bottles: groupedFiltered
                                  .toList(), // ← use filtered list
                              onBottleTap: onBottleTap,
                            );
                          })),
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
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
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
          if (isLoading)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color.fromARGB(17, 0, 0, 0),
              child: Center(
                child: CircularProgressIndicator(color: Color(0xffff7522)),
              ),
            ),
        ],
      ),
    );
  }
}
