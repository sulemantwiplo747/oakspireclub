import 'package:bourboneur/common/login_wrapper.dart';
import 'package:bourboneur/pages/bottles_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ChooseBottleWhiskey extends StatefulWidget {
  const ChooseBottleWhiskey({super.key});

  @override
  State<ChooseBottleWhiskey> createState() => _ChooseBottleWhiskeyState();
}

class _ChooseBottleWhiskeyState extends State<ChooseBottleWhiskey> {
  @override
  Widget build(BuildContext context) {
    return LoginWrapper(
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      width: 120,
                      height: 160,
                      decoration: const BoxDecoration(
                          // color: Colors.red,
                          image: DecorationImage(
                              image: AssetImage('assets/images/whiskey.png'),
                              alignment: Alignment.topLeft,
                              fit: BoxFit.contain)),
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                         Text("HOW DOES",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: 'Arial',
                                color: Color(0xffe17f2f),
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                height: 1.2)),
                        SizedBox(height: 5),
                        Text("IT FEEL TO BE",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: 'Arial',
                                color: Color(0xffffc000),
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                height: 1.2)),
                        SizedBox(height: 5),
                        Text("WHISKEY WISE?",
                            textAlign: TextAlign.left,

                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontWeight: FontWeight.bold,
                              color: Color(0xfffbe5d6),
                              fontSize: 30,
                              height: 1.2,
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xfffbe5d6)
                            ),
                                
                        ),
                        SizedBox(height: 30),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  width: 300,
                  // color: Colors.blue,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => BottlesList());
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color(0xffe17f2f), width: 1),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            padding: const EdgeInsets.all(10),
                            child: const Text("BOTTLES",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontWeight: FontWeight.bold,
                                    color:  Colors.white,
                                    fontSize: 35,
                                    height: 1.2))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => BottlesList(
                                isWishlist: true,
                              ));
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color(0xffe17f2f), width: 1),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            padding: const EdgeInsets.all(10),
                            child: const Text("WISHLIST",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 35,
                                    height: 1.2))),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
