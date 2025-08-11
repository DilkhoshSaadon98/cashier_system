import 'package:cashier_system/controller/buying/buying_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/screen_routes.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/view/widgets/tables/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddBuyingTable extends StatelessWidget {
  const AddBuyingTable({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(BuyingController());
    return GetBuilder<BuyingController>(builder: (controller) {
      return Scaffold(
          backgroundColor: white,
          appBar: customAppBarTitle(TextRoutes.purchaesItems),
          floatingActionButton: FloatingActionButton.extended(
              shape: const CircleBorder(),
              backgroundColor: primaryColor,
              label: const Icon(
                Icons.add,
                color: secondColor,
              ),
              onPressed: () {
                Get.toNamed(AppRoute.itemsAddScreen);
              }),
          body: Container(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Expanded(
                  child: TableWidget(
                    allSelected: false,
                    flexes: const [1, 1, 2, 1, 2, 2, 2],
                    columns: const [
                      "",
                      TextRoutes.code,
                      TextRoutes.itemsName,
                      TextRoutes.purchaesPrice,
                      TextRoutes.qty,
                      TextRoutes.totalPrice,
                      TextRoutes.totalPriceDiscount
                    ],
                    rows: controller.rows,
                  ),
                ),
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: IconButton(
                    icon: const Icon(Icons.add_circle,
                        size: 30, color: Colors.green),
                    onPressed: () => controller.addNewRow(),
                  ),
                ),
              ],
            ),
          ));
    });
  }
}
