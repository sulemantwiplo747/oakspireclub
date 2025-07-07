import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/common/login_wrapper.dart';
import 'package:bourboneur/pages/TradeAnalyzerPage.dart';
import 'package:bourboneur/pages/blog.dart';
import 'package:bourboneur/pages/bluebook.dart';
import 'package:bourboneur/pages/bourbonuer_testing.dart';
import 'package:bourboneur/pages/chart_page.dart';
import 'package:bourboneur/pages/explore.dart';
import 'package:bourboneur/pages/good_pour.dart';
import 'package:bourboneur/pages/select_package.dart';
import 'package:bourboneur/pages/wheel_of_destiny.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Controller controller = Get.find<Controller>();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoginWrapper(
        child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Text("Cheers, ${controller.user.value.name!}",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Color(0xfffe8003),
                    fontFamily: 'TradeGothic',
                    fontWeight: FontWeight.bold,
                    fontSize: 22)),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/new-dashboard.png"),
                    alignment: Alignment.center,
                    repeat: ImageRepeat.noRepeat,
                    fit: BoxFit.cover)),
            child: Column(
              children: [
                DashBoardLinkItem(
                  flexible: true,
                  text: TextSpan(text: "Bourbon Blue Book", children: [
                    WidgetSpan(
                      child: Transform.translate(
                        offset: const Offset(2, -5),
                        child: const Text(
                          '®',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    )
                  ]),
                  onTap: () {
                    Get.to(() => const BlueBook());
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DashBoardLinkItem(
                      text: const TextSpan(text: "Trade\nAnalysis\nTool"),
                      onTap: () {
                        Get.to(() => TradeAnalyzerPage());
                      },
                    ),
                    DashBoardLinkItem(
                      text: const TextSpan(text: "My\nBottles"),
                      onTap: () {
                        Get.to(() => ChartPage());
                      },
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DashBoardLinkItem(
                      text: const TextSpan(text: "Wheel of\nDestiny"),
                      onTap: () {
                        Get.to(() => WheelOfDestiny());
                      },
                    ),
                    DashBoardLinkItem(
                      text: const TextSpan(text: "Bourbon\nTasting"),
                      onTap: () {
                        Get.to(() => BourbonuerTesting());
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DashBoardLinkItem(
                      text: const TextSpan(text: "Bourbon\nSuggestions"),
                      onTap: () {
                        Get.to(() => GoodPourPage());
                      },
                    ),
                    DashBoardLinkItem(
                      text: const TextSpan(text: "Bourboneur\nBlog"),
                      onTap: () {
                        Get.to(() => Blog());
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
          // Container(
          //   height: 270,
          //   padding: EdgeInsets.only(left: 130, top: 50),
          //   decoration: const BoxDecoration(
          //       //color: Colors.red,
          //       image: DecorationImage(
          //         image: AssetImage("assets/images/new-dashboard.jpg"),
          //         alignment: Alignment.center,
          //         repeat: ImageRepeat.noRepeat
          //     )),
          //   child: Text(
          //     //"Elevate\nYour Spirit",
          //     "",
          //     style: TextStyle(
          //         fontFamily: 'Arial',
          //         color: Theme.of(context).textTheme.titleMedium?.color,
          //         fontSize: 35,
          //         height: 1.2
          //       ),
          //   ),
          // ),

          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SocialIcon(
                onTap: () {
                  launchUrl(Uri.parse('https://www.facebook.com/Bourboneur/'));
                },
                icon: 'assets/images/social/facebook.png',
              ),
              const SizedBox(
                width: 20,
              ),
              SocialIcon(
                  onTap: () {
                    launchUrl(
                        Uri.parse('https://www.instagram.com/thebourboneur/'));
                  },
                  icon: 'assets/images/social/instagram.png'),
              const SizedBox(
                width: 20,
              ),
              SocialIcon(
                  onTap: () {
                    launchUrl(Uri.parse('https://www.tiktok.com/@bourboneur'));
                  },
                  icon: 'assets/images/social/tik-tok.png')
            ],
          )
        ],
      ),
    ));
  }
}

class DashBoardLinkItem extends StatelessWidget {
  DashBoardLinkItem(
      {super.key, required this.text, this.onTap, this.flexible = false});

  final TextSpan text;
  void Function()? onTap;

  bool flexible;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding:
            const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
        width: flexible != true ? 160 : null,
        height: flexible != true ? 120 : null,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background.withOpacity(.8),
            border: Border.all(
              color: const Color(0Xfffe8003),
              width: 3,
            )),
        child: Align(
          alignment: flexible != true ? Alignment.centerLeft : Alignment.center,
          child: Text.rich(text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontFamily: 'TradeGothic',
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                  fontSize: 21)),
        ),
      ),
    );
  }
}

class SocialIcon extends StatelessWidget {
  SocialIcon({super.key, this.onTap, required this.icon});

  void Function()? onTap;
  String icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: const BoxDecoration(
            color: Color(0xffff7520),
            borderRadius: BorderRadius.all(Radius.circular(50))),
        child: Image.asset(icon, width: 20),
      ),
    );
  }
}
