import 'dart:ui';

import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:flutter/material.dart';

Widget checkData(var data, int flex, Widget child) {
  bool state = false;
  if (state == false) {
    return Expanded(
        flex: flex,
        child: Container(
          alignment: Alignment.center,
          child: Text(
            textAlign: TextAlign.center,
            "Admin Password Required to show Data",
            style: titleStyle.copyWith(fontSize: 25),
          ),
        ));
    
  } else if (data.length == 0) {
    return Expanded(
        flex: flex,
        child: Container(
          alignment: Alignment.center,
          child: Text(
            textAlign: TextAlign.center,
            "No Data",
            style: titleStyle.copyWith(fontSize: 25),
          ),
        ));
  } else {
    return child;
  }
}
