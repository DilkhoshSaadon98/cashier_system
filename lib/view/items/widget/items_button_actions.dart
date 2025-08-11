import 'package:cashier_system/controller/items/items_view_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/screen_routes.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget itemsActionButtonsWidget(
    ItemsViewController controller, BuildContext context, Color backColor) {
  return Container(
    color: backColor,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircleAvatar(
            backgroundColor: buttonColor,
            child: IconButton(
                tooltip: TextRoutes.searchItems.tr,
                onPressed: () {
                  controller.onSearchItems();
                },
                icon: const Icon(
                  Icons.search,
                  color: white,
                ))),
        const SizedBox(
          width: 15,
        ),
        CircleAvatar(
            backgroundColor: Colors.blue,
            child: GestureDetector(
              onLongPress: () {
                Get.toNamed(AppRoute.invoiceScreen);
              },
              child: IconButton(
                  tooltip:
                      '${TextRoutes.print.tr}\n${TextRoutes.longPressToUpdateSettings.tr}',
                  onPressed: () {
                    controller.printData();
                  },
                  icon: const Icon(
                    Icons.print,
                    color: white,
                  )),
            )),
        const SizedBox(
          width: 15,
        ),
        CircleAvatar(
            backgroundColor: secondColor,
            child: IconButton(
                onPressed: () {
                  controller.clearFileds();
                },
                tooltip: TextRoutes.clearFileds.tr,
                icon: const Icon(
                  Icons.refresh_outlined,
                  color: white,
                ))),
        const SizedBox(
          width: 15,
        ),
        CircleAvatar(
            backgroundColor: Colors.green,
            child: IconButton(
                onPressed: () {
                  controller.changeLayout();
                },
                tooltip: TextRoutes.changeLayoutOfScreen.tr,
                icon: Icon(
                  controller.layoutDisplay
                      ? Icons.grid_on_rounded
                      : Icons.table_rows,
                  color: white,
                ))),
      ],
    ),
  );
}
