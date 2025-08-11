import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/dialogs/snackbar_helper.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/buttons/custom_buttton_global.dart';
import 'package:cashier_system/view/cashier/windows/view/components/cashier_table_rows.dart';
import 'package:cashier_system/view/cashier/windows/view/components/custom_grid_data_view.dart';
import 'package:cashier_system/view/cashier/windows/view/components/custom_pending_cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CashierViewSectionScreen extends StatelessWidget {
  const CashierViewSectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CashierController());

    return SafeArea(
      child: Column(
        children: [
          //! Search box and pending cart
          SizedBox(
            height: 70.h,
            child: GetBuilder<CashierController>(
              builder: (controller) {
                return Row(
                  children: [
                    const CustomPendingCarts(),
                    customButtonGlobal(() {
                      String? cartNumber = myServices.systemSharedPreferences
                          .getString("cart_number");
                      if (cartNumber == null) {
                        showErrorSnackBar(TextRoutes.emptyCart);
                        return;
                      }
                      controller.goToItemsScreen();
                    }, TextRoutes.viewItems, Icons.search, white, primaryColor,
                        200, 50),
                    const SizedBox(
                      width: 5,
                    )
                  ],
                );
              },
            ),
          ),

          //! Data Showing Section
          Expanded(
            child: GetBuilder<CashierController>(
              builder: (controller) {
                return Row(
                  children: [
                    if (controller.showGridData && Get.width > 900)
                      const CustomGridDataView(),
                    Expanded(
                      flex: controller.gridExpand,
                      child: const CashierTableRows(),
                    ),
                  ],
                );
              },
            ),
          ),

          // ?Footer section with summarized information
          Container(
            height: 80.h,
            alignment: Alignment.topCenter,
            child: GetBuilder<CashierController>(
              builder: (controller) {
                Widget buildFooterItem(String title, String value) {
                  return Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: white,
                      border: Border.all(color: white),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: double.infinity,
                            alignment:
                                Directionality.of(context) == TextDirection.ltr
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                            color: primaryColor,
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Text(
                              title,
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              style: bodyStyle.copyWith(
                                color: white,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: double.infinity,
                            alignment:
                                Directionality.of(context) == TextDirection.ltr
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                            decoration: BoxDecoration(
                              color: white,
                              border: Border.all(color: primaryColor),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Text(
                              value.tr,
                              style: bodyStyle.copyWith(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                String getFooterValue(int index) {
                  switch (index) {
                    case 0:
                      return controller.cartItemsCount.toString();
                    case 1:
                      return controller.cartData.isNotEmpty &&
                              controller.cartData[0].usersName != null
                          ? controller.cartData[0].usersName!.tr
                          : TextRoutes.cashAgent.tr;
                    case 2:
                      return controller.maxInvoiceNumber.toString();
                    case 3:
                      return formattingNumbers(controller.cartData.isEmpty
                          ? 0.0
                          : (controller.cartData[0].cartDiscount));
                    case 4:
                      return formattingNumbers(controller.cartData.isEmpty
                          ? 0.0
                          : (controller.cartData[0].cartTax));
                    case 5:
                      return myServices.sharedPreferences
                              .getString("admins_name") ??
                          TextRoutes.noData.tr;
                    default:
                      return "";
                  }
                }

                Widget buildColumn(int startIndex, int columnCount) {
                  return Expanded(
                    child: Column(
                      children: List.generate(
                        columnCount,
                        (index) => GestureDetector(
                          onDoubleTap: controller.footerData[startIndex + index]
                              ['on_tap'],
                          child: buildFooterItem(
                            controller.footerData[startIndex + index]['title']
                                .toString()
                                .tr,
                            getFooterValue(startIndex + index).tr,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                int totalItems = controller.footerData.length;
                int itemsPerColumn = (totalItems / 3).ceil();
                int itemsInLastColumn = totalItems - 2 * itemsPerColumn;

                return Row(
                  children: [
                    buildColumn(0, itemsPerColumn),
                    buildColumn(itemsPerColumn, itemsPerColumn),
                    buildColumn(2 * itemsPerColumn, itemsInLastColumn),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
