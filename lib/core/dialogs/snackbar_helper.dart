import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showErrorSnackBar(String message, {String title = TextRoutes.error}) {
  final screenWidth = MediaQuery.of(Get.context!).size.width;
  final margin = screenWidth >= 300
      ? const EdgeInsets.symmetric(horizontal: 300)
      : EdgeInsets.zero;

  Get.snackbar(
    titleText: Text(
      title.tr,
      style: titleStyle.copyWith(color: white),
    ),
    title.tr,
    message.tr,
    messageText: Text(
      message.tr,
      style: bodyStyle.copyWith(color: white),
    ),
    backgroundColor: Colors.red,
    colorText: Colors.white,
    borderRadius: 20,
    margin: margin,
    duration: const Duration(seconds: 3),
    icon: const Icon(Icons.error, color: Colors.white),
  );
}

void showSuccessSnackBar(String message, {String title = TextRoutes.success}) {
  final screenWidth = MediaQuery.of(Get.context!).size.width;
  final margin = screenWidth >= 300
      ? const EdgeInsets.symmetric(horizontal: 300)
      : EdgeInsets.zero;

  Get.snackbar(
    title.tr,
    message.tr,
    titleText: Text(
      title.tr,
      style: titleStyle.copyWith(color: white),
    ),
    messageText: Text(
      message.tr,
      style: bodyStyle.copyWith(color: white),
    ),
    shouldIconPulse: true,
    backgroundColor: Colors.greenAccent,
    colorText: black,
    borderRadius: 20,
    margin: margin,
    duration: const Duration(seconds: 3),
    icon: const Icon(Icons.check_box_outlined, color: black),
  );
}
