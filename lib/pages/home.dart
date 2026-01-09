import 'package:bourboneur/pages/home/home_content.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
        HomeContent(),
        // Container(
        // //   color: Colors.red,
        // //   height: double.infinity,
        // // ),
      ],
    );
  }
}
