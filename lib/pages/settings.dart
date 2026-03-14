import 'dart:io';

import 'package:bourboneur/Core/Apis/Auth.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/common/staggered_item_animation.dart';
import 'package:bourboneur/pages/delete_account.dart';
import 'package:bourboneur/pages/edit_profile.dart';
import 'package:bourboneur/pages/ios_subscription_page.dart';
import 'package:bourboneur/pages/portal.dart';
import 'package:bourboneur/pages/settings/settings_menu.dart';
import 'package:bourboneur/pages/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Controller controller = Get.find<Controller>();
  String versionNumber = "00";

  _getVersion() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      versionNumber = info.buildNumber;
    });
  }

  @override
  void initState() {
    _getVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Greeting
            StaggeredItemAnimation(
              index: 0,
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Settings",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xfffe8003),
                      ),
                      softWrap: true,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Auth.logout();
                      Get.to(() => SignInPage());
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.logout, color: Color(0xfffe8003), size: 22),
                        SizedBox(width: 5),
                        Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xfffe8003),
                          ),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Accounts
            StaggeredItemAnimation(
              index: 1,
              child: SettingMenu(
                showTitle: true,
                title: "Account",
                items: [
                  SettingsMenuItem(
                    label: "Cheers, ${controller.user.value.name}!",
                    subLabel: "${controller.user.value.email}",
                    onTap: () {
                      Get.to(() => EditProfilePage())?.then((v) {
                        // call the state to reload the page
                        setState(() {});
                      });
                    },
                    asset: "assets/images/avatar.png",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Support
            StaggeredItemAnimation(
              index: 1,
              child: SettingMenu(
                showTitle: true,
                title: "Support",
                items: [
                  SettingsMenuItem(
                    label: "Watch tutorial",
                    subLabel: "See how it works",
                    onTap: () {},
                    asset: "assets/images/tutorial.png",
                  ),
                  SettingsMenuItem(
                    label: "Need Help",
                    subLabel: "Email Us at\nsupport@bourboneur.com",
                    onTap: () {},
                    asset: "assets/images/question.png",
                  ),
                  SettingsMenuItem(
                    label: "Billing",
                    subLabel: controller.user.value.isFree == "1"
                        ? "Your subscription is FREE"
                        : "Update you subscription",
                    onTap: () {
                      if (controller.user.value.isFree == "1") return;
                      if (controller.user.value.lastPaymentMethod == null) {
                        Platform.isAndroid
                            ? Get.to(() => PortalPage())
                            : launchUrl(
                                Uri.parse(
                                  "https://apps.apple.com/account/subscriptions",
                                ),
                              );
                      } else if (Platform.isAndroid &&
                          controller.user.value.lastPaymentMethod ==
                              "apple_in_app") {
                        Get.to(() => IosSubscriptionPage());
                      } else if (controller.user.value.lastPaymentMethod ==
                          "stripe") {
                        Get.to(() => PortalPage());
                      } else {
                        launchUrl(
                          Uri.parse(
                            "https://apps.apple.com/account/subscriptions",
                          ),
                        );
                      }
                    },
                    asset: "assets/images/billing.png",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Delete Account
            StaggeredItemAnimation(
              index: 1,
              child: SettingMenu(
                showTitle: true,
                title: "Support",
                color: Color(0xff9e0000),
                items: [
                  Padding(
                    padding: EdgeInsetsGeometry.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          // m
                          children: [
                            const Text(
                              "!!Caution!!\nOnly if you’re\n100% certain.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => const DeleteAccount());
                              },
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.white,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  "Delete Account",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "You will need to update your subscription separately",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xffD3D3D3),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            StaggeredItemAnimation(
              index: 1,
              child: Text(
                "App version #$versionNumber",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xffD3D3D3),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
