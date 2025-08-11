import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

Future<bool?> showDeleteDialog(
    {required BuildContext context,
    required String title,
    required String content,
    required void Function()? onPressed}) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          TextRoutes.warning.tr,
          style: titleStyle.copyWith(fontSize: 16),
        ),
        content: Text(
          TextRoutes.sureRemoveData.tr,
          style: bodyStyle,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(
              TextRoutes.cancel.tr,
              style: titleStyle,
            ),
          ),
          TextButton(
            onPressed: onPressed,
            child: Text(
              TextRoutes.confirm.tr,
              style: titleStyle.copyWith(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}
