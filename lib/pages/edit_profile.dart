import 'package:bourboneur/Core/Apis/Auth.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/Core/Utils.dart';
import 'package:bourboneur/common/checkbox_input.dart';
import 'package:bourboneur/common/custom_button.dart';
import 'package:bourboneur/common/custom_input.dart';
import 'package:bourboneur/common/login_wrapper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final Controller controller = Get.find<Controller>();
  final Utils utils = Utils();

  bool isLoading = false;

  late TextEditingController controllerName;
  late TextEditingController controllerEmail;
  TextEditingController controllerCurrentPassword = TextEditingController();
  TextEditingController controllerNewPassword = TextEditingController();

  bool changePassword = false;

  @override
  void initState() {
    super.initState();

    // Initialize with current user data
    final user = controller.user.value;

    controllerName = TextEditingController(text: user.name ?? '');
    controllerEmail = TextEditingController(text: user.email ?? '');
  }

  @override
  void dispose() {
    controllerName.dispose();
    controllerEmail.dispose();
    controllerCurrentPassword.dispose();
    controllerNewPassword.dispose();
    super.dispose();
  }

  _onTapChangePassword(bool? value) {
    controllerCurrentPassword.value = const TextEditingValue(text: '');
    controllerNewPassword.value = const TextEditingValue(text: '');
    setState(() {
      changePassword = value == true;
    });
  }

  Future<void> _handleSave() async {
    setState(() => isLoading = true);

    final name = controllerName.text.trim();
    final email = controllerEmail.text.trim();
    final currentPass = controllerCurrentPassword.text.trim();
    final newPass = controllerNewPassword.text.trim();

    // Basic validation
    if (name.isEmpty) {
      utils.showToast("Error", "Name cannot be empty");
      setState(() => isLoading = false);
      return;
    }

    if (!utils.isValidEmail(email)) {
      utils.showToast("Error", "Please enter a valid email");
      setState(() => isLoading = false);
      return;
    }

    // If user wants to change password → require current password    
    if ( changePassword == true ) {
      if (currentPass.isEmpty) {
        utils.showToast(
          "Error",
          "Please enter your current password to change it",
        );
        setState(() => isLoading = false);
        return;
      }

      if (!utils.isValidPassword(newPass)) {
        utils.showToast(
          "Error",
          "New password must be at least 8 characters long",
        );
        setState(() => isLoading = false);
        return;
      }
    }

    bool result = await Auth.updateProfile(
      controller.user.value.id!,
      name,
      controllerCurrentPassword.text,
      controllerNewPassword.text
    );

    controller.user.value.name = name;

    if ( result ) {
      utils.showToast(
        "Success",
        "Profile info is success fully saved.",
      );
    }

    
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return LoginWrapper(
      showBottomNavigator: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Update your details",
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 30),

              // Email
              CustomInput(
                label: "Email",
                controller: controllerEmail,
                readOnly: true,
              ),
              const SizedBox(height: 20),

              // Full Name
              CustomInput(label: "Full Name", controller: controllerName),
              const SizedBox(height: 20),

              // Current Password (only needed when changing password)
              if (changePassword == true)
                CustomInput(
                  label: "Current Password",
                  obscureText: true,
                  controller: controllerCurrentPassword,
                ),
              if (changePassword == true) const SizedBox(height: 20),

              // New Password
              if (changePassword == true)
                CustomInput(
                  label: "New Password (optional)",
                  obscureText: true,
                  controller: controllerNewPassword,
                ),

              CustomCheckBox(
                label: "I want to change the password",
                checked: changePassword,
                onChanged: _onTapChangePassword,
              ),

              const SizedBox(height: 10),

              // Save Button
              CustomButton(
                text: "Save Changes",
                onTap: _handleSave,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
