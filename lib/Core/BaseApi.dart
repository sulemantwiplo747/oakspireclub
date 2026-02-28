import 'dart:developer';
import 'dart:io';


import 'package:bourboneur/Core/Utils.dart';
import 'package:bourboneur/Core/Constants.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseApi extends GetConnect {
  var utils = Utils();
  Controller controller = Get.find<Controller>();
  // late SharedPreferences prefs;
  @override
  void onInit() {
    allowAutoSignedCert = true;
    super.onInit();
    initStorage();
    httpClient.baseUrl = Constants.API_BASE_URL;
    httpClient.timeout = const Duration(seconds: 60);
  }

  Future<void> initStorage() async {
    // prefs = await SharedPreferences.getInstance();
  }

  Future<bool> isInternetConnected() async {
    var internetConnected = false;
    try {
      final result = await InternetAddress.lookup(Constants.INTERNET_PING);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        internetConnected = true;
      }
    } on SocketException catch (_error) {
      log('$_error');
      internetConnected = false;
    }
    return internetConnected;
  }

  Future<Response?> sendPost(String? url, dynamic body,
      {String? contentType,
      Map<String, String>? headers,
      Map<String, dynamic>? query}) async {
      // if (!await isInternetConnected()) {
      //   utils.showToast("Error", "Failed to reach network");
      //   return null;
      // }
      final b = body is FormData ? body : FormData(body);
      var response = await post(url, b,
          contentType: contentType, headers: headers, query: query);
      if (response.statusCode != 200) {
        utils.showToast("Error", "Internal server error.");
        return null;
      }

      return response;

  }

   Future<Response?> sendGet(String url,
      {String? contentType,
      Map<String, String>? headers,
      Map<String, dynamic>? query}) async {
      // if (!await isInternetConnected()) {
      //   utils.showToast("Error", "Failed to reach network");
      //   return null;
      // }
      print(url);
      var response = await get(url,
          contentType: contentType, headers: headers, query: query);
      if (response.statusCode != 200) {
        print(response.statusText);
        utils.showToast('Error', "Internal server error.");
        return null;
      }

      return response;

  }

  BaseApi() : super(timeout: const Duration(seconds: 2));
}
