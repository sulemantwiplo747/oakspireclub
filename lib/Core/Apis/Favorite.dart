import 'dart:async';

import 'package:bourboneur/Core/BaseApi.dart';
import 'package:bourboneur/Core/Controllers/Collection.dart';
import 'package:bourboneur/Core/Controllers/Favorite.dart';
import 'package:bourboneur/Core/Controllers/Rating.dart';
import 'package:get/get.dart';


class _Favorite extends BaseApi {

  static String MARK = 'favorite/mark';
  static String UNMARK = 'favorite/unmark';
  static String ALL = 'favorite/all';
  static String GET_BY_ID = 'favorite/get-by-id';
  static String IS_FAVORITE = 'favorite/is-favorite';
 
  Future<dynamic> mark(
    String bluebookId,
    String userId
  ) async {
    
    var data = {
      "bluebook_id": bluebookId,
      "user_id": userId
    };

    var response = await sendPost(MARK, data);
    if (response == null ) return false;
    if ( response.body['code'] != 'OK' ) {
      utils.showToast("Error", response.body['data']);
      return false;
    }

    return Favorite.fromJson(response.body['data']);
  }

  Future<dynamic> unmark(    
    String id
  ) async {
    
    var data = {
      "id": id
    };
    var response = await sendPost(UNMARK, data);
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

    List<Favorite> fList = _parseFavorites(response.body['data']);

    controller.favorites.clear();
    controller.favorites.addAll(fList);

    return fList.isNotEmpty;
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

  Future<dynamic> isFavorite(
    String userId,
    String bluebookId
  ) async {
    
    var data = {
      "user_id": userId,
      "bluebook_id": bluebookId
    };
    var response = await sendPost(IS_FAVORITE, data);
    if (response == null ) return false;
    if ( response.body['code'] != 'OK' ) {
      utils.showToast("Error", response.body['data']);
      return false;
    }

    return response.body['data'] != false ? Favorite.fromJson(response.body['data']) : null;
  }
  
  List<Favorite> _parseFavorites(List responseBody) {
    List<Favorite> list = [];
    for( var item in responseBody )
    {
      list.add(Favorite.fromJson(item));
    }

    return list;
  }

}

_Favorite FavoriteApi = Get.put(_Favorite());
