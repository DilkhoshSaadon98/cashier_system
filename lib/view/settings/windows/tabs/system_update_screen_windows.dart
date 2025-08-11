import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/buttons/custom_buttton_global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UpdateSystemScreen extends StatelessWidget {
  const UpdateSystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarTitle("System Update"),
      backgroundColor: white,
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(20.h),
              child: Text(
                "OS version 1.0.0",
                style: TextStyle(
                  fontSize: 35.sp,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: Get.width / 2.5,
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Automatic Update",
                    style: titleStyle.copyWith(fontSize: 20.sp),
                  ),
                  Switch(value: true, onChanged: (val) {})
                ],
              ),
            ),
            SizedBox(
              width: Get.width / 2.5,
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Download OS updates",
                    style: titleStyle.copyWith(fontSize: 20.sp),
                  ),
                  Switch(value: true, onChanged: (val) {})
                ],
              ),
            ),
            SizedBox(
              width: Get.width / 2.5,
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "install OS updates",
                    style: titleStyle.copyWith(fontSize: 20.sp),
                  ),
                  Switch(value: true, onChanged: (val) {})
                ],
              ),
            ),
            SizedBox(
              width: Get.width / 2.5,
              child: Row(
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
              ),
            )
            //button
          ],
        ),
      ),
    );
  }
}
