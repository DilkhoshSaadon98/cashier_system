import 'dart:ui';

import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/shared/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_divider.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:get/get.dart';

Widget? customPaymentDialog() {
  CashierController controller = Get.put(CashierController());
  Get.defaultDialog(
      title: "",
      middleText: "",
      content: Focus(
        autofocus: true,
        focusNode: FocusNode(),
        child: BackdropFilter(
          filter:
              ImageFilter.blur(tileMode: TileMode.clamp, sigmaX: 1, sigmaY: 1),
          child: Row(
            children: [
              SingleChildScrollView(
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: ListView(
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        width: Get.width,
                        height: 50,
                        child: Text(
                          "Order Payment".tr,
                          style: titleStyle.copyWith(fontSize: 30),
                        ),
                      ),
                      customDivider(),
                      customSizedBox(30),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Price".tr,
                              style: bodyStyle.copyWith(fontSize: 20),
                            ),
                            Text(
                              formattingNumbers(controller.cartTotalPrice),
                              style: bodyStyle.copyWith(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      controller.cartTotalCostPrice > controller.cartTotalPrice
                          ? Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Loss".tr,
                                    style: bodyStyle.copyWith(
                                        fontSize: 20, color: Colors.red),
                                  ),
                                  Text(
                                    formattingNumbers(
                                        controller.cartTotalCostPrice -
                                            controller.cartTotalPrice),
                                    style: bodyStyle.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.red),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Remender".tr,
                              style: bodyStyle.copyWith(fontSize: 20),
                            ),
                            GetBuilder<CashierController>(
                                builder: (controller) {
                              return Text(
                                formattingNumbers(controller.totalPrice),
                                style: bodyStyle.copyWith(fontSize: 20),
                              );
                            })
                          ],
                        ),
                      ),
                      customButtonGlobal(() {
                        if (controller.cartTotalCostPrice >
                            controller.cartTotalPrice) {}
                        controller.cartPayment(
                          controller.cartData[0].cartOwner!,
                          controller.cartData[0].cartTax ?? "0",
                          controller.cartData[0].cartDiscount!.toString(),
                          controller.cartTotalPrice.toString(),
                          controller.cartTotalCostPrice.toString(),
                          controller.cartItemsCount.toString(),
                          controller.cartData[0].cartCash == "0"
                              ? "Dept"
                              : "Cash",
                        );
                        Get.back();
                      }, "PAY", Icons.payment, primaryColor, white)
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: SimpleCalculator(
                    value: 0,
                    hideExpression: true,
                    onChanged: (key, value, expression) {
                      String val = value
                          .toString()
                          .substring(0, value.toString().length - 2);
                      controller.calculateTotalCartPrice(val);
                      controller.update();
                    },
                    theme: CalculatorThemeData(
                      borderColor: primaryColor,
                      borderWidth: .5,
                      commandColor: primaryColor.withOpacity(.5),
                      expressionColor: secondColor.withOpacity(.5),
                      commandStyle:
                          titleStyle.copyWith(fontSize: 30, color: white),
                      expressionStyle:
                          titleStyle.copyWith(fontSize: 16, color: secondColor),
                      numColor: white,
                      numStyle: titleStyle.copyWith(
                        fontSize: 30,
                      ),
                      operatorColor: secondColor.withOpacity(.5),
                      operatorStyle:
                          titleStyle.copyWith(fontSize: 30, color: secondColor),
                      displayColor: primaryColor,
                      displayStyle:
                          titleStyle.copyWith(fontSize: 80, color: secondColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
  return null;
}
