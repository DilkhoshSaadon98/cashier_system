// ignore: file_names
import 'package:cashier_system/controller/setting/setting_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/constant/routes.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RightSideWidget extends StatelessWidget {
  const RightSideWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SettingController());
    return Expanded(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(
          color: primaryColor,
          border: Border.all(width: 1.w),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          children: [
            CustomHeaderScreen(
              imagePath: AppImageAsset.settingIcons,
              title: "Setting",
              root: () {
                Get.offAllNamed(AppRoute.settingScreen);
              },
            ),
            customSizedBox(25),
            //buttons
            SizedBox(
                height: 0.7.sh,
                child: GetBuilder<SettingController>(builder: (controller) {
                  return ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            controller.changeIndex(index);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 0.01.sw, vertical: 15),
                            alignment: Alignment.center,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: white),
                              //color: fourthColor,
                              borderRadius: BorderRadius.circular(5.w),
                            ),
                            child: Text(
                              controller.settingTabName[index],
                              style: titleStyle.copyWith(color: white),
                            ),
                          ),
                        );
                      });
                }))
          ],
        ),
      ),
    );
  }
}
