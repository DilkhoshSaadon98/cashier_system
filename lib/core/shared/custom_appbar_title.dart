import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/screen_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

AppBar customAppBarTitle(
  String title, [
  bool? isSubScreen,
]) {
  return AppBar(
    backgroundColor: primaryColor,
    leading: isSubScreen == true
        ? GestureDetector(
            onLongPress: () {
              Get.toNamed(AppRoute.homeScreen);
            },
            child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: white,
                )),
          )
        : Container(),
    centerTitle: true,
    elevation: 0,
    scrolledUnderElevation: 1,
    title: Text(
      title.tr,
      style: titleStyle.copyWith(color: white, fontSize: 18),
    ),
  );
}
