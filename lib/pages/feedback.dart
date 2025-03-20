import 'dart:convert';

import 'package:bourboneur/Core/Apis/Issue.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/Core/Utils.dart';
import 'package:bourboneur/common/custom_button.dart';
import 'package:bourboneur/common/custom_input.dart';
import 'package:bourboneur/common/login_wrapper.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}


class _FeedbackPageState extends State<FeedbackPage> {
  Controller controller = Get.find<Controller>();
  bool isLoading = false;

  Utils utils = Utils();

  TextEditingController titleController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  
  void _handleSubmit() async {
    if ( isLoading == true ) return;
    setState(() {
      isLoading = true;
    });

     if (titleController.value.text.trim() == "" ||
        messageController.value.text.trim() == "") {
      setState(() {
        isLoading = false;
      });
      utils.showToast("Error", "Please fill the form.");
      return;
    }

    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;

    await IssueApi.create(
      controller.user.value.id!,
      titleController.value.text,
      messageController.value.text,
      jsonEncode(deviceInfo.data)
    );

    setState(() {
      isLoading = false;
    });

    utils.showToast("Success", "Your feedback is submitted");
    titleController.value = const TextEditingValue( text: '' );
    messageController.value = const TextEditingValue( text: '' );

  }

  @override
  Widget build(BuildContext context) {
    return LoginWrapper(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 15, top: 20, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Write down your feedback!",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white)),
              const SizedBox(
                height: 20,
              ),
              CustomInput(
                label: "Title",
                controller: titleController,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomInput(
                label: "Message", 
                maxLine: 10,
                controller: messageController,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                text: "Submit",
                onTap: _handleSubmit,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
