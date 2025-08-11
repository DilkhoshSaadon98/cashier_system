import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/dialogs/snackbar_helper.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchWidgetMobile extends StatelessWidget {
  const SearchWidgetMobile({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CashierController());
    return GetBuilder<CashierController>(builder: (controller) {
      return SizedBox(
        height: 60,
        width: Get.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onLongPress: () {},
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: buttonColor,
                    border: Border.all(width: 1, color: primaryColor),
                    borderRadius: BorderRadius.circular(5)),
                child: IconButton(
                    onPressed: () {
                      String? cartNumber = myServices.systemSharedPreferences
                          .getString("cart_number");
                      if (cartNumber == null) {
                        showErrorSnackBar(TextRoutes.emptyCart);
                        return;
                      }
                      controller.goToItemsScreen();
                    },
                    icon: const Icon(
                      Icons.search,
                      color: white,
                      size: 30,
                    )),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Container(
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: whiteButtonColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  formattingNumbers(controller.cartTotalPrice),
                  style: titleStyle.copyWith(color: white, fontSize: 30),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
