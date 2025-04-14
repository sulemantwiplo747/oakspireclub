import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/common/login_wrapper.dart';
import 'package:bourboneur/pages/bluebook.dart';
import 'package:bourboneur/pages/chart_page.dart';
import 'package:bourboneur/pages/explore.dart';
import 'package:bourboneur/pages/my_ratings.dart';
import 'package:bourboneur/pages/pour.dart';
import 'package:bourboneur/pages/wheel_of_destiny.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTesting extends StatefulWidget {
  const MyTesting({super.key});

  @override
  State<MyTesting> createState() => _MyTestingState();
}

class _MyTestingState extends State<MyTesting> {
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 70,
          ),
          Container(
            // height: 270,
            padding: const EdgeInsets.only(left: 20, right: 20),
            // decoration: const BoxDecoration(
            //     //color: Colors.red,
            //     image: DecorationImage(
            //         image: AssetImage("assets/images/new-dashboard.jpg"),
            //         alignment: Alignment.center,
            //         repeat: ImageRepeat.noRepeat)),
            child: const Column(
              children: [
                Text(
                  //"Elevate\nYour Spirit",
                  "Rank and rate the\nbourbons you try to\ncreate your own personal\nbourbon top list.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Arial',
                      color: Color(0xffe17f2f),
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      height: 1.2),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Color(0xffead400), size: 37),
                    Icon(Icons.star, color: Color(0xffead400), size: 37),
                    Icon(Icons.star, color: Color(0xffead400), size: 37),
                    Icon(Icons.star, color: Color(0xffead400), size: 37),
                    Icon(Icons.star_border, color: Color(0xffead400), size: 37),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          LinkItem(
            text: "Add a New Pour",
            color: const Color(0xFFe59d46),
            onTap: () {
              Get.to(() => PourPage());
            },
          ),
          LinkItem(
            text: "My Ratings",
            color: const Color(0xFFdd871f),
            onTap: () {
              Get.to(() => MyRatings());
            },
          ),
        ],
      ),
    ));
  }
}

class LinkItem extends StatelessWidget {
  LinkItem({super.key, required this.text, this.color, this.onTap});

  final String text;
  final Color? color;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15,),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15, top: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: color,
              border: Border(
                  top: BorderSide(
                      width: 1,
                      color: Theme.of(context).colorScheme.background))),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.background,
                fontFamily: 'TradeGothic',
                fontWeight: FontWeight.bold,
                fontSize: 22),
          ),
        ),
      ),
    );
  }
}
