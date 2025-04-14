import 'dart:async';

import 'package:bourboneur/Core/BaseApi.dart';
import 'package:bourboneur/Core/Controllers/Collection.dart';
import 'package:bourboneur/Core/Controllers/Rating.dart';
import 'package:get/get.dart';


class _Rating extends BaseApi {

  static String ALL = 'rating/all';
  static String RATE = 'rating/rate';
  static String RATE_DELETE = 'rating/delete';
  static String GET_BY_ID = 'rating/get-by-id';
  static String GET_BY_USER_BLUEBOOK = 'rating/get-by-user-bluebook';
 
  Future<dynamic> rate(
    String bluebookId,
    String userId,    
    double nose,
    double palate,
    double finish,
    String notes
  ) async {
    
    var data = {
      "bluebook_id": bluebookId,
      "user_id": userId,
      "nose" : nose,
      "palate" : palate,
      "finish" : finish,
      "notes" : notes
    };

    var response = await sendPost(RATE, data);
    if (response == null ) return false;
    if ( response.body['code'] != 'OK' ) {
      utils.showToast("Error", response.body['data']);
      return false;
    }

    return response.body['data'];
  }

  Future<bool> remove(    
    String id
  ) async {
    
    var data = {
      "id": id
    };
    var response = await sendPost(RATE_DELETE, data);
    if (response == null ) return false;
    if ( response.body['code'] != 'OK' ) {
      utils.showToast("Error", response.body['data']);
      return false;
    }

    return true;
  }

  Future<dynamic> all(
    String userId
  ) async {
    
    var data = {
      "user_id": userId
    };
    var response = await sendPost(ALL, data);
    if (response == null ) return false;
    if ( response.body['code'] != 'OK' ) {
      utils.showToast("Error", response.body['data']);
      return false;
    }

    List<Rating> cList = _parseCollection(response.body['data']);

    controller.ratings.clear();
    controller.ratings.addAll(cList);

    return cList.isNotEmpty;
  }

  Future<dynamic> getById(
    String id
  ) async {
    
    var data = {
      "id": id
    };
    var response = await sendGet(GET_BY_ID, query: data);
    if (response == null ) return false;
    if ( response.body['code'] != 'OK' ) {
      utils.showToast("Error", response.body['data']);
      return false;
    }

    return Rating.fromJson(response.body['data']);
  }

  Future<dynamic> getByUserIdBluebookId(
    String userId,
    String bluebookId,
  ) async {
    
    var data = {
      "user_id": userId,
      'bluebook_id': bluebookId
    };

    var response = await sendPost(GET_BY_USER_BLUEBOOK, data);
    if (response == null ) return false;
    if ( response.body['code'] != 'OK' ) {
      utils.showToast("Error", response.body['data']);
      return false;
    }

    return response.body['data'] != false ? Rating.fromJson(response.body['data']) : null;
  }

 
  

  List<Rating> _parseCollection(List responseBody) {
    List<Rating> list = [];
    for( var item in responseBody )
    {
      list.add(Rating.fromJson(item));
    }

    return list;
  }

}

_Rating RatingApi = Get.put(_Rating());
