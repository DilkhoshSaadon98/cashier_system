import 'package:cashier_system/controller/setting/security_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/view/Settings/widgets/custom_textfield_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SecurityController());
    return GetBuilder<SecurityController>(builder: (controller) {
      return Scaffold(
        appBar: customAppBarTitle("Security"),
        body: SizedBox(
          width: Get.width,
          child: Form(
            key: controller.formstate,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: Text(
                      "Change Username and Password".tr,
                      style: titleStyle.copyWith(fontSize: 28),
                    ),
                  ),
                  CustomTextFieldSetting("Old Username", controller.oldUsername,
                      "username", Icons.person),
                  CustomTextFieldSetting("Old Password", controller.oldPassword,
                      "", Icons.security),
                  CustomTextFieldSetting("New Username", controller.newUsername,
                      "username", Icons.person),
                  CustomTextFieldSetting("New Password", controller.newPassword,
                      "", Icons.security),
                  customButtonGlobal(() {
                    controller.changeUsernamePassword();
                  }, "Save Changes", Icons.save, primaryColor, white, 500),
                  Container(
                    width: 0.35.sw,
                    margin: EdgeInsets.only(top: 40.h, bottom: 20.h),
                    child: Text(
                      "Request manager password for".tr,
                      style: titleStyle.copyWith(fontSize: 24),
                    ),
                  ),
                  customSizedBox(20),
                  ...List.generate(3, (index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      width: 500,
                      height: 0.04.sh,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(controller.securitySwitchTitle[index].tr,
                              style: bodyStyle.copyWith(fontSize: 20)),
                          Switch(
                              value: controller.securitySwitchState[index],
                              onChanged: (val) {
                                controller.setSecurityData(index, val);
                              }),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
