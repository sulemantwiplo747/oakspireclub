import 'dart:async';
import 'dart:io';

import 'package:bourboneur/Core/Apis/Config.dart';
import 'package:bourboneur/Core/Apis/Firebase.dart';
import 'package:bourboneur/Core/Apis/User.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/Core/Utils.dart';
import 'package:bourboneur/pages/page_helpers/open_dashboard.dart';
import 'package:bourboneur/pages/sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:video_player/video_player.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  Controller controller = Get.find<Controller>();

  Utils utils = Utils();

  late AnimationController _controller;
  late Animation<Offset> _bgSlideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _bgSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start fully below the screen
      end: Offset.zero, // End at normal position
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // Start the animation as soon as the screen loads
    _controller.forward();
    Timer(const Duration(seconds: 3), () {
      _prepareToLaunch();
    });
  }

  _prepareToLaunch() async {
    await _getConfig();
    await _versionCheck(() async {
      await _tryToLogin();
    });
  }

  Future<void> _tryToLogin() async {
    String? id = await utils.getLocal('user_id');

    bool moveToSignIn = false;

    if (id == null) {
      moveToSignIn = true;
    } else {
      bool response = await UserApi.getById(id);
      if (!response) {
        utils.removeLocal('user_id');
        moveToSignIn = true;
        return;
      }
    }

    // set up firebase
    _saveFirebaseToken(null);
    FirebaseMessaging.instance.onTokenRefresh.listen(_saveFirebaseToken);

    if (moveToSignIn) {
      Get.off(() => const SignInPage());
    } else {
      Get.off(() => openDashboard(controller.user.value), curve: Curves.easeIn);
    }
  }

  Future<void> _getConfig() async {
    bool response = await ConfigApi.all();
  }

  Future<void> _versionCheck(Function()? onComplete) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int buildNumber = int.parse(packageInfo.buildNumber);

    int version = int.parse(
      Platform.isAndroid
          ? controller.config.value.currentVersion!['android']
          : controller.config.value.currentVersion!['ios'],
    );
    bool mandatory =
        controller.config.value.currentVersion!['is_forced'].toString() == "1";

    if (buildNumber < version) {
      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => UpdaterPopup(
          isMandatory: mandatory,
          onCancel: () {
            if (onComplete != null) onComplete();
          },
          onConfirm: () async {
            PackageInfo packageInfo = await PackageInfo.fromPlatform();
            StoreRedirect.redirect(
              androidAppId: packageInfo.packageName,
              iOSAppId: '6503428230',
            );
          },
        ),
      );

      return;
    }

    if (onComplete != null) onComplete();
  }

  Future<void> _saveFirebaseToken(String? token) async {
    Controller controller = Get.find<Controller>();
    // Get the token each time the application loads
    token ??= await FirebaseMessaging.instance.getToken();

    print("Firebase: " + token.toString());

    // Save the initial token to the database
    if (token != null) {
      String? userId = controller.user.value.id;
      await FirebaseApi.storeFCM(userId, token);
    }

    // also subscribe to firebase topic
    await FirebaseMessaging.instance.subscribeToTopic('uncategorized');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Empty container to ensure stack takes full space
          Container(
            color: Colors.black,
          ), // fallback color if image is transparent
          // Animated background image sliding up from bottom
          SlideTransition(
            position: _bgSlideAnimation,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/images/new_bg.png',
                fit:
                    BoxFit.fitWidth, // keeps width full, crops height if needed
                width: double.infinity,
              ),
            ),
          ),

          // Foreground content: logo + text (centered, no animation)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo.png", width: 250),
              const SizedBox(height: 5),
              Container(
                width: 250,
                alignment: Alignment.center,
                child: Text(
                "helping the world become\nwhiskey wise™",
                textAlign: TextAlign.center,                
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UpdaterPopup extends StatelessWidget {
  UpdaterPopup({super.key, this.isMandatory, this.onCancel, this.onConfirm});

  bool? isMandatory;
  void Function()? onConfirm;
  void Function()? onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: ContinuousRectangleBorder(
        side: const BorderSide(width: 2, color: Color(0xffe17f2f)),
        borderRadius: BorderRadius.circular(0),
      ),
      backgroundColor: Colors.black,

      content: Container(
        padding: const EdgeInsets.only(left: 0, top: 10, right: 0),
        child: Text(
          isMandatory == true
              ? "App update required to continue"
              : "New update available",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        if (isMandatory != true)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (onCancel != null) onCancel!();
            },
            child: const Text(
              'Later',
              style: TextStyle(
                color: Color(0xffe17f2f),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        TextButton(
          onPressed: onConfirm,
          child: const Text(
            'Update',
            style: TextStyle(
              color: Color(0xffe17f2f),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
