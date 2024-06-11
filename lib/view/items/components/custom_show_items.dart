import 'package:cashier_system/controller/items/items_view_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/shared/custom_table_header_global.dart';
import 'package:cashier_system/view/items/components/custom_items_rows.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomShowItems extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const CustomShowItems({Key? key});

  @override
  Widget build(BuildContext context) {
    Get.put(ItemsViewController());
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          color: white,
          child: GetBuilder<ItemsViewController>(builder: (controller) {
            return Column(
              children: [
                CustomTableHeaderGlobal(
                  flex: const [1, 2, 3, 1, 2, 2, 2, 1, 2, 2],
                  data: const [
                    "NO",
                    "Barcode",
                    "Items Name",
                    "QTY",
                    "Selling Price",
                    "Buying Price",
                    "Cost Price",
                    "Type",
                    "Categories",
                    "Items Explain",
                  ],
                  onDoubleTap: () {},
                ),
                SizedBox(
                  height: Get.height - 50,
                  child: ListView.builder(
                      itemCount: !controller.isSearch
                          ? controller.data.length
                          : controller.listdataSearch.length,
                      itemBuilder: (context, index) {
                        var dataItem = !controller.isSearch
                            ? controller.data[index]
                            : controller.listdataSearch[index];
                        bool isHovered = controller.hoverStates[index];

                        return CustomItemsTableRows(
                          color: isHovered ? thirdColor : secondColor,
                          dataItem: dataItem,
                        );
                      }),
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}
