import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/shared/buttons/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/setting/back_up_controller.dart';

class BackUpWidget extends StatelessWidget {
  const BackUpWidget({
    super.key,
    required this.controller,
  });

  final BackUpController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        GetBuilder<BackUpController>(builder: (controller) {
          return Container(
            margin: EdgeInsets.all(20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Last backup at - ".tr,
                  style: titleStyle.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  " ${myServices.sharedPreferences.getString("backup_time") ?? currentTime}",
                  style: titleStyle.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Backup path".tr,
              style: titleStyle.copyWith(fontSize: 16.sp),
            ),
            Flexible(
              child: InkWell(
                onTap: () async {
                  await controller.pickFolder();
                },
                child: GetBuilder<BackUpController>(builder: (controller) {
                  return Text(
                    myServices.sharedPreferences.getString("backup_path") ??
                        "Select path".tr,
                    style: titleStyle.copyWith(overflow: TextOverflow.ellipsis),
                  );
                }),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Time for automatic backup".tr,
              style: titleStyle.copyWith(fontSize: 16.sp),
            ),
            GetBuilder<BackUpController>(builder: (controller) {
              return DropdownButton<String>(
                value: controller.selectedTime,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: primaryColor,
                ),
                iconSize: 30,
                elevation: 16,
                style: titleStyle,
                underline: Container(
                  color: white,
                ),
                onChanged: (String? newValue) {
                  controller.changeTime(newValue!);
                },
                items: controller.timeOptions
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              );
            })
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Automatic backup".tr,
              style: titleStyle.copyWith(fontSize: 16.sp),
            ),
            GetBuilder<BackUpController>(builder: (controller) {
              return Switch(
                  value: myServices.sharedPreferences.getBool("auto_back_up") ??
                      false,
                  onChanged: (val) {
                    controller.autoBackup(val);
                  });
            }),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Save local backUp".tr,
              style: titleStyle.copyWith(fontSize: 16.sp),
            ),
            GetBuilder<BackUpController>(builder: (controller) {
              return Switch(value: true, onChanged: (val) {});
            }),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Save Online backUp".tr,
              style: titleStyle.copyWith(fontSize: 16.sp),
            ),
            GetBuilder<BackUpController>(builder: (controller) {
              return Switch(value: true, onChanged: (val) {});
            }),
          ],
        ),

        verticalGap(40),
        //! Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: customButtonGlobal(() async {
                await controller.saveCopyToDirectory();
              }, "Local BuckUp", Icons.backup, primaryColor, white, 200),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: customButtonGlobal(() async {
                await controller.restoreDatabase();
              }, "Restore Local BackUp", Icons.get_app, primaryColor, white,
                  200),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: customButtonGlobal(() async {
                await controller.saveCopyToCloud();
              }, "Online Backup", Icons.backup, primaryColor, white, 200),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: customButtonGlobal(() async {
                await controller.restoreDatabaseFromCloud();
              }, "Restore Online BackUp", Icons.get_app, primaryColor, white,
                  200),
            ),
          ],
        )
      ],
    );
  }
}
