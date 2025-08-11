import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/main.dart';
import 'package:flutter/material.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:get/get_utils/get_utils.dart';

class CustomConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final void Function()? onPressed;

  const CustomConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title.tr,
        style: titleStyle,
      ),
      content: Text(
        message.tr,
        style: bodyStyle,
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: primaryColor,
          ),
          onPressed: onPressed,
          child: Text(
            TextRoutes.confirm.tr,
            style: bodyStyle.copyWith(color: white),
          ),
        ),
        TextButton(
          child: Text(
            TextRoutes.cancel.tr,
            style: titleStyle.copyWith(color: Colors.red),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class buttonColor {}

void showConfirmDialog(
    String? title, String? message, void Function()? onPressed) {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (BuildContext context) {
      return CustomConfirmDialog(
        title: title!.tr,
        message: message!.tr,
        onPressed: onPressed,
      );
    },
  );
}
