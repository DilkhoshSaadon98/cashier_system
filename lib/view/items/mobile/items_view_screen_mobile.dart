import 'package:cashier_system/controller/items/items_view_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/view/items/widget/custom_show_items.dart';
import 'package:cashier_system/view/items/widget/mobile_action_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ItemsViewScreenMobile extends StatelessWidget {
  const ItemsViewScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ItemsViewController());
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
            const Expanded(
              child: TabBarView(
                children: [
                  ItemsListView(),
                  CustomShowItems(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemsListView extends StatelessWidget {
  const ItemsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileScreenBackgroundColor,
      body: GetBuilder<ItemsViewController>(
        builder: (controller) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: const MobileActionWidget(),
          );
        },
      ),
    );
  }
}
