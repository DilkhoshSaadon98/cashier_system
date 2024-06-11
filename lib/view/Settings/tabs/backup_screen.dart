import 'package:cashier_system/controller/setting/back_up_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BackupScreen extends StatelessWidget {
  const BackupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(BackUpController());
    return Scaffold(
      appBar: customAppBarTitle("Back Up"),
      body: GetBuilder<BackUpController>(builder: (controller) {
        return SizedBox(
          height: Get.height,
          child: GetBuilder<BackUpController>(builder: (controller) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(20.h),
                  child: Text(
                    "Last backup at ( ${myServices.sharedPreferences.getString("backup_time") ?? currentTime} )",
                    style: titleStyle.copyWith(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: 600,
                  margin: EdgeInsets.all(10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Automatic backup",
                        style: titleStyle.copyWith(fontSize: 20.sp),
                      ),
                      Switch(value: false, onChanged: (val) {}),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10.h),
                  width: 600,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Time for automatic backup",
                        style: titleStyle.copyWith(fontSize: 20.sp),
                      ),
                      Container(
                        width: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(width: .5, color: primaryColor),
                            borderRadius: BorderRadius.circular(5)),
                        child: DropdownButton<String>(
                          value: controller.selectedTime,
                          icon: Icon(
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
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10.h),
                  width: 600,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Save Local BackUp",
                        style: titleStyle.copyWith(fontSize: 20.sp),
                      ),
                      Switch(value: true, onChanged: (val) {}),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10.h),
                  width: 600,
                  height: 0.04.sh,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Backup Location",
                        style: titleStyle.copyWith(fontSize: 20.sp),
                      ),
                      InkWell(
                        onTap: () async {
                          await controller.pickFolder();
                        },
                        child: Text(
                          myServices.sharedPreferences
                                  .getString("backup_path") ??
                              "Select Path",
                          style: titleStyle,
                        ),
                      )
                    ],
                  ),
                ),
                customSizedBox(40),
                //! Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customButtonGlobal(() async {
                      await controller.saveCopyToDirectory();
                    }, "BuckUp Now", Icons.backup, primaryColor, white, 200),
                    const SizedBox(
                      width: 5,
                    ),
                    customButtonGlobal(() async {
                      await controller.restoreDatabase();
                    }, "Restore BackUp", Icons.backup_outlined, primaryColor,
                        white, 200),
                    const SizedBox(
                      width: 5,
                    ),
                    customButtonGlobal(() {}, "Export BackUp", Icons.backup,
                        primaryColor, white, 200),
                  ],
                )
              ],
            );
          }),
        );
      }),
    );
  }
}
