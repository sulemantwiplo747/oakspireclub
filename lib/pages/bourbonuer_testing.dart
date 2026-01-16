import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/common/login_wrapper.dart';
import 'package:bourboneur/pages/explore.dart';
import 'package:bourboneur/pages/favorite_pour.dart';
import 'package:bourboneur/pages/my_testing.dart';
import 'package:bourboneur/pages/testing/testing_content.dart';
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
    return Stack(      
      children: [
        Container(
          height: double.infinity,
        ),
        Positioned.fill(
          bottom: 0,
          child: Image.asset(
            'assets/images/new_bg.png',
            fit: BoxFit.fitWidth, // or BoxFit.contain if you don't want cropping
            alignment: Alignment.bottomCenter,
          ),
        ),
        TestingContent()
        // HomeContent(
        //   changeTab: widget.changeTab
        // ),
        // Container(
        // //   color: Colors.red,
        // //   height: double.infinity,
        // // ),
      ],
    );
  }
}
