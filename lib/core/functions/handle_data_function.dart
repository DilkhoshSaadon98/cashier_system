import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';

Widget checkData(var data, Widget child) {
  bool state = myServices.sharedPreferences.getBool("show_data") ?? false;
  if (state == true) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        textAlign: TextAlign.center,
        TextRoutes.hideData,
        style: titleStyle.copyWith(fontSize: 25),
      ),
    );
  } else if (data.length == 0) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        textAlign: TextAlign.center,
        TextRoutes.noData.tr,
        style: titleStyle.copyWith(fontSize: 25),
      ),
    );
  } else {
    return child;
  }
}
