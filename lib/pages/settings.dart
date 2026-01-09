import 'package:bourboneur/common/staggered_item_animation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class Settings extends StatelessWidget { // Now stateless – animation is handled inside the wrapper
  const Settings({super.key});

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
              child: const Row(
                children: [
                  Expanded(
                    child: Text(
                      "Cheers, Nick.",
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
            const SizedBox(height: 15),

            // 2. Collection Value Card
            StaggeredItemAnimation(
              index: 1,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.white),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Collection Value",
                      style: TextStyle(fontSize: 19, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 7),
                    Text(
                      "\$4.5k",
                      style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Icon(Icons.arrow_drop_up, color: Color(0xff92d050), size: 40),
                        Text(
                          "\$293.44 (+6.90%)",
                          style: TextStyle(fontSize: 19, color: Color(0xff92d050), fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 15),
                        Text(
                          "3 months",
                          style: TextStyle(fontSize: 19, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 3. Bourbon Blue Book Card
            StaggeredItemAnimation(
              index: 2,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.white),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: const Text(
                  "Bourbon Blue Book®",
                  style: TextStyle(fontSize: 27, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 4. Blog + Social Row
            StaggeredItemAnimation(
              index: 3,
              child: Row(
                children: [
                  Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.white),
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: const Text(
                        "Blog",
                        style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.white),
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            "Social",
                            style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          SocialIcon(
                            onTap: () async {
                              final uri = Uri.parse('https://www.facebook.com/Bourboneur/');
                              if (await canLaunchUrl(uri)) await launchUrl(uri);
                            },
                            icon: 'assets/images/social/facebook.png',
                          ),
                          const SizedBox(width: 20),
                          SocialIcon(
                            onTap: () async {
                              final uri = Uri.parse('https://www.instagram.com/thebourboneur/');
                              if (await canLaunchUrl(uri)) await launchUrl(uri);
                            },
                            icon: 'assets/images/social/instagram.png',
                          ),
                          const SizedBox(width: 20),
                          SocialIcon(
                            onTap: () async {
                              final uri = Uri.parse('https://www.tiktok.com/@bourboneur');
                              if (await canLaunchUrl(uri)) await launchUrl(uri);
                            },
                            icon: 'assets/images/social/tik-tok.png',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// SocialIcon remains unchanged
class SocialIcon extends StatelessWidget {
  const SocialIcon({super.key, required this.onTap, required this.icon});

  final VoidCallback? onTap;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: const BoxDecoration(
          color: Color(0xffff7520),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        child: Image.asset(icon, width: 20, height: 20),
      ),
    );
  }
}