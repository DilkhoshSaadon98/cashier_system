import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showErrorSnackBar(String message, {String title = TextRoutes.error}) {
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
    maxWidth: 400,
    backgroundColor: Colors.red,
    colorText: Colors.white,
    borderRadius: constRadius,
    shouldIconPulse: true,
    snackPosition: SnackPosition.BOTTOM,
    snackStyle: SnackStyle.FLOATING,
    animationDuration: const Duration(milliseconds: 100),
    barBlur: .5,
    showProgressIndicator: true,
    progressIndicatorBackgroundColor: Colors.red,
    reverseAnimationCurve: Curves.easeInBack,
    forwardAnimationCurve: Curves.easeInOut,
    duration: const Duration(seconds: 2),
    icon: const Icon(Icons.error, color: Colors.white),
  );
}

void showSuccessSnackBar(String message, {String title = TextRoutes.success}) {
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
    maxWidth: 400,
    backgroundColor: Colors.lightGreen,
    colorText: white,
    borderRadius: constRadius,
    shouldIconPulse: true,
    snackPosition: SnackPosition.BOTTOM,
    snackStyle: SnackStyle.FLOATING,
    animationDuration: const Duration(milliseconds: 100),
    barBlur: .5,
    showProgressIndicator: true,
    progressIndicatorBackgroundColor: Colors.greenAccent,
    reverseAnimationCurve: Curves.easeInBack,
    forwardAnimationCurve: Curves.easeInOut,
    duration: const Duration(seconds: 2),
    icon: const Icon(Icons.check_box_outlined, color: white),
  );
}
