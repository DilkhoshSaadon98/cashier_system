import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/view/cashier/windows/view/components/cashier_table_rows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CustomTableWidgetMobile extends StatelessWidget {
  const CustomTableWidgetMobile({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CashierController());

    return GetBuilder<CashierController>(builder: (controller) {
      return (myServices.sharedPreferences.getBool("start_new_cart") == true ||
              controller.cartData.isEmpty)
          ? Container(
              width: Get.width,
              height: .34.sh,
              alignment: Alignment.center,
              color: white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Please choose items or scanning a barcode".tr,
                    style: titleStyle.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 10), // Ensure correct use of SizedBox
                  const Icon(
                    FontAwesomeIcons.barcode,
                    color: primaryColor,
                  ),
                ],
              ),
            )
          : Container(
              color: Colors.white,
              height: .34.sh,
              child:
                  const CashierTableRows(), // Ensure `CashierTableRows` is implemented correctly.
            );
    });
  }
}
