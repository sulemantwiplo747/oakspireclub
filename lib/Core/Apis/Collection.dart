import 'dart:async';
import 'dart:convert';

import 'package:bourboneur/Core/BaseApi.dart';
import 'package:bourboneur/Core/Controllers/BlueBooks.dart';
import 'package:bourboneur/Core/Controllers/Collection.dart';
import 'package:bourboneur/Core/Controllers/GroupedCollection.dart';
import 'package:bourboneur/Core/Controllers/LastUpdate.dart';
import 'package:get/get.dart';

enum CollectionType { wishlist, normal }

class _Collection extends BaseApi {

  static String COLLECTION_ADD_BULK = 'collection/add-bulk';
  static String COLLECTION_ADD = 'collection/add';
  static String COLLECTION_DELETE = 'collection/delete';
  static String COLLECTION_DELETE_BY_USER_BOTTLE = 'collection/delete-by-user-bottle';
  static String COLLECTION_ALL = 'collection/all';
  static String COLLECTION_ALL_GROUPED = 'collection/all/grouped';
  static String COLLECTION_CHART_DATA = 'collection/chart-data';
  static String COLLECTION_IS_IN_COLLECTION = 'collection/is-in-collection';

  Future<dynamic> add(
    String bottleId,
    String? userId,
    Enum type
  ) async {
    
    var data = {
      "bottle_id": bottleId,
      "user_id": userId,
      "type": type.name
    };
    var response = await sendPost(COLLECTION_ADD, data);
    if (response == null ) return false;
    if ( response.body['code'] != 'OK' ) {
      utils.showToast("Error", response.body['data']);
      return false;
    }

    return response.body['data'];
  }

  Future<dynamic> addBulk(
    String bottleId,
    String? userId,
    Enum type,
    { int quantity = 1 }
  ) async {
    
    var data = {
      "bottle_id": bottleId,
      "user_id": userId,
      "type": type.name,
      "quantity": quantity
    };
    var response = await sendPost(COLLECTION_ADD_BULK, data);
    if (response == null ) return false;
    if ( response.body['code'] != 'OK' ) {
      utils.showToast("Error", response.body['data']);
      return false;
    }

    return response.body['data'];
  }

  Future<dynamic> remove(    
    String id
  ) async {
    
    var data = {
      "id": id
    };
    var response = await sendPost(COLLECTION_DELETE, data);
    if (response == null ) return false;
    if ( response.body['code'] != 'OK' ) {
      utils.showToast("Error", response.body['data']);
      return false;
    }

    return;
  }

  Future<dynamic> removeByUserBottle(    
    String bottleId,
    String? userId,
    Enum type
  ) async {
    
    var data = {
      "bottle_id": bottleId,
      "user_id": userId,
      "type":  type.name
    };
    var response = await sendPost(COLLECTION_DELETE_BY_USER_BOTTLE, data);
    if (response == null ) return false;
    if ( response.body['code'] != 'OK' ) {
      utils.showToast("Error", response.body['data']);
      return false;
    }

    return;
  }

  Future<dynamic> all(
    String userId,
    Enum type
  ) async {
    
    var data = {
      "user_id": userId,
      "type": type.name
    };
    var response = await sendGet(COLLECTION_ALL, query: data);
    if (response == null ) return false;
    if ( response.body['code'] != 'OK' ) {
      utils.showToast("Error", response.body['data']);
      return false;
    }

    List<Collection> cList = _parseCollection(response.body['data']);

    controller.collections.clear();
    controller.collections.addAll(cList);

    return cList.isNotEmpty;
  }

  Future<dynamic> grouped(
    String userId,
    Enum type
  ) async {
    
    var data = {
      "user_id": userId,
      "type": type.name
    };
    var response = await sendGet(COLLECTION_ALL_GROUPED, query: data);
    if (response == null ) return false;
    if ( response.body['code'] != 'OK' ) {
      utils.showToast("Error", response.body['data']);
      return false;
    }

    List<GroupedCollection> cList = _parseGroupedCollection(response.body['data']);

    controller.groupedCollections.clear();
    controller.groupedCollections.addAll(cList);

    return cList.isNotEmpty;
  }

  Future<dynamic> getChartData(
    String userId,
    int lookBack
  ) async {
    
    var data = {
      "user_id": userId,
      "look_back": lookBack.toString()
    };

    var response = await sendGet(COLLECTION_CHART_DATA, query: data);
    if (response == null ) return false;
    if ( response.body['code'] != 'OK' ) {
      utils.showToast("Error", response.body['data']);
      return false;
    }

    return response.body['data'];
  }

  Future<dynamic> isInCollection(
    String userId,
    String bottleId,
    Enum type,
  ) async {
    
    var data = {
      "user_id": userId,
      "bottle_id": bottleId,
      "type" : type.name
    };
    var response = await sendPost(COLLECTION_IS_IN_COLLECTION, data);
    if (response == null ) return false;
    if ( response.body['code'] != 'OK' ) {
      utils.showToast("Error", response.body['data']);
      return false;
    }

    return response.body['data'];
  }
  

  List<Collection> _parseCollection(List responseBody) {
    List<Collection> list = [];
    for( var item in responseBody )
    {
      list.add(Collection.fromJson(item));
    }

    return list;
  }

  List<GroupedCollection> _parseGroupedCollection(List responseBody) {
    List<GroupedCollection> list = [];
    for( var item in responseBody )
    {
      list.add(GroupedCollection.fromJson(item));
    }

    return list;
  }

}

_Collection CollectionApi = Get.put(_Collection());
