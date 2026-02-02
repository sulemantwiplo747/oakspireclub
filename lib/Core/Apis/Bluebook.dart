import 'dart:async';

import 'package:bourboneur/Core/BaseApi.dart';
import 'package:bourboneur/Core/Controllers/BlueBooks.dart';
import 'package:bourboneur/Core/Controllers/LastUpdate.dart';
import 'package:get/get.dart';

class _Bluebook extends BaseApi {

  static String BLUEBOOK_CREATE = 'bluebook/create';
  static String BLUEBOOK_GET_ALL = 'bluebook/get-all-bluebooks';
  static String BLUEBOOK_LAST_UPDATED_AT = 'bluebook/get-last-update';
  static String BLUEBOOK_GET_BY_ID = 'bluebook/get-by-id';
  static String BLUEBOOK_GET_PRICE_HISTORY = 'bluebook/get-price-history';

  Future<dynamic> all(
    String page,
    String? keyword,
    String limit
  ) async {
    
    var data = {
      "page": page,
      "limit": limit,
      "keyword": keyword
    };
    var response = await sendGet(BLUEBOOK_GET_ALL, query: data);
    if (response == null ) return false;
    if ( response.body['code'] != 'OK' ) {
      utils.showToast("Error", response.body['data']);
      return false;
    }

    List<BlueBook> cList = _parseBlueBook(response.body['data']['data']);

    if ( page.toString() == "1" ) {
      controller.bluebooks.clear();      
    }
    controller.bluebooks.addAll(cList);

    return cList.isNotEmpty;
  }

  Future<dynamic> getById(
    String id
  ) async {
    
    var data = {
      "id": id
    };
    var response = await sendGet(BLUEBOOK_GET_BY_ID, query: data);
    if (response == null ) return false;
    if ( response.body['code'] != 'OK' ) {
      utils.showToast("Error", response.body['data']);
      return false;
    }

    return BlueBook.fromJson(response.body['data']);
  }

  Future<dynamic> getPriceHistoryById(
    String id
  ) async {
    
    var data = {
      "id": id
    };
    var response = await sendGet(BLUEBOOK_GET_PRICE_HISTORY, query: data);
    if (response == null ) return false;
    if ( response.body['code'] != 'OK' ) {
      utils.showToast("Error", response.body['data']);
      return false;
    }

    return response.body['data'];
  }

  Future<dynamic> create(
    String bottleName,
    String bottlePrice,
    String userId
  ) async {

    var data = {
      "bottle_name": bottleName,
      "bottle_price": bottlePrice,
      "user_id": userId
    };
    var response = await sendPost(BLUEBOOK_CREATE, data);
    if (response == null ) return false;
    if ( response.body['code'] != 'OK' ) {
      utils.showToast("Error", response.body['data']);
      return false;
    }

    BlueBook bluebook = BlueBook.fromJson(response.body['data']);

    return bluebook;
  }

  Future<dynamic> lastUpdatedAt() async {
 
    var response = await sendGet(BLUEBOOK_LAST_UPDATED_AT);
    if (response == null ) return false;
    if ( response.body['code'] != 'OK' ) {
      utils.showToast("Error", response.body['data']);
      return false;
    }


    controller.lastUpdate.value = LastUpdate.fromJson({
      'bluebook_raw': response.body['data']['raw'],
      'bluebook_readable': response.body['data']['readable'],
    });

    return true;
  }

   List<BlueBook> _parseBlueBook(List responseBody) {
    List<BlueBook> list = [];
    for( var item in responseBody )
    {
      list.add(BlueBook.fromJson(item));
    }

    return list;
  }

}

_Bluebook BlueBookApi = Get.put(_Bluebook());
