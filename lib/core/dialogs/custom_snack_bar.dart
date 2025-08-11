import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';

customSnackBar(String title, String content, [bool? longDelay]) {
  return Get.snackbar(
    '',
    '',
    titleText: Text(
      title.tr,
      style: titleStyle.copyWith(
        color: primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    messageText: Text(
      content.tr,
      style: bodyStyle.copyWith(
        color: primaryColor,
        fontSize: 14,
      ),
    ),
    icon: const Icon(
      Icons.check_circle,
      color: primaryColor,
      size: 20,
    ),
    // ignore: deprecated_member_use
    backgroundColor: white,
    colorText: whiteNeon,
    snackStyle: SnackStyle.FLOATING,
    borderWidth: 1,
    borderColor: whiteNeon,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
    margin: const EdgeInsets.all(12),
    borderRadius: 15,
    boxShadows: [
      BoxShadow(
        // ignore: deprecated_member_use
        color: Colors.black.withOpacity(0.3),
        offset: const Offset(0, 5),
        blurRadius: 10,
      ),
    ],
    duration: longDelay == true
        ? const Duration(milliseconds: 4000)
        : const Duration(milliseconds: 1500),
    animationDuration: const Duration(milliseconds: 600),
    overlayBlur: 1,
    // ignore: deprecated_member_use
    overlayColor: Colors.black.withOpacity(0.4),
    isDismissible: true,

    forwardAnimationCurve: Curves.bounceIn,
    reverseAnimationCurve: Curves.easeInBack,
  );
}
