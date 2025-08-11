import 'package:cashier_system/controller/auth/register_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
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

class RegisterSystemScreen extends StatelessWidget {
  const RegisterSystemScreen({super.key});

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
                    child: RegisterFormWidget(controller: controller),
                  ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildLogoMobile(),
                    RegisterFormWidget(controller: controller),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterFormWidget extends StatelessWidget {
  const RegisterFormWidget({
    super.key,
    required this.controller,
  });

  final RegisterController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: controller.formStateRegister,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 75,
              child: Text(
                "System Registration".tr,
                style: titleStyle.copyWith(fontSize: 50.sp),
              ),
            ),
            verticalGap(),
            SizedBox(
              height: 300.h,
              child: GetBuilder<RegisterController>(builder: (controller) {
                return controller.alreadyHaveAccount
                    ? Column(
                        children: [
                          CustomTextFormFieldGlobal(
                            mycontroller: controller.otpController,
                            borderColor: primaryColor,
                            hinttext: "Otp",
                            labeltext: "Otp",
                            iconData: Icons.code,
                            valid: (value) {
                              return validInput(value!, 0, 100, "");
                            },
                            isNumber: false,
                            obscureText: controller.showOtpData,
                            onTapIcon: () {
                              controller.changeOtpShowing();
                            },
                            suffixIconData: Icons.remove_red_eye,
                          ),
                          verticalGap(10),
                          CustomTextFormFieldGlobal(
                            mycontroller: controller.customerEmailController,
                            borderColor: primaryColor,
                            hinttext: "E-mail",
                            labeltext: "E-mail",
                            iconData: Icons.code,
                            valid: (value) {
                              return validInput(value!, 0, 200, "email");
                            },
                            isNumber: false,
                          ),
                          verticalGap(10),
                          CustomTextFormFieldGlobal(
                            mycontroller: controller.customerPasswordController,
                            borderColor: primaryColor,
                            hinttext: "Password",
                            labeltext: "Password",
                            iconData: Icons.code,
                            valid: (value) {
                              return validInput(value!, 0, 100, "");
                            },
                            isNumber: false,
                            obscureText: controller.showPasswordData,
                            onTapIcon: () {
                              controller.changePasswordShowing();
                            },
                            suffixIconData: Icons.remove_red_eye,
                          ),
                          verticalGap(10),
                        ],
                      )
                    : ListView.builder(
                        itemCount: controller.inputData.length,
                        itemBuilder: (context, index) {
                          String key =
                              controller.inputData.keys.elementAt(index);
                          Map<String, dynamic> fieldData =
                              controller.inputData[key]!;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: CustomTextFormFieldGlobal(
                              mycontroller: controller.controllerList![index],
                              borderColor: primaryColor,
                              hinttext: fieldData["label"],
                              labeltext: fieldData["label"],
                              iconData: fieldData["icon"],
                              valid: (value) {
                                return validInput(value!, 0, 100, "");
                              },
                              isNumber: false,
                              obscureText: index == 0
                                  ? controller.showOtpData
                                  : index == 5
                                      ? controller.showPasswordData
                                      : false,
                              onTapIcon: index == 0
                                  ? () {
                                      controller.changeOtpShowing();
                                    }
                                  : index == 5
                                      ? () {
                                          controller.changePasswordShowing();
                                        }
                                      : null,
                              suffixIconData: Icons.remove_red_eye,
                            ),
                          );
                        },
                      );
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    "Already registered from this account?".tr,
                    style: titleStyle.copyWith(overflow: TextOverflow.ellipsis),
                  ),
                ),
                GetBuilder<RegisterController>(builder: (controller) {
                  return Tooltip(
                    textStyle: bodyStyle,
                    decoration: const BoxDecoration(color: white),
                    message:
                        "If you have already used this device to log in with this code, please check this box."
                            .tr,
                    child: Checkbox(
                        value: controller.alreadyHaveAccount,
                        onChanged: (value) {
                          controller.alreadyHaveAccounts(value!);
                        }),
                  );
                })
              ],
            ),
            verticalGap(25),
            Tooltip(
              message:
                  "Please ensure your device is connected to the network.".tr,
              textStyle: bodyStyle,
              decoration: const BoxDecoration(color: white),
              child: customButtonGlobal(() {
                controller.register();
              }, "Confirm", Icons.check, primaryColor, white),
            )
          ],
        ),
      ),
    );
  }
}
