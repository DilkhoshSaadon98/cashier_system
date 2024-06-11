import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

customSnackBar(String title, String content, [bool? longDelay]) {
  return Get.snackbar(
    '',
    '',
    titleText: Text(
      title.tr,
      style: titleStyle.copyWith(color: whiteNeon),
    ),
    messageText: Text(
      content.tr,
      style: bodyStyle.copyWith(color: whiteNeon),
    ),
    icon: Icon(
      Icons.check,
      color: primaryColor,
    ),
    backgroundColor: primaryColor,
    colorText: primaryColor,
    snackStyle: SnackStyle.FLOATING,
    borderWidth: 1,
    borderColor: whiteNeon,
    duration: longDelay == true
        ? const Duration(milliseconds: 3000)
        : const Duration(milliseconds: 1000),
  );
}
