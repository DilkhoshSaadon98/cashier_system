import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/shared/custom_formfield_global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class CustomTextFieldSetting extends StatelessWidget {
  String title;
  TextEditingController? controller;
  String validate;
  IconData iconData;
  CustomTextFieldSetting(
      this.title, this.controller, this.validate, this.iconData,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title.tr,
              style: titleStyle.copyWith(fontSize: 18),
            ),
          ),
          Expanded(
            flex: 2,
            child: CustomTextFormFieldGlobal(
                hinttext: title == "Old Username" &&
                        myServices.sharedPreferences
                                .getString("admins_username") !=
                            null
                    ? myServices.sharedPreferences
                        .getString("admins_username")
                        .toString()
                    : title,
                labeltext: title,
                iconData: iconData,
                valid: (value) {
                  return validInput(value!, 0, 50, validate);
                },
                mycontroller: controller,
                borderColor: primaryColor,
                isNumber: false),
          )
        ],
      ),
    );
  }
}
