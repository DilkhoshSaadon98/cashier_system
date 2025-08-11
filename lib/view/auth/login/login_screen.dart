import 'package:cashier_system/controller/auth/login_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/responsive/screen_builder.dart';
import 'package:cashier_system/core/shared/custom_formfield_global.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/view/home/desktop/home_logo.dart';
import 'package:cashier_system/view/home/mobile/home_logo_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/shared/buttons/custom_buttton_global.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.put(LoginController());
    return Scaffold(
      backgroundColor: mobileScreenBackgroundColor,
      body: ScreenBuilder(
        mobile: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(constScreenPadding),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 400.w,
                  minHeight: Get.height - 100.h,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildLogoMobile(),
                    SizedBox(height: 24.h),
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(constRadius),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x0F000000),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: LoginWidgetForm(controller: controller),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        windows: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primaryColor, fourthColor],
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: const BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: SafeArea(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(constScreenPadding),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 400.w),
                          child: LoginWidgetForm(controller: controller),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(24.h),
                  child: buildLogoDesktop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginWidgetForm extends StatelessWidget {
  const LoginWidgetForm({
    super.key,
    required this.controller,
  });

  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formStateLogin,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Welcome Back".tr,
            style: titleStyle.copyWith(
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            "Sign in to your account".tr,
            style: titleStyle.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: grey2,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32.h),
          CustomTextFormFieldGlobal(
            hinttext: 'Enter your username',
            labeltext: "Username",
            iconData: Icons.person_outline_rounded,
            mycontroller: controller.email,
            valid: (value) {
              return validInput(value!, 1, 100, "");
            },
            isNumber: false,
            borderColor: primaryColor,
          ),
          SizedBox(height: 16.h),
          GetBuilder<LoginController>(builder: (controller) {
            return CustomTextFormFieldGlobal(
              hinttext: 'Enter your password',
              labeltext: "Password",
              iconData: Icons.lock_outline_rounded,
              mycontroller: controller.password,
              valid: (value) {
                return validInput(value!, 1, 100, "");
              },
              obscureText: controller.isShowPassword,
              onTapIcon: () {
                controller.showPassword();
              },
              isNumber: false,
              borderColor: primaryColor,
            );
          }),
          SizedBox(height: 32.h),
          customButtonGlobal(
            () async {
              await controller.login();
            },
            "Sign In",
            Icons.login_rounded,
          ),
          SizedBox(height: 16.h),
          customButtonGlobal(
            () {
              // Contact functionality
            },
            "Need Help?",
            Icons.help_outline_rounded,
            const Color(0xffF5F5F5),
            const Color(0xff424242),
          ),
        ],
      ),
    );
  }
}
