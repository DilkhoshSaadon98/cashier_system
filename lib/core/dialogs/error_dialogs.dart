import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/main.dart';
import 'package:flutter/material.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:get/get_utils/get_utils.dart';

class CustomErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final String error;

  const CustomErrorDialog(
      {super.key,
      required this.title,
      required this.message,
      required this.error});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title.tr,
        style: titleStyle,
      ),
      content: Text(
        "${error.tr} ", //\n $error
        style: bodyStyle,
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            TextRoutes.confirm.tr,
            style: titleStyle,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

void showErrorDialog(String error, {String? title, String? message}) {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (BuildContext context) {
      return CustomErrorDialog(
        title: title ?? TextRoutes.error,
        message: message!,
        error: error,
      );
    },
  );
}
