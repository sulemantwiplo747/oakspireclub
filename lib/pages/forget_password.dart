import 'dart:math';

import 'package:bourboneur/Core/Apis/Auth.dart';
import 'package:bourboneur/Core/Utils.dart';
import 'package:bourboneur/common/custom_button.dart';
import 'package:bourboneur/common/custom_input.dart';
import 'package:bourboneur/pages/reset_password.dart';
import 'package:bourboneur/pages/sign_in.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {

  bool isLoading = false;

  TextEditingController emailController = TextEditingController();
  Utils utils = Utils();

  void _handleSubmit() async {
    setState(() {
      isLoading = true;
    });
    if ( emailController.value.text.trim() == '' ) {
      setState(() {
        isLoading = false;
      });
      utils.showToast("Error", "Please enter your email first");
      return;
    }

    String email =  emailController.value.text;

    bool response = await Auth.forgetPassword(email);
    if ( response ) {
      Get.off(() => ResetPasswordPage(
        email: email,
      ));
    }

    setState(() {
        isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Forget Password?",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: Colors.white)),
                const SizedBox(
                  height: 10,
                ),
                Text("Enter your email to reset",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.white)),
                const SizedBox(
                  height: 50,
                ),
                CustomInput(
                  controller: emailController,
                  label: "Email",
                  // controller: controllerName,
                ),
                
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  text: "Submit",
                  onTap: _handleSubmit,
                  isLoading: isLoading,
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text.rich(TextSpan(children: [
                    TextSpan(
                      text: "Remember Password? ",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 12, color: Colors.white),
                    ),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.offAll(() => SignInPage());
                        },
                      text: "Sign In",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFFff8202), fontSize: 12),
                    ),
                  ])),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}