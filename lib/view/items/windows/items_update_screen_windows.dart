import 'package:cashier_system/controller/items/items_update_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/responsive/divide_screen_widget.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/view/items/widget/custom_update_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemsUpdateScreenWindows extends StatelessWidget {
  const ItemsUpdateScreenWindows({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ItemsUpdateController());
    return Scaffold(
      backgroundColor: primaryColor,
      body: GetBuilder<ItemsUpdateController>(builder: (controller) {
        return DivideScreenWidget(
          showWidget: Scaffold(
            backgroundColor: white,
            appBar: customAppBarTitle(TextRoutes.editItem),
            body: SizedBox(width: Get.width, child: const UpdateItemsWidget()),
          ),
          actionWidget: const Column(
            children: [
              CustomHeaderScreen(
                showBackButton: true,
                imagePath: AppImageAsset.itemsIcons,
                title: TextRoutes.items,
              ),
            ],
          ),
        );
      }),
    );
  }
}
