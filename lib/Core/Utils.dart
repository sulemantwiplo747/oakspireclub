import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static SnackbarController? snackbarController;

  showToast(title, message) {
    if ( snackbarController != null ) {
      snackbarController!.close(withAnimations: false);
      snackbarController = null;
    }

    snackbarController = Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(milliseconds: 3000),
      colorText: const Color(0xffe17f2f),
      backgroundColor: const Color(0xFF000000).withOpacity(1),
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      borderColor: const Color(0xffe17f2f),
      borderRadius: 0,
      borderWidth: 2,  
          
    );
  }

  bool isValidEmail(em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(p);

    return regExp.hasMatch(em);
  }

   bool isValidPassword(pass) {
    String p =
        r'^.{8,}$';
    RegExp regExp = RegExp(p);

    return regExp.hasMatch(pass);
  }

  showLoadingDialog() {
    EasyLoading.show();
  }

  hideLoadingDialog() {
    EasyLoading.dismiss();
  }

  Future<bool> saveLocal(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

   Future<String?> getLocal(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

   Future<bool?> removeLocal(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }


}
