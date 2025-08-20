import 'package:cashier_system/controller/items/items_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/view/items/widget/custom_show_items.dart';
import 'package:cashier_system/view/items/widget/items_action_section_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemsViewScreenMobile extends StatelessWidget {
  const ItemsViewScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ItemsViewController());
    return Scaffold(
      appBar: customAppBarTitle(TextRoutes.viewItems, true),
      backgroundColor: mobileScreenBackgroundColor,
      body: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Column(
          children: [
            Container(
              color: buttonColor,
              child: TabBar(
                  dividerColor: primaryColor,
                  dividerHeight: 1,
                  unselectedLabelColor: white,
                  indicatorColor: secondColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  automaticIndicatorColorAdjustment: true,
                  dragStartBehavior: DragStartBehavior.start,
                  labelColor: secondColor,
                  tabs: [
                    Tab(
                        child: Text(TextRoutes.search.tr,
                            style: titleStyle.copyWith(color: white))),
                    Tab(
                      child: Text(TextRoutes.view.tr,
                          style: titleStyle.copyWith(color: white)),
                    ),
                  ]),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: ItemsActionSectionWidget(
                      controller: controller,
                      isMobile: true,
                    ),
                  ),
                  const CustomShowItems(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
