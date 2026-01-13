import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/common/login_wrapper.dart';
import 'package:bourboneur/pages/TradeAnalyzerPage.dart';
import 'package:bourboneur/pages/blog.dart';
import 'package:bourboneur/pages/bluebook.dart';
import 'package:bourboneur/pages/bourbonuer_testing.dart';
import 'package:bourboneur/pages/chart_page.dart';
import 'package:bourboneur/pages/explore.dart';
import 'package:bourboneur/pages/good_pour.dart';
import 'package:bourboneur/pages/home.dart';
import 'package:bourboneur/pages/my_bottles.dart';
import 'package:bourboneur/pages/select_package.dart';
import 'package:bourboneur/pages/settings.dart';
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

  int pageIndex = 2;

  @override
  void initState() {
    super.initState();
  }
  

  void onTap(int index) {    
    setState(() {
      pageIndex = index;
    });
  }

  static const List<Widget> _pages = <Widget>[
    MyBottles(),    
    Center(child: Text('Page 2', style: TextStyle(fontSize: 30))),
    Home(),
    Center(child: Text('Page 4', style: TextStyle(fontSize: 30))),
    Center(child: Text('Page 5', style: TextStyle(fontSize: 30))),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return LoginWrapper(
      onTapNav: onTap,
      child: _pages[pageIndex]
    );
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
