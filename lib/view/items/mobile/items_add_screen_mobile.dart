import 'package:cashier_system/controller/items/items_add_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/view/items/widget/custom_add_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddItemsScreenMobile extends StatelessWidget {
  const AddItemsScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AddItemsController());
    return Scaffold(
      appBar: customAppBarTitle(TextRoutes.addItems, true),
      body: Container(
        width: Get.width,
        height: Get.height,
        color: white,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: GetBuilder<AddItemsController>(
          builder: (controller) {
            return const AddItems();
          },
        ),
      ),
    );
  }
}
