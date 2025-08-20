import 'package:cashier_system/controller/items/items_controller.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/responsive/divide_screen_widget.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/view/items/widget/custom_show_items.dart';
import 'package:cashier_system/view/items/widget/items_action_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemsViewScreenWindows extends StatelessWidget {
  const ItemsViewScreenWindows({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ItemsViewController());
    return Scaffold(
      body: GetBuilder<ItemsViewController>(builder: (controller) {
        return DivideScreenWidget(
          showWidget: Scaffold(
              appBar: customAppBarTitle(TextRoutes.items),
              body: const CustomShowItems()),
          actionWidget: ItemsActionSectionWidget(
            controller: controller,
            isMobile: false,
          ),
        );
      }),
    );
  }
}
