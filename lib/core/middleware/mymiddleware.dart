import 'package:cashier_system/core/constant/routes.dart';
import 'package:cashier_system/core/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyMiddleWare extends GetMiddleware {
  @override
  int? get priority => 1;

  MyServices myServices = Get.find();

  @override
  RouteSettings? redirect(String? route) {
    if (myServices.sharedPreferences.getString("step") == "2") {
      return const RouteSettings(name: AppRoute.buingScreen);
    }
    if (myServices.sharedPreferences.getString("step") == "1") {
      return const RouteSettings(name: AppRoute.loginScreen);
    }
    if (myServices.sharedPreferences.getString("step") == "0" ||
        myServices.sharedPreferences.getString("step") == null) {
      return const RouteSettings(name: AppRoute.registerSystemScreen);
    }

    return null;
  }
}
