import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/shared/buttons/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_divider.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget? customPaymentDialogMobile() {
  CashierController controller = Get.put(CashierController());

  Get.defaultDialog(
    title: "Order Payment".tr,
    middleText: "",
    content: Container(
      padding: const EdgeInsets.all(16.0),
      width: Get.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Total Price Display
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Total Price".tr,
                  style: bodyStyle.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                verticalGap(4),
                Text(
                  formattingNumbers(controller.cartTotalPrice),
                  style: bodyStyle.copyWith(
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          customDivider(),
          verticalGap(10),

          // Loss Display (If Applicable)
          if (controller.cartTotalCostPrice > controller.cartTotalPrice)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Loss".tr,
                    style: bodyStyle.copyWith(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    formattingNumbers(controller.cartTotalCostPrice -
                        controller.cartTotalPrice),
                    style: bodyStyle.copyWith(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          customDivider(),
          verticalGap(10),

          // Input for Price (TextFormField)
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Enter Paid Amount'.tr,
              labelStyle: titleStyle,
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor)),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                controller.calculateTotalCartPrice(value);
                controller.update();
              }
            },
          ),
          verticalGap(10),

          // Reminder Display
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Reminder".tr,
                  style: bodyStyle.copyWith(
                    fontSize: 18,
                  ),
                ),
                GetBuilder<CashierController>(
                  builder: (controller) {
                    return Text(
                      formattingNumbers(controller.totalPrice),
                      style: bodyStyle.copyWith(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          verticalGap(16),

          Row(
            children: [
              Expanded(
                child: customButtonGlobal(
                  () {
                    controller.cartPayment(
                      controller.cartData[0].accountId!,
                      controller.cartData[0].cartTax,
                      controller.cartData[0].cartDiscount.toString(),
                      controller.cartTotalPrice.toString(),
                      controller.cartTotalCostPrice.toString(),
                      controller.cartItemsCount.toString(),
                      controller.cartData[0].cartCash == "0" ? "Dept" : "Cash",
                    );
                    if (myServices.systemSharedPreferences
                                .getBool("auto_print") ==
                            true ||
                        myServices.systemSharedPreferences
                                .getBool("auto_print") ==
                            null) {
                      controller.buttonsDetails[0]
                          ['function'](controller.buttonsDetails[0]['title']);
                    }
                    Get.back();
                  },
                  'Submit'.tr,
                  Icons.check,
                  primaryColor,
                  white,
                  Get.width,
                  50,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  return null;
}
