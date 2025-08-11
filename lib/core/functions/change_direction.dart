import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

TextDirection screenDirection() {
  TextDirection textDirection =
      myServices.sharedPreferences.getString("lang") == "en" ||
              myServices.sharedPreferences.getString("lang") == null ||
              Get.deviceLocale!.languageCode == "en_US"
          ? TextDirection.ltr
          : TextDirection.rtl;

  return textDirection;
}
