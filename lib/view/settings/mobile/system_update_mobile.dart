import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/change_direction.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/buttons/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SystemUpdateMobile extends StatelessWidget {
  const SystemUpdateMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: screenDirection(),
      child: Scaffold(
        appBar: customAppBarTitle("System Update", true),
        backgroundColor: white,
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(5.h),
                child: Text(
                  "OS version 1.0.0",
                  style: TextStyle(
                    fontSize: 35.sp,
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Automatic Update".tr,
                    style: titleStyle.copyWith(fontSize: 16.sp),
                  ),
                  Switch(value: true, onChanged: (val) {})
                ],
              ),
              verticalGap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Download OS updates".tr,
                    style: titleStyle.copyWith(fontSize: 16.sp),
                  ),
                  Switch(value: true, onChanged: (val) {})
                ],
              ),
              verticalGap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "install OS updates".tr,
                    style: titleStyle.copyWith(fontSize: 16.sp),
                  ),
                  Switch(value: true, onChanged: (val) {})
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: customButtonGlobal(() async {}, "Check For Update",
                        Icons.backup, primaryColor, white, 200),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: customButtonGlobal(() async {}, "Update Now",
                        Icons.backup_outlined, Colors.teal, white, 200),
                  ),
                ],
              )
              //button
            ],
          ),
        ),
      ),
    );
  }
}
