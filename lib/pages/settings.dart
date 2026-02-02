import 'package:bourboneur/Core/Apis/Auth.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/common/staggered_item_animation.dart';
import 'package:bourboneur/pages/delete_account.dart';
import 'package:bourboneur/pages/edit_profile.dart';
import 'package:bourboneur/pages/settings/settings_menu.dart';
import 'package:bourboneur/pages/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  Controller controller = Get.find<Controller>();
  
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
                      Get.to(() => EditProfilePage())?.then((v)  {
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
                    subLabel: "Update you subscription",
                    onTap: () {},
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
                color: Colors.red.withValues(alpha: .3),
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
                            color: Color(0xff94bfbf),
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

            const StaggeredItemAnimation(
              index: 1,
              child: Text(
                "App version #40",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff94bfbf),
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
