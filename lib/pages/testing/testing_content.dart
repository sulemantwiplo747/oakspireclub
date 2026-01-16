import 'package:bourboneur/common/staggered_item_animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

class TestingContent extends StatefulWidget {
  const TestingContent({super.key});

  @override
  State<TestingContent> createState() => _TestingContentState();
}

class _TestingContentState extends State<TestingContent> {
  int _animateIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title with ®
            const Text.rich(
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Arial',
                color: Colors.white,
                fontSize: 35,
                height: 1,
                fontWeight: FontWeight.bold,
              ),
              TextSpan(text: "Bourbon Tasting"),
            ),

            // 1. Greeting
            StaggeredItemAnimation(
              index: ++_animateIndex,
              child: const Row(
                children: [
                  Expanded(
                    child: Text(
                      "Sip.  Savor.  Discover.",
                      style: TextStyle(
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
            const SizedBox(height: 30),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 15,
                    children: [
                      StaggeredItemAnimation(
                        index: ++_animateIndex,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.white),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: const Text(
                              "My Tasting Journal",
                              style: TextStyle(
                                fontSize: 17,
                                color: Color(0xffbfbfbf),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      //  SizedBox(height: 15),
                      StaggeredItemAnimation(
                        index: ++_animateIndex,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.white),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: const Text(
                              "Virtual Flavor Wheel",
                              style: TextStyle(
                                fontSize: 17,
                                color: Color(0xffbfbfbf),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      StaggeredItemAnimation(
                        index: ++_animateIndex,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.white),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: const Text(
                              "Favorite Pours",
                              style: TextStyle(
                                fontSize: 17,
                                color: Color(0xffbfbfbf),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15),
                StaggeredItemAnimation(
                  fadeOnly: true,
                  index: ++_animateIndex,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Image.asset(
                      "assets/images/bb-tasting.png",
                      height: 250,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),

            StaggeredItemAnimation(
                        index: ++_animateIndex,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.white),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: const Text(
                              "Bourbon Suggestions",                              
                              style: TextStyle(
                                fontSize: 22,
                                color: Color(0xffbfbfbf),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ),

           
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
