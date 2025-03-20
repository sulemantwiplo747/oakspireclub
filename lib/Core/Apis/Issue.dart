import 'dart:async';

import 'package:bourboneur/Core/BaseApi.dart';
import 'package:get/get.dart';

class _Issue extends BaseApi {

  static String ISSUE_CREATE = 'issue/create';
 
  Future<bool> create(
    String userId,
    String title,
    String message,
    String deviceInfo,
  ) async {
    
    var data = {
      "user_id": userId,
      "title": title,
      "message": message,
      "deviceInfo": deviceInfo
    };
    var response = await sendPost(ISSUE_CREATE,  data);
    if (response == null ) return false;
    if ( response.body['code'] != 'OK' ) {
      utils.showToast("Error", response.body['data']);
      return false;
    }

    return true;
  }


}

_Issue IssueApi = Get.put(_Issue());
