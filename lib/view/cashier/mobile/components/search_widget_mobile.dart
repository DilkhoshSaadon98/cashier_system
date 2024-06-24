import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/view/cashier/windows/left_side/components/show_drop_down_items_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchWidgetMobile extends StatelessWidget {
  const SearchWidgetMobile({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CashierController());
    return GetBuilder<CashierController>(builder: (controller) {
      return Expanded(
        child: Row(
          children: [
            Expanded(
              child: IconButton(
                  onPressed: () {
                    showDropDownList(
                      context,
                      controller.dropDownList,
                      controller.dropDownID!,
                      controller.dropDownName!,
                    );
                  },
                  icon: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        shape: BoxShape.rectangle,
                        color: primaryColor),
                    child: const Icon(
                      Icons.search,
                      color: secondColor,
                      size: 30,
                    ),
                  )),
            ),
            Expanded(
              flex: 6,
              child: Container(
                width: Get.width,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: secondColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Total Price'.tr,
                      style: titleStyle.copyWith(
                          color: primaryColor, fontSize: 26),
                    ),
                    Text(
                      formattingNumbers(controller.cartTotalPrice),
                      style: titleStyle.copyWith(
                          color: primaryColor, fontSize: 30),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
