import 'package:bourboneur/Core/Controllers/User.dart';
import 'package:bourboneur/pages/dashboard.dart';
import 'package:bourboneur/pages/select_package.dart';
import 'package:flutter/material.dart';

Widget openDashboard( User user ) {
  if ( user.isFree == "1" ) return DashboardPage();
  
  if ( user.subscriptionStatus == "not_subscribed" ) {
    return SelectPackagePage();
  }

   if ( user.subscriptionStatus == "canceled" ) {
    return SelectPackagePage();
  }

  return DashboardPage();
}