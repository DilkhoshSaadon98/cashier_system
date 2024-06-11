import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:flutter/material.dart';

Widget checkData(var data, int flex, Widget child) {
  if (data.length == 0) {
    return Expanded(
        flex: flex,
        child: Text(
          textAlign: TextAlign.center,
          "No Data",
          style: titleStyle.copyWith(fontSize: 25),
        ));
  } else {
    return child;
  }
}
