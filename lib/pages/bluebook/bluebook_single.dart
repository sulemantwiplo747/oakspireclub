import 'package:flutter/material.dart';

import 'package:bourboneur/common/login_wrapper.dart';
import 'package:bourboneur/common/staggered_item_animation.dart';
import 'package:bourboneur/pages/bluebook/price_range_bar.dart';

class BlueBookSinglePage extends StatefulWidget {
  const BlueBookSinglePage({super.key});

  @override
  State<BlueBookSinglePage> createState() => _BlueBookSinglePageState();
}

class _BlueBookSinglePageState extends State<BlueBookSinglePage> {
  // ────────────────────────────────────────────────
  // Constants & Styles
  // ────────────────────────────────────────────────

  static const _spacingSmall = 12.0;
  static const _spacingMedium = 16.0;
  static const _spacingLarge = 24.0;

  static const _borderColor = Colors.white;
  static const _borderWidth = 2.0;
  static const _borderRadius = 12.0;
  static const _cardBorderRadius = 20.0;

  static const _titleColor = Color(0xfffe8003);
  static const _subtitleColor = Color(0xffbfbfad);

  // ────────────────────────────────────────────────
  // Builders
  // ────────────────────────────────────────────────

  Widget _buildActionButton(String label) {
    return StaggeredItemAnimation(
      index: 2,
      child: GestureDetector(
        onTap: () {}, // ← TODO: implement action
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
      child: SafeArea(
        child: SingleChildScrollView(
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
              const Text(
                "Old Forester 1910",
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
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _borderColor,
                              width: _borderWidth,
                            ),
                            borderRadius: BorderRadius.circular(_cardBorderRadius),
                          ),
                          child: Image.asset(
                            "assets/images/bottle.png",
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
                          _buildActionButton("ANALYZE A TRADE"),
                          const SizedBox(height: _spacingSmall),
                          _buildActionButton("ADD TO WISHLIST"),
                          const SizedBox(height: _spacingSmall),
                          _buildActionButton("ADD TO COLLECTION"),

                          const Spacer(),

                          // Average Price
                          StaggeredItemAnimation(
                            child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "\$55.00",
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
                          )
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
                child: const PriceRangeBar(
                  lowPrice: 52,
                  highPrice: 62,
                  currentPrice: 55,
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
                  border: Border.all(color: _borderColor, width: _borderWidth),
                  borderRadius: BorderRadius.circular(_borderRadius),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTrendIndicator(
                      icon: Icons.circle,
                      color: const Color(0xffffffcc),
                      label: "10-Day\nSTEADY",
                    ),
                    _buildTrendIndicator(
                      icon: Icons.circle,
                      color: const Color(0xffffffcc),
                      label: "10-Day\nSTEADY",
                    ),
                    _buildTrendIndicator(
                      icon: Icons.arrow_drop_up_sharp,
                      color: const Color(0xff92d050),
                      label: "90-Day\nUP",
                    ),
                  ],
                ),
              )),

              const SizedBox(height: 32), // bottom padding
            ],
          ),
        ),
      ),
    );
  }
}