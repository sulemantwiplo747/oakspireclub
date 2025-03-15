import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/common/login_wrapper.dart';
import 'package:bourboneur/pages/explore.dart';
import 'package:bourboneur/pages/favorite_pour.dart';
import 'package:bourboneur/pages/my_testing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BourbonuerTesting extends StatefulWidget {
  const BourbonuerTesting({super.key});

  @override
  State<BourbonuerTesting> createState() => _BourbonuerTestingState();
}

class _BourbonuerTestingState extends State<BourbonuerTesting> {
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
                    repeat: ImageRepeat.noRepeat)),
            child: Text(
              //"Elevate\nYour Spirit",
              "",
              style: TextStyle(
                  fontFamily: 'Arial',
                  color: Theme.of(context).textTheme.titleMedium?.color,
                  fontSize: 35,
                  height: 1.2),
            ),
          ),
          LinkItem(
            text: "What do I Taste?",
            color: const Color(0xFFbe6720),
            onTap: () {
              Get.to(() => ExplorePage());
            },
          ),
          LinkItem(
            text: "My Tasting",
            color: Color(0xFFeeb775),
            onTap: () {
              Get.to(() => MyTesting());
            },
          ),
          LinkItem(
            text: "Favorite Pours",
            color: Color(0xFFe59d46),
            onTap: () {
              Get.to(() => FavoritePour());
            },
          ),
          LinkItem(
            text: "Get the Right Glass",
            color: Color(0xFFdd871f),
            onTap: () {
              launchUrlString('https://www.bourboneur.com/shop', mode: LaunchMode.externalApplication);
              // Get.to(() => ExplorePage());
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
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.only(left: 20, top: 15, bottom: 15, right: 20),
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
