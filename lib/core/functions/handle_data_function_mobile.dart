import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/get_utils.dart';

Widget checkDataMobile(int data, Widget child) {
  bool state = myServices.sharedPreferences.getBool("show_data") ?? false;
  String adminRole =
      myServices.sharedPreferences.getString("admins_role") ?? "Full Access";
  if (state == true && adminRole != "Full Access") {
    return Container(
      height: .6.sh,
      alignment: Alignment.center,
      child: Text(
        textAlign: TextAlign.center,
        "Hide Data".tr,
        style: titleStyle.copyWith(fontSize: 25),
      ),
    );
  } else if (data == 0) {
    return Container(
      height: .6.sh,
      alignment: Alignment.center,
      child: Text(
        textAlign: TextAlign.center,
        "No Data".tr,
        style: titleStyle.copyWith(fontSize: 25),
      ),
    );
  } else {
    return child;
  }
}
