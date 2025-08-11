import 'package:cashier_system/controller/auth/register_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/screen_routes.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/responsive/screen_builder.dart';
import 'package:cashier_system/core/shared/buttons/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_formfield_global.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/view/home/desktop/home_logo.dart';
import 'package:cashier_system/view/home/mobile/home_logo_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class VerifyAccountScreen extends StatelessWidget {
  const VerifyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RegisterController controller = Get.put(RegisterController());
    return Scaffold(
      backgroundColor: primaryColor,
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: ScreenBuilder(
          windows: Row(
            children: [
              Expanded(
                child: Scaffold(
                  backgroundColor: white,
                  body: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(15),
                      width: Get.width / 2,
                      child: VerifyAccountFormWidget(controller: controller)),
                ),
              ),
              Expanded(
                  child: Container(
                color: primaryColor,
                alignment: Alignment.center,
                child: buildLogoDesktop(),
              ))
            ],
          ),
          mobile: Scaffold(
            backgroundColor: white,
            body: SingleChildScrollView(
              child: Container(
                  height: Get.height,
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.all(15),
                  child: VerifyAccountFormWidget(controller: controller)),
            ),
          ),
        ),
      ),
    );
  }
}

class VerifyAccountFormWidget extends StatelessWidget {
  const VerifyAccountFormWidget({
    super.key,
    required this.controller,
  });

  final RegisterController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formVerifyAccount,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 75,
            child: Text(
              "Verify Account".tr,
              style: titleStyle.copyWith(fontSize: 50.sp),
            ),
          ),
          verticalGap(),
          CustomTextFormFieldGlobal(
            mycontroller: controller.verifyCodeController,
            borderColor: primaryColor,
            hinttext: "Verify Code",
            labeltext: "Verify Code",
            iconData: Icons.verified,
            valid: (value) {
              return validInput(value!, 0, 100, "number");
            },
            isNumber: true,
          ),
          verticalGap(25),
          Tooltip(
            message:
                "Please ensure your device is connected to the network.".tr,
            textStyle: bodyStyle,
            decoration: const BoxDecoration(color: white),
            child: customButtonGlobal(() {
              controller.verifyAccount();
            }, "Confirm", Icons.check, primaryColor, white),
          ),
          verticalGap(10),
          Row(
            children: [
              Expanded(
                child: customButtonGlobal(() {
                  Get.toNamed(AppRoute.registerSystemScreen);
                  myServices.sharedPreferences.setString("step", "register");
                }, "Back", Icons.arrow_back_ios, white, primaryColor),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: customButtonGlobal(() {
                  controller.resendCode();
                }, "Resend code", Icons.refresh_rounded, buttonColor, white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
