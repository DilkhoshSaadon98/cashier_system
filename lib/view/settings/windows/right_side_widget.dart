// ignore: file_names
import 'package:cashier_system/controller/setting/setting_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/constant/screen_routes.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/view/invoices/windows/invoices_screen_windows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RightSideWidget extends StatelessWidget {
  const RightSideWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SettingController());
    return ListView(
      children: [
        const CustomHeaderScreen(
          imagePath: AppImageAsset.settingIcons,
          title: "Settings",
        ),
        verticalGap(25),
        //buttons
        SizedBox(
            height: 0.8.sh,
            child: GetBuilder<SettingController>(builder: (controller) {
              return ListView.builder(
                  itemCount: controller.settingTabName.length,
                  itemBuilder: (context, index) {
                    return MouseRegion(
                      onEnter: (_) {
                        controller.checkHover(true, index);
                      },
                      onExit: (_) {
                        controller.checkHover(false, index);
                      },
                      child: InkWell(
                        onTap: () {
                          controller.changeIndex(index);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          height: 55,
                          decoration: BoxDecoration(
                            color: controller.isHovering[index]
                                // ignore: deprecated_member_use
                                ? buttonColor.withOpacity(0.8)
                                : white,
                            border: Border.all(width: 1.5, color: primaryColor),
                            borderRadius: BorderRadius.circular(constRadius),
                            boxShadow: [
                              if (controller.isHovering[index])
                                BoxShadow(
                                  // ignore: deprecated_member_use
                                  color: buttonColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                controller.settingTabName[index].tr,
                                style: titleStyle.copyWith(
                                  color: !controller.isHovering[index]
                                      ? buttonColor
                                      : white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: controller.isHovering[index]
                                    ? white
                                    : buttonColor,
                                size: 20.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }))
      ],
    );
  }
}
