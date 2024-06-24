import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/routes.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/view/cashier/mobile/components/pending_carts_mobile.dart';
import 'package:cashier_system/view/cashier/mobile/components/search_widget_mobile.dart';
import 'package:cashier_system/view/cashier/windows/left_side/components/custom_pending_cart.dart';
import 'package:cashier_system/view/cashier/windows/left_side/components/show_drop_down_items_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CashierScreenMobile extends StatelessWidget {
  const CashierScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CashierController());
    return Scaffold(
      body: GetBuilder<CashierController>(builder: (controller) {
        return SizedBox(
          height: Get.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              PendingCartsMobile(),
              SearchWidgetMobile(),
              Expanded(
                  flex: 4,
                  child: Container(
                    child: DataTable(
                        headingRowColor: WidgetStatePropertyAll(primaryColor),
                        columns: [
                          DataColumn(
                            label: Text(
                              "Item Name",
                              style: titleStyle.copyWith(color: white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Item Price",
                              style: titleStyle.copyWith(color: white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "QTY",
                              style: titleStyle.copyWith(color: white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Total Price",
                              style: titleStyle.copyWith(color: white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Item Code",
                              style: titleStyle.copyWith(color: white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "QTY",
                              style: titleStyle.copyWith(color: white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "QTY",
                              style: titleStyle.copyWith(color: white),
                            ),
                          ),
                        ],
                        rows: []),
                  ))
            ],
          ),
        );
      }),
    );
  }
}
