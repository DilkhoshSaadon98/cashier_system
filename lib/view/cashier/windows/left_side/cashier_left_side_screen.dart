import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/shared/custom_table_header_global.dart';
import 'package:cashier_system/view/cashier/windows/left_side/components/cashier_table_rows.dart';
import 'package:cashier_system/view/cashier/windows/left_side/components/custom_pending_cart.dart';
import 'package:cashier_system/view/cashier/windows/left_side/components/search_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CashierLeftSideScreen extends StatelessWidget {
  const CashierLeftSideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CashierController());
    return GetBuilder<CashierController>(builder: (controller) {
      return Expanded(
        flex: 6,
        child: Container(
          height: Get.height,
          color: primaryColor,
          child: Column(
            children: [
              Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        //? Show Pending Cart
                        controller.pendedCarts.isNotEmpty
                            ? const CustomPendingCarts()
                            : Container(),
                        //? Search Box
                        const SearchBoxWidget()
                      ],
                    ),
                  )),
              Expanded(
                flex: 1,
                child: CustomTableHeaderGlobal(
                  onDoubleTap: () {
                    controller.selectAllRows();
                  },
                  flex: const [1, 1, 3, 1, 2, 2, 1, 2, 2],
                  data: const [
                    "Select",
                    "Code",
                    "Items Name",
                    "Type",
                    "Price",
                    "Discount Price",
                    "Stack",
                    "Total Price",
                    "Quantity",
                  ],
                ),
              ),
              const CashierTableRows(),
              Expanded(
                  flex: 2,
                  child: Container(
                    color: primaryColor,
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, childAspectRatio: 7),
                        itemCount: controller.cashierFooter.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: white, border: Border.all(color: white)),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  height: Get.height,
                                  alignment: myServices.sharedPreferences
                                              .getString("lang") ==
                                          "en"
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  color: primaryColor,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    controller.cashierFooter[index].tr,
                                    style: titleStyle.copyWith(color: white),
                                  ),
                                )),
                                Expanded(
                                    child: Container(
                                  height: Get.height,
                                  alignment: myServices.sharedPreferences
                                              .getString("lang") ==
                                          "en"
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  decoration: BoxDecoration(
                                      color: white,
                                      border: Border.all(color: primaryColor)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Builder(builder: (context) {
                                    String fotterTitle = "";
                                    if (index == 0) {
                                      fotterTitle =
                                          controller.cartItemsCount.toString();
                                    }
                                    if (index == 1) {
                                      controller.cartData.isNotEmpty
                                          ? fotterTitle =
                                              controller.cartData[0].cartOwner!
                                          : fotterTitle = "UNKNOWN";
                                    }
                                    if (index == 2) {
                                      fotterTitle = controller.maxInvoiceNumber
                                          .toString();
                                    }
                                    if (index == 3) {
                                      if (controller.cartData.isEmpty) {
                                        fotterTitle = "0";
                                      } else if (controller
                                              .cartData[0].cartDiscount ==
                                          null) {
                                        fotterTitle = "0";
                                      } else {
                                        fotterTitle = controller
                                            .cartData[0].cartDiscount!
                                            .toString();
                                      }
                                    }
                                    if (index == 4) {
                                      if (controller.cartData.isEmpty) {
                                        fotterTitle = "0";
                                      } else if (controller
                                              .cartData[0].cartTax ==
                                          null) {
                                        fotterTitle = "0";
                                      } else {
                                        fotterTitle =
                                            controller.cartData[0].cartTax!;
                                      }
                                    }
                                    if (index == 5) {
                                      fotterTitle = "Dilkhosh";
                                    }
                                    return Text(
                                      fotterTitle,
                                      style: titleStyle.copyWith(
                                          fontSize: 16, color: primaryColor),
                                    );
                                  }),
                                )),
                              ],
                            ),
                          );
                        }),
                  )),
            ],
          ),
        ),
      );
    });
  }
}
