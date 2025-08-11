// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/keyboard_listener.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/shared/buttons/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Future<void> cashierDialog(
  String title,
  IconData iconData,
  TextEditingController controller,
  void Function()? onSubmit,
  void Function() onReset,
) async {
  final cashierController = Get.put(CashierController());

  return showDialog(
    context: Get.context!,
    barrierDismissible: true,
    builder: (context) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: 420,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10),
                  child: Form(
                    key: cashierController.formState,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon(iconData, size: 48, color: primaryColor),
                        const SizedBox(height: 10),
                        Text(
                          title.tr,
                          style: titleStyle.copyWith(
                            fontSize: 22.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        CustomTextFieldWidget(
                          controller: controller,
                          borderColor: primaryColor,
                          fieldColor: white,
                          hinttext: title,
                          labeltext: title,
                          iconData: iconData,
                          valid: (value) => validInput(value!, 1, 10, 'number'),
                          isNumber: true,
                        ),
                        const SizedBox(height: 16),

                        /// Submit Button with Keyboard Listener
                        customKeyboardListener(
                          focusNode: FocusNode(),
                          logicalKeyboardKeys: LogicalKeyboardKey.enter,
                          onTap: () {
                            if (cashierController.formState.currentState!
                                .validate()) {
                              onSubmit?.call();
                              Get.back();
                            }
                          },
                          child: customButtonGlobal(
                            () {
                              if (cashierController.formState.currentState!
                                  .validate()) {
                                onSubmit?.call();
                                Get.back();
                              }
                            },
                            'Submit',
                            Icons.check_circle_outline,
                            primaryColor,
                            white,
                            double.infinity,
                            48,
                          ),
                        ),

                        /// Reset Button
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () {
                              onReset();
                              Get.back();
                            },
                            icon: const Icon(Icons.restart_alt),
                            label: Text(
                              'Reset',
                              style: bodyStyle.copyWith(
                                color: secondColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: secondColor,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              minimumSize: const Size(50, 35),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Close Button (Top Right)
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon:
                        const Icon(Icons.close_rounded, color: Colors.black54),
                    onPressed: () => Get.back(),
                    tooltip: "Close",
                    splashRadius: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
