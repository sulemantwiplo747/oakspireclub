import 'package:bourboneur/Core/Apis/Bluebook.dart';
import 'package:bourboneur/Core/Apis/Collection.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/Core/Controllers/BlueBooks.dart';
import 'package:bourboneur/Core/Controllers/Collection.dart';
import 'package:bourboneur/pages/my_bottles/add_to_collection.dart';
import 'package:flutter/material.dart';

import 'package:bourboneur/common/login_wrapper.dart';
import 'package:bourboneur/common/staggered_item_animation.dart';
import 'package:bourboneur/pages/bluebook/price_range_bar.dart';
import 'package:get/get.dart';

class BlueBookSinglePage extends StatefulWidget {
  BlueBookSinglePage({super.key, required this.blueBook, this.changeTab});

  BlueBook blueBook;
  void Function(int, dynamic)? changeTab;

  @override
  State<BlueBookSinglePage> createState() => _BlueBookSinglePageState();
}

class _BlueBookSinglePageState extends State<BlueBookSinglePage> {
  Controller controller = Get.find<Controller>();

  static const _spacingSmall = 12.0;
  static const _spacingMedium = 16.0;
  static const _spacingLarge = 24.0;

  static const _borderColor = Colors.white;
  static const _borderWidth = 2.0;
  static const _borderRadius = 12.0;
  static const _cardBorderRadius = 20.0;

  static const _titleColor = Color(0xfffe8003);
  static const _subtitleColor = Color(0xffbfbfad);

  Collection? wishCollection;
  Map? trends;

  bool isBusy = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    updateCollection();
    var data = await BlueBookApi.getPriceHistoryById(widget.blueBook.id!);
    trends = data['trend'];
    isBusy = false;
    setState(() {});
  }

  updateCollection() async {
    var data = await CollectionApi.isInCollection(
      controller.user.value.id!,
      widget.blueBook.id!,
      CollectionType.wishlist,
    );
    wishCollection = data != false ? Collection.fromJson(data) : null;
  }

  getTrend(key) {
    var price = trends != null ? trends![key] : "0";
    price = double.parse(price.toString());

    if (price > 2)
      return 'UP';
    else if (price < -2)
      return 'DOWN';
    else
      return 'STEADY';
  }

  IconData getTendArrow(key) {
    String trend = getTrend(key);

    if (trend == 'UP') {
      return Icons.arrow_drop_up_sharp;
    } else if (trend == 'DOWN') {
      return Icons.arrow_drop_down_sharp;
    } else {
      return Icons.circle;
    }
  }

  Color getColor(key) {
    String trend = getTrend(key);

    if (trend == 'UP') {
      return const Color(0xff92d050);
    } else if (trend == 'DOWN') {
      return const Color.fromARGB(255, 189, 74, 45);
    } else {
      return const Color(0xffffffcc);
    }
  }

  void _onTapWishList() async {
    isBusy = true;
    setState(() {});
    if (wishCollection == null) {
      //add
      await CollectionApi.add(
        widget.blueBook.id!,
        controller.user.value.id!,
        CollectionType.wishlist,
      );
    } else {
      // remove
      await CollectionApi.remove(wishCollection!.id!);
    }

    updateCollection();
    isBusy = false;
    setState(() {});
  }

  void _onTapAnalyze() {
    Navigator.pop(context);
    widget.changeTab!(3, widget.blueBook);
  }

  void _onTapCollection() async {
    Get.to(() => AddToCollection(blueBook: widget.blueBook));
  }

  // ────────────────────────────────────────────────
  // Builders
  // ────────────────────────────────────────────────

  Widget _buildActionButton(String label, {void Function()? onTap}) {
    return StaggeredItemAnimation(
      index: 2,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
          decoration: BoxDecoration(
            border: Border.all(color: _borderColor, width: _borderWidth),
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: _subtitleColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrendIndicator({
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 40),
        const SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            height: 1.2,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoginWrapper(
      showBottomNavigator: false,
      child: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(17),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),

                  // Page Title
                  const Text(
                    "Pricing Card",
                    style: TextStyle(
                      fontFamily: 'Arial',
                      color: Colors.white,
                      fontSize: 35,
                      height: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Bottle Name
                  Text(
                    widget.blueBook.bottleName!,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: _titleColor,
                    ),
                  ),

                  const SizedBox(height: _spacingLarge),

                  // Main content card (image + info)
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Bottle Image
                        Expanded(
                          flex: 5,
                          child: StaggeredItemAnimation(
                            index: 2,
                            child: Container(
                              // padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: _borderColor,
                                  width: _borderWidth,
                                ),
                                borderRadius: BorderRadius.circular(
                                  _cardBorderRadius,
                                ),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Image.network(
                                
                                widget.blueBook.image == null
                                    ? controller
                                          .config
                                          .value
                                          .pourImagePlaceHolder!
                                    : controller.config.value.uploadUrl! +
                                          '/' +
                                          widget.blueBook.image!,
                                fit: BoxFit.contain,
                                height: 280,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: _spacingMedium),

                        // Info & Actions
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildActionButton(
                                "ANALYZE A TRADE",
                                onTap: _onTapAnalyze,
                              ),
                              const SizedBox(height: _spacingSmall),
                              _buildActionButton(
                                wishCollection == null
                                    ? "ADD TO WISHLIST"
                                    : "REMOVE WISHLIST",
                                onTap: _onTapWishList,
                              ),
                              const SizedBox(height: _spacingSmall),
                              _buildActionButton(
                                "ADD TO COLLECTION",
                                onTap: _onTapCollection,
                              ),

                              const Spacer(),

                              // Average Price
                              StaggeredItemAnimation(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "\$${widget.blueBook.average}",
                                      style: TextStyle(
                                        fontSize: 36,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "AVERAGE PRICE",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: _subtitleColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                index: 4,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: _spacingMedium),

                  // Price Range Bar
                  StaggeredItemAnimation(
                    index: 3,
                    child: PriceRangeBar(
                      lowPrice: double.parse(widget.blueBook.low!),
                      highPrice: double.parse(widget.blueBook.high!),
                      currentPrice: double.parse(widget.blueBook.average!),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Trend Indicators
                  StaggeredItemAnimation(
                    index: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _borderColor,
                          width: _borderWidth,
                        ),
                        borderRadius: BorderRadius.circular(_borderRadius),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildTrendIndicator(
                            icon: getTendArrow('10days'),
                            color: getColor('10days'),
                            label: "10-Day\n${getTrend('10days')}",
                          ),
                          _buildTrendIndicator(
                            icon: getTendArrow('30days'),
                            color: getColor('30days'),
                            label: "30-Day\n${getTrend('30days')}",
                          ),
                          _buildTrendIndicator(
                            icon: getTendArrow('90days'),
                            color: getColor('90days'),
                            label: "90-Day\n${getTrend('90days')}",
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32), // bottom padding
                ],
              ),
            ),
            if (isBusy)
              Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.black.withOpacity(0.45),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xfffe8003),
                    ),
                    strokeWidth: 4,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
