import 'package:cashier_system/controller/items/items_update_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/view/items/widget/custom_update_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemsEditScreenMobile extends StatelessWidget {
  const ItemsEditScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ItemsUpdateController());
    return Scaffold(
      appBar: customAppBarTitle(TextRoutes.editItem, true),
      body: Container(
        width: Get.width,
        height: Get.height,
        color: white,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: GetBuilder<ItemsUpdateController>(
          builder: (controller) {
            return const UpdateItemsWidget();
          },
        ),
      ),
    );
  }
}
