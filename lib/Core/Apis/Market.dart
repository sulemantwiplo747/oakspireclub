import 'dart:async';

import 'package:bourboneur/Core/BaseApi.dart';
import 'package:bourboneur/Core/Controllers/WOD.dart';
import 'package:get/get.dart';

class _Market extends BaseApi {

  static String MARKET_SNP = 'market/snp';
 

  Future<dynamic> snp(int lookBack) async {

    var data = {
      "look_back": lookBack.toString()
    };

    var response = await sendGet(MARKET_SNP, query: data);
    if (response == null ) return false;
    if ( response.body['code'] != 'OK' ) {
      utils.showToast("Error", response.body['data']);
      return false;
    }

    return response.body['data'];
  }

}

_Market MarketApi = Get.put(_Market());
