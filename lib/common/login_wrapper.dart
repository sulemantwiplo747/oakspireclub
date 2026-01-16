import 'dart:io';

import 'package:bourboneur/Core/Apis/Auth.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/pages/delete_account.dart';
import 'package:bourboneur/pages/blog.dart';
import 'package:bourboneur/pages/bluebook.dart';
import 'package:bourboneur/pages/dashboard.dart';
import 'package:bourboneur/pages/explore.dart';
import 'package:bourboneur/pages/feedback.dart';
import 'package:bourboneur/pages/good_pour.dart';
import 'package:bourboneur/pages/ios_subscription_page.dart';
import 'package:bourboneur/pages/portal.dart';
import 'package:bourboneur/pages/sign_in.dart';
import 'package:bourboneur/pages/wheel_of_destiny.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Core/Utils.dart';

class LoginWrapper extends StatefulWidget {
  LoginWrapper({
    super.key,
    required this.child,
    this.onTapNav,
    this.showBottomNavigator = true,
  });

  Widget child;
  void Function(int)? onTapNav;
  bool showBottomNavigator;

  @override
  State<LoginWrapper> createState() => _LoginWrapperState();
}

class _LoginWrapperState extends State<LoginWrapper> {
  int _selectedIndex = 0; // Tracks the currently selected tab

  Widget _buildAnimatedIcon(
    IconData iconData,
    int index, {
    bool isActive = false,
  }) {
    final bool selected = _selectedIndex == index;
    return AnimatedScale(
      scale: selected ? 1.2 : 1.0, // Slight grow on select
      duration: const Duration(milliseconds: 300),
      curve: Curves.elasticOut, // Bouncy feel
      child: Icon(
        iconData,
        color: selected ? const Color(0xFFe06f17) : const Color(0xFFf47c1a),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset('assets/images/logo.png', width: 150),
        actions: [
          // GestureDetector(
          //   onTap: () {
          //     showDialog(
          //       context: context,
          //       builder: (BuildContext context) {
          //         return Menu();
          //       },
          //     );
          //   },
          //   child: Container(
          //     color: Theme.of(context).colorScheme.background,
          //     padding: const EdgeInsets.all(15.0),
          //     child: const Icon(Icons.menu, color: Color(0xFFf47c1a), size: 30),
          //   ),
          // ),
        ],
      ),
      body: widget.child,
      bottomNavigationBar: widget.showBottomNavigator == true ? BottomNavigationBar(
        backgroundColor: Colors.black,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: const Color(0xFFf47c1a),
        selectedItemColor: const Color(0xFFe06f17),
        type: BottomNavigationBarType.fixed,
        iconSize: 32,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          if (widget.onTapNav != null) {
            widget.onTapNav!(index);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: _buildAnimatedIcon(Icons.menu, 0),
            activeIcon: _buildAnimatedIcon(Icons.menu, 0, isActive: true),
            label: "Menu",
          ),
          BottomNavigationBarItem(
            icon: _buildAnimatedIcon(
              Icons.wine_bar_sharp,
              1,
            ), // Replace with your actual icons
            activeIcon: _buildAnimatedIcon(
              Icons.wine_bar_sharp,
              1,
              isActive: true,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: _buildAnimatedIcon(Icons.home, 2),
            activeIcon: _buildAnimatedIcon(Icons.home, 2, isActive: true),
            label: "Explore",
          ),
          BottomNavigationBarItem(
            icon: _buildAnimatedIcon(Icons.recycling_sharp, 3),
            activeIcon: _buildAnimatedIcon(
              Icons.recycling_sharp,
              3,
              isActive: true,
            ),
            label: "Destiny",
          ),
          BottomNavigationBarItem(
            icon: _buildAnimatedIcon(Icons.local_offer, 4),
            activeIcon: _buildAnimatedIcon(
              Icons.local_offer,
              4,
              isActive: true,
            ),
            label: "Suggestions",
          ),
          BottomNavigationBarItem(
            icon: _buildAnimatedIcon(Icons.settings, 5),
            activeIcon: _buildAnimatedIcon(Icons.settings, 5, isActive: true),
            label: "Blog",
          ),
        ],
      ) : null,
    );
  }
}

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  Controller controller = Get.find<Controller>();
  var utils = Utils();
  String? versionNumber;

  @override
  void initState() {
    _getVersion();
    super.initState();
  }

  _getVersion() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      versionNumber = info.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              Get.to(() => const DeleteAccount());
            },
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.user.value.name!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xfff47c1a),
                    ),
                  ),
                  Text(
                    controller.user.value.email!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Delete Account",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic,
                      fontSize: 14,
                      color: Color(0xfff47c1a),
                    ),
                  ),
                ],
              ),
            ),
          ),
          MenuItem(
            text: 'Home',
            onTap: () {
              Get.offAll(() => DashboardPage());
            },
          ),
          MenuItem(
            text: 'Bourbon Blue Book',
            onTap: () {
              Get.to(() => BlueBook());
            },
          ),
          MenuItem(
            text: 'Wheel of Destiny',
            onTap: () {
              Get.to(() => WheelOfDestiny());
            },
          ),
          MenuItem(
            text: 'Explore your bourbon',
            onTap: () {
              Get.to(() => ExplorePage());
            },
          ),
          MenuItem(
            text: 'Bourbon Suggestions',
            onTap: () {
              Get.to(() => GoodPourPage());
            },
          ),
          MenuItem(
            text: 'Bourbon Blog',
            onTap: () {
              Get.to(() => Blog());
            },
          ),
          if (controller.user.value.isFree != "1")
            MenuItem(
              text: 'Billing',
              onTap: () {
                if (controller.user.value.lastPaymentMethod == null) {
                  Platform.isAndroid
                      ? Get.to(() => PortalPage())
                      : launchUrl(
                          Uri.parse(
                            "https://apps.apple.com/account/subscriptions",
                          ),
                        );
                } else if (Platform.isAndroid &&
                    controller.user.value.lastPaymentMethod == "apple_in_app") {
                  Get.to(() => IosSubscriptionPage());
                } else if (controller.user.value.lastPaymentMethod ==
                    "stripe") {
                  Get.to(() => PortalPage());
                } else {
                  launchUrl(
                    Uri.parse("https://apps.apple.com/account/subscriptions"),
                  );
                }
              },
            ),
          MenuItem(
            text: 'Feedback',
            onTap: () {
              Get.to(() => FeedbackPage());
            },
          ),
          MenuItem(
            text: 'Logout',
            onTap: () {
              Auth.logout();
              Get.offAll(() => SignInPage());
            },
          ),
          const Spacer(),
          if (versionNumber != null)
            VersionNumber(versionNumber: versionNumber!),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  MenuItem({super.key, required this.text, this.onTap});

  final String text;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        if (onTap != null) onTap!();
      },
      child: Container(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 15,
          bottom: 15,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Color(0xfff47c1a),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}

class VersionNumber extends StatelessWidget {
  VersionNumber({super.key, required this.versionNumber});

  String versionNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Text(
        "App version #${versionNumber}",
        textAlign: TextAlign.center,
        style: TextStyle(color: const Color.fromARGB(255, 138, 137, 137)),
      ),
    );
  }
}
