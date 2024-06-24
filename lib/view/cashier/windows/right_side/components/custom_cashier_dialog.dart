import 'dart:ui';

import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/keyboard_listener.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/shared/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_formfield_global.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

cashierDialog(String title, IconData iconData, TextEditingController controller,
    void Function()? onTap) {
  CashierController cashierController = Get.put(CashierController());
  return Get.defaultDialog(
    title: "",
    titleStyle: titleStyle,
    content: BackdropFilter(
      filter:
          ImageFilter.blur(sigmaX: 1, sigmaY: 1, tileMode: TileMode.repeated),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: cashierController.formstate,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title.tr,
                style: bodyStyle.copyWith(fontSize: 20),
              ),
              customSizedBox(25),
              Focus(
                autofocus: true,
                child: CustomTextFormFieldGlobal(
                    mycontroller: controller,
                    borderColor: primaryColor,
                    hinttext: title,
                    labeltext: title,
                    iconData: Icons.dataset_outlined,
                    valid: (value) {
                      return validInput(value!, 1, 10, 'number');
                    },
                    isNumber: true),
              ),
              customSizedBox(),
              customKeyboardListener(
                  focusNode: FocusNode(),
                  logicalKeyboardKeys: LogicalKeyboardKey.enter,
                  onTap: onTap!,
                  
                  child: customButtonGlobal(onTap, 'Submit', Icons.check,
                      primaryColor, white, 400, 50))
            ],
          ),
        ),
      ),
    ),
  );
}
