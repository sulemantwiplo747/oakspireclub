import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/common/login_wrapper.dart';
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
    return  LoginWrapper(
        child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 270,            
            padding: EdgeInsets.only(left: 130, top: 50),
            decoration: const BoxDecoration(
                //color: Colors.red,
                image: DecorationImage(
                  image: AssetImage("assets/images/new-dashboard.jpg"),
                  alignment: Alignment.center,
                  repeat: ImageRepeat.noRepeat
              )),
            child: Text(
              //"Elevate\nYour Spirit",
              "",
              style: TextStyle(
                  fontFamily: 'Arial',
                  color: Theme.of(context).textTheme.titleMedium?.color,                  
                  fontSize: 35,
                  height: 1.2         
                ),
            ),
          ),
          DashBoardLinkItem(
            text: "My Bottles",
            color: const Color(0xFFbe6720),
            onTap: () {
              Get.to(() => ChartPage() );
            },
          ),
          DashBoardLinkItem(
            text: "Bourbon Blue Book",
            color: Color(0xFFeeb775),
            onTap: () {
              Get.to(() => BlueBook());
            },
          ),
          DashBoardLinkItem(
            text: "Wheel of Destiny",
            color: Color(0xFFe59d46),
            onTap: () {
              Get.to(() => WheelOfDestiny());
            },
          ),
          DashBoardLinkItem(
            text: "Bourbon Testing",
            color: Color(0xFFdd871f),
            onTap: () {
              Get.to(() => BourbonuerTesting());
            },
          ),
          // DashBoardLinkItem(
          //   text: "Explore Your Bourbon",
          //   color: Color(0xFFdd871f),
          //   onTap: () {
          //     Get.to(() => ExplorePage());
          //   },
          // ),
          DashBoardLinkItem(
            text: "Bourbon Suggestions By Taste",
            color: Color(0xFFc05915),
            onTap: () {
              Get.to(() => GoodPourPage());
            },
          ),
          DashBoardLinkItem(
            text: "Bourboneur Blog",
            color: const Color(0xFFbe6720),
            onTap: () {
              Get.to(() => Blog());
            },
          ),
          const SizedBox(
            height: 40,
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
                  launchUrl(Uri.parse('https://www.instagram.com/thebourboneur/'));
                },
                icon: 'assets/images/social/instagram.png'
              ),
              const SizedBox(
                width: 20,
              ),
              SocialIcon(
                onTap: () {
                  launchUrl(Uri.parse('https://www.tiktok.com/@bourboneur'));
                },
                icon: 'assets/images/social/tik-tok.png'
              )
            ],
          )
        ],
      ),
    ));
  }
}

class DashBoardLinkItem extends StatelessWidget {
  DashBoardLinkItem({super.key, required this.text, this.color, this.onTap});

  final String text;
  final Color? color;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: color,
            border: Border(
                top: BorderSide(
                    width: 1,
                    color: Theme.of(context).colorScheme.background))),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.background,
              fontFamily: 'TradeGothic',
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
      ),
    );
  }
}

class SocialIcon extends StatelessWidget {
  SocialIcon({
    super.key,
    this.onTap,
    required this.icon
  });

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
          borderRadius: BorderRadius.all(Radius.circular(50))
        ),
        child: Image.asset(icon, width: 20),
      ),
    );
  }
}