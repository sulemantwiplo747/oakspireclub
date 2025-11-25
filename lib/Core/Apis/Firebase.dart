import 'dart:async';
import 'dart:io';

import 'package:bourboneur/Core/BaseApi.dart';
import 'package:bourboneur/Core/Controllers/BlueBooks.dart';
import 'package:bourboneur/Core/Controllers/LastUpdate.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class _Firebase extends BaseApi {

  static String STORE_FCM = 'firebase/store-fcm';

  Future<dynamic> storeFCM(
    String? userId,
    String token
  ) async {

    var data = {
      "user_id": userId,
      "token": token,
      "device_id": await _getId()
    };
    var response = await sendPost(STORE_FCM, data);
    if (response == null ) return false;
    if ( response.body['code'] != 'OK' ) {
      utils.showToast("Error", response.body['data']);
      return false;
    }

    return true;
  }

  Future<String> _getId() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedId = prefs.getString('app_unique_id');

    if (savedId != null) {
      return savedId;
    }

    // Generate a new UUID if none exists
    final uniqueId = const Uuid().v4();
    await prefs.setString('app_unique_id', uniqueId);
    return uniqueId;
  }

  // Future<String?> _getId() async {
  //   // var deviceInfo = DeviceInfoPlugin();
  //   // if (Platform.isIOS) { // import 'dart:io'
  //   //   var iosDeviceInfo = await deviceInfo.iosInfo;
  //   //   return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  //   // } else if(Platform.isAndroid) {
  //   //   var androidDeviceInfo = await deviceInfo.androidInfo;
  //   //   return androidDeviceInfo.id;
  //   // }
    
  // }

  

}

_Firebase FirebaseApi = Get.put(_Firebase());
