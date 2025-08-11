import 'package:cashier_system/controller/items/items_add_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/responsive/divide_screen_widget.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/view/items/widget/custom_add_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemsAddScreenWindows extends StatelessWidget {
  const ItemsAddScreenWindows({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AddItemsController());
    return Scaffold(
      backgroundColor: primaryColor,
      body: GetBuilder<AddItemsController>(builder: (controller) {
        return DivideScreenWidget(
          showWidget: Scaffold(
            appBar: customAppBarTitle(TextRoutes.addItems),
            body: Container(
              alignment: Alignment.center,
              width: Get.width,
              color: white,
              child: Container(
                  alignment: Alignment.center,
                  width: Get.width,
                  child: const AddItems()),
            ),
          ),
          actionWidget: Column(
            children: [
              const CustomHeaderScreen(
                imagePath: AppImageAsset.itemsIcons,
                showBackButton: true,
                title: TextRoutes.items,
              ),
              verticalGap(5),
              CheckboxListTile(
                  title: Text(
                    TextRoutes.autoFill.tr,
                    style: titleStyle.copyWith(color: white),
                  ),
                  activeColor: white,
                  checkColor: primaryColor,
                  value: controller.autoFill,
                  fillColor: const WidgetStatePropertyAll(white),
                  onChanged: (value) {
                    controller.autoFillItems(value!);
                  }),
              CheckboxListTile(
                  title: Text(
                    TextRoutes.autoPrint.tr,
                    style: titleStyle.copyWith(color: white),
                  ),
                  activeColor: white,
                  fillColor: const WidgetStatePropertyAll(white),
                  checkColor: primaryColor,
                  value: controller.autoPrintBarcode,
                  onChanged: (value) {
                    controller.autoPrintBarcodeFunction(value!);
                  }),
            ],
          ),
        );
      }),
    );
  }
}
