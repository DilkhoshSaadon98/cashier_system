import 'package:cashier_system/controller/setting/security_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/shared/buttons/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_divider.dart';
import 'package:cashier_system/core/shared/custom_formfield_global.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecurityWidget extends StatelessWidget {
  const SecurityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SecurityController());
    return GetBuilder<SecurityController>(builder: (controller) {
      return ListView(
        children: [
          Text(
            "Change Username and Password".tr,
            style:
                titleStyle.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          verticalGap(),
          controller.checkValidUser == false
              ? Form(
                  key: controller.currentFormState,
                  child: Column(
                    children: [
                      CustomTextFormFieldGlobal(
                          hinttext: myServices.sharedPreferences
                                      .getString("admins_username") !=
                                  null
                              ? myServices.sharedPreferences
                                  .getString("admins_username")
                                  .toString()
                              : "Old Username",
                          labeltext: "Old Username",
                          iconData: Icons.person,
                          valid: (value) {
                            return validInput(value!, 0, 50, "username");
                          },
                          mycontroller: controller.oldUsername,
                          borderColor: primaryColor,
                          isNumber: false),
                      verticalGap(10),
                      CustomTextFormFieldGlobal(
                          hinttext: "Old Password",
                          labeltext: "Old Password",
                          iconData: Icons.password_outlined,
                          valid: (value) {
                            return validInput(value!, 0, 50, "");
                          },
                          mycontroller: controller.oldPassword,
                          borderColor: primaryColor,
                          isNumber: false),
                      verticalGap(10),
                    ],
                  ),
                )
              : Form(
                  key: controller.newFormState,
                  child: Column(
                    children: [
                      CustomTextFormFieldGlobal(
                          hinttext: "New Username",
                          labeltext: "New Username",
                          iconData: Icons.person,
                          valid: (value) {
                            return validInput(value!, 0, 50, "username");
                          },
                          mycontroller: controller.newUsername,
                          borderColor: primaryColor,
                          isNumber: false),
                      verticalGap(10),
                      CustomTextFormFieldGlobal(
                          hinttext: "New Password",
                          labeltext: "New Password",
                          iconData: Icons.password_outlined,
                          valid: (value) {
                            return validInput(value!, 0, 50, "");
                          },
                          mycontroller: controller.newPassword,
                          borderColor: primaryColor,
                          isNumber: false),
                      verticalGap(10),
                    ],
                  ),
                ),
          controller.checkValidUser == true
              ? Row(
                  children: [
                    Expanded(
                      child: customButtonGlobal(
                        () {
                          controller.checkValidUser = false;
                          controller.update();
                        },
                        "Back",
                        Icons.save,
                        Colors.teal,
                        white,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: customButtonGlobal(
                        () {
                          controller.changeUsernamePassword();
                        },
                        "Save Changes",
                        Icons.save,
                        primaryColor,
                        white,
                      ),
                    ),
                  ],
                )
              : customButtonGlobal(() {
                  controller.validateUser();
                }, "Check", Icons.check, primaryColor, white, 500),
          verticalGap(),
          customDivider(),
          verticalGap(),
          Text(
            "Request manager password for".tr,
            style:
                titleStyle.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          verticalGap(),
          ...List.generate(3, (index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(controller.securitySwitchTitle[index].tr,
                    style: titleStyle.copyWith(fontSize: 20)),
                Switch(
                    value: controller.securitySwitchState[index],
                    activeColor: secondColor,
                    activeTrackColor: grey2,
                    inactiveThumbColor: white,
                    inactiveTrackColor: tableHeaderColor,
                    onChanged: (val) {
                      controller.setSecurityData(index, val);
                    }),
              ],
            );
          }),
        ],
      );
    });
  }
}
