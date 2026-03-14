import 'dart:async';

import 'package:bourboneur/Core/BaseApi.dart';
import 'package:bourboneur/Core/BlogController.dart';
import 'package:bourboneur/Core/Controllers/Blog.dart';
import 'package:get/get.dart';

class _Import extends BaseApi {

  static String BAXUS = 'import/baxus';
  static String CSV = 'import/csv';  

  BlogController _blogController = Get.find<BlogController>();

  Future<dynamic> baxus(
    String url,
    String userId
   ) async {
    
    var data = {
      "url": url,
      "user_id": userId
    };
    var response = await sendPost(BAXUS, data);
    if (response == null ) return false;
    if ( response.body['code'] != 'OK' ) {
      utils.showToast("Error", response.body['data']);
      return false;
    }

    return true;
  }

  Future<dynamic> csv(    
    String userId,
    String content
   ) async {
    
    var data = {      
      "user_id": userId,
      'csv_content': content
    };
    var response = await sendPost(CSV, data);
    if (response == null ) return false;
    if ( response.body['code'] != 'OK' ) {
      utils.showToast("Error", response.body['data']);
      return false;
    }

    return true;
  }





}

_Import ImportApi = Get.put(_Import());
