import 'dart:async';

import 'package:bourboneur/Core/BaseApi.dart';
import 'package:bourboneur/Core/Controllers/User.dart';
import 'package:get/get.dart';

class _Auth extends BaseApi {

  static String AUTH_REGISTER = 'auth/register';
  static String AUTH_LOGIN = 'auth/login';    
  static String AUTH_FORGET_PASSWORD = 'auth/forget-password';    
  static String AUTH_RESET_PASSWORD = 'auth/reset-password';    
  static String AUTH_DELETE = 'auth/delete';    

  Future<dynamic> register(
    String name,
    String email,
    String password,
    bool? subscribe
   ) async {
    
    var data = {
      "full_name": name,
      "email": email,
      "password": password,
      "subscribe": subscribe == true ? 1 : 0
    };
    var response = await sendPost(AUTH_REGISTER, data);
    if (response == null ) return false;
    if ( response.body['code'] != 'OK' ) {
      utils.showToast("Error", response.body['data']);
      return false;
    }

    controller.user.value = User.fromJson(response.body['data']);
    await utils.saveLocal('user_id', controller.user.value.id!);

    return true;
  }

  Future<dynamic> login(    
    String email,
    String password
   ) async {
    
    var data = {      
      "email": email.trim(),
      "password": password
    };
    var response = await sendPost(AUTH_LOGIN, data);
    if (response == null ) return false;
    if ( response.body['code'] != 'OK' ) {
      utils.showToast("Error", response.body['data']);
      return false;
    }

    controller.user.value = User.fromJson(response.body['data']);
    await utils.saveLocal('user_id', controller.user.value.id!);

    return true;
  }

  Future<dynamic> forgetPassword(    
    String email
   ) async {
    
    var data = {      
      "email": email
    };
    var response = await sendPost(AUTH_FORGET_PASSWORD, data);
    if (response == null ) return false;
    if ( response.body['code'] != 'OK' ) {
      utils.showToast("Error", response.body['data']);
      return false;
    }

    return true;
  }

  Future<dynamic> resetPassword(    
    String email,
    String password,
    String otp
   ) async {
    
    var data = {      
      "email": email,
      "password": password,
      "otp": otp
    };
    var response = await sendPost(AUTH_RESET_PASSWORD, data);
    if (response == null ) return false;
    if ( response.body['code'] != 'OK' ) {
      utils.showToast("Error", response.body['data']);
      return false;
    }

    return true;
  }

  Future<dynamic> deleteAccount(    
    String id
   ) async {
    
    var data = {      
      "id": id
    };
    var response = await sendPost(AUTH_DELETE, data);
    if (response == null ) return false;
    if ( response.body['code'] != 'OK' ) {
      utils.showToast("Error", response.body['data']);
      return false;
    }

    return true;
  }

  Future<dynamic> logout() async {
   
    controller.user.value = User();
    await utils.removeLocal('user_id');

    return true;
  }

  


}

_Auth Auth = Get.put(_Auth());
