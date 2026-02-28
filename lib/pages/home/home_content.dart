import 'package:bourboneur/Core/Apis/Collection.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/common/staggered_item_animation.dart';
import 'package:bourboneur/pages/blog.dart';
import 'package:bourboneur/pages/bluebook.dart';
import 'package:bourboneur/pages/chart_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeContent extends StatefulWidget {
  HomeContent({super.key, this.changeTab});

  void Function(int, dynamic)? changeTab;
  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  Controller controller = Get.find<Controller>();
  String? diff = "0.00";
  String? lastPrice = "0.00";
  bool upTrend = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    var chartData = await CollectionApi.getChartData(
      controller.user.value.id!,
      90,
    );
    chartData = chartData['data'];

    if ( chartData.length < 1 ) return;
    
    final String first = chartData[0]['price'];
    final String last = chartData[chartData.length - 1]['price'];

    
    double percent = (100 - (double.parse(first) / double.parse(last)) * 100);
    upTrend = percent > 0;

    var formatter = NumberFormat.currency(
      locale: 'en_US',         
      symbol: '\$',
      decimalDigits: 2,
    );

    diff = "${formatter.format((double.parse(first) - double.parse(last)))} (${percent.toStringAsFixed(2)}%)";

    formatter = NumberFormat.compact(
      locale: 'en_US',   
    );
    lastPrice = formatter.format(double.parse(last));
    // lastPrice = double.parse(last);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Greeting
            StaggeredItemAnimation(
              index: 0,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Cheers, ${controller.user.value.name}.",
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xfffe8003),
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // 2. Collection Value Card
            StaggeredItemAnimation(
              index: 1,
              child: GestureDetector(
                onTap: () {
                  Get.to(() => ChartPage( changeTab: widget.changeTab ))?.then((result) {
                    getData();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.white),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Collection Value",
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        '\$${lastPrice!}',
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                       Row(
                        children: [
                          Icon(
                            upTrend ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                            color: upTrend ? const Color(0xff92d050) : Colors.red,
                            size: 35,
                          ),
                          Text(
                            diff!,
                            style: TextStyle(
                              fontSize: 16,
                              color: upTrend ? const Color(0xff92d050) : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "3 months",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 3. Bourbon Blue Book Card
            StaggeredItemAnimation(
              index: 2,
              child: GestureDetector(
                onTap: () {
                  widget.changeTab!(4, null);
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.white),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: const Text(
                    "Bourbon Blue Book®",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 4. Blog + Social Row
            StaggeredItemAnimation(
              index: 3,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => Blog());
                    },
                    child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.white),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: const Text(
                      "Blog",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.white),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            "Social",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          SocialIcon(
                            onTap: () async {
                              final uri = Uri.parse(
                                'https://www.facebook.com/Bourboneur/',
                              );
                              if (await canLaunchUrl(uri)) await launchUrl(uri);
                            },
                            icon: 'assets/images/social/facebook.png',
                          ),
                          const Spacer(),
                          
                          SocialIcon(
                            onTap: () async {
                              final uri = Uri.parse(
                                'https://www.instagram.com/thebourboneur/',
                              );
                              if (await canLaunchUrl(uri)) await launchUrl(uri);
                            },
                            icon: 'assets/images/social/instagram.png',
                          ),
                          const Spacer(),
                          SocialIcon(
                            onTap: () async {
                              final uri = Uri.parse(
                                'https://www.tiktok.com/@bourboneur',
                              );
                              if (await canLaunchUrl(uri)) await launchUrl(uri);
                            },
                            icon: 'assets/images/social/tik-tok.png',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// SocialIcon remains unchanged
class SocialIcon extends StatelessWidget {
  const SocialIcon({super.key, required this.onTap, required this.icon});

  final VoidCallback? onTap;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: const BoxDecoration(
          color: Color(0xffff7520),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        child: Image.asset(icon, width: 17, height: 17),
      ),
    );
  }
}
