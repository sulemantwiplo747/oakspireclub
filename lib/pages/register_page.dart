import 'package:bourboneur/Core/Apis/Auth.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/Core/Utils.dart';
import 'package:bourboneur/common/checkbox_input.dart';
import 'package:bourboneur/common/custom_button.dart';
import 'package:bourboneur/common/custom_input.dart';
import 'package:bourboneur/pages/dashboard.dart';
import 'package:bourboneur/pages/page_helpers/open_dashboard.dart';
import 'package:bourboneur/pages/select_package.dart';
import 'package:bourboneur/pages/sign_in.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  Controller controller = Get.find<Controller>();

  Utils utils = Utils();
  bool isLoading = false;

  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPass = TextEditingController();

  bool? isDrinkingAge = false;
  bool? subscribeToWeeklyBlog = true;

  @override
  void initState() {
    super.initState();
  }

  void _handleSubmit() async {
    setState(() {
      isLoading = true;
    });
    if (controllerName.value.text == "" ||
        controllerEmail.value.text == "" ||
        controllerPass.value.text == "") {
      utils.showToast("Error", "Please fill the form.");
      setState(() {
        isLoading = false;
      });
      return;
    }

    String name = controllerName.value.text;
    String email = controllerEmail.value.text;
    String password = controllerPass.value.text;

    if (!utils.isValidEmail(email)) {
      utils.showToast("Error", "This is not a valid email.");
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (!utils.isValidPassword(password)) {
      utils.showToast("Error", "Password should be at least 8 character long.");
      setState(() {
        isLoading = false;
      });
      return;
    }

    if ( isDrinkingAge != true ) {
      utils.showToast("Error", "You must me drinking age to register");
      setState(() {
        isLoading = false;
      });
      return;
    }

    // else register
    bool register = await Auth.register(name, email, password, subscribeToWeeklyBlog);
    setState(() {
      isLoading = false;
    });
    if (register) {      
      Get.off(() => openDashboard(controller.user.value));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Create Account,",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: Colors.white)),
                const SizedBox(
                  height: 10,
                ),
                Text("Become a Bourboneur",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.white)),
                const SizedBox(
                  height: 50,
                ),
                CustomInput(
                  label: "Full Name",
                  controller: controllerName,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomInput(
                  label: "Email",
                  controller: controllerEmail,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomInput(
                  label: "Password",
                  obscureText: true,
                  controller: controllerPass,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomCheckBox(
                  label: "I'm of legal drinking age",
                  onChanged: (bool? value) {
                    isDrinkingAge = value;
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomCheckBox(
                  label: "Subscribe to Bourboneur",
                  checked: true,
                  onChanged: (bool? value) {
                    subscribeToWeeklyBlog = value;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  text: "Signup",
                  onTap: _handleSubmit,
                  isLoading: isLoading,
                ),
                const SizedBox(
                  height: 100,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text.rich(TextSpan(children: [
                    TextSpan(
                      text: "I’m already a Bourboneur ",
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
