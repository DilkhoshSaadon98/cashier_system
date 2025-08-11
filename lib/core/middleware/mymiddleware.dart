import 'package:cashier_system/core/constant/screen_routes.dart';
import 'package:cashier_system/core/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyMiddleWare extends GetMiddleware {
  @override
  int? get priority => 1;

  final MyServices myServices = Get.find();

  @override
  RouteSettings? redirect(String? route) {
    String? step = myServices.sharedPreferences.getString("step");

    // Direct to home for development
    if (step == "dashboard") {
      return const RouteSettings(name: AppRoute.itemsScreen);
    }

    bool isLogin = myServices.sharedPreferences.getBool("login") ?? true;
    switch (step) {
      case "register":
      case null:
      // return const RouteSettings(name: AppRoute.registerSystemScreen);
      case "verify":
      // return const RouteSettings(name: AppRoute.verifyAccountScreen);
      case "login":
        return const RouteSettings(name: AppRoute.loginScreen);

      case "dashboard":
        return RouteSettings(
            name: isLogin == true ? AppRoute.loginScreen : AppRoute.homeScreen);
      default:
        return const RouteSettings(name: AppRoute.homeScreen);
    }
  }
}
