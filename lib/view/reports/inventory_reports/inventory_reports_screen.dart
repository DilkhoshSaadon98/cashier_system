import 'package:cashier_system/controller/reports/inventory_reports_controller.dart';
import 'package:cashier_system/core/class/handling_data_view.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/responsive/divide_screen_widget.dart';
import 'package:cashier_system/core/shared/buttons/screen_action_buttons.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/buttons/custom_floating_button.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/drop_downs/drop_down_menu.dart';
import 'package:cashier_system/view/reports/inventory_reports/movements/movemets_search_fields.dart';
import 'package:cashier_system/view/reports/inventory_reports/summary/summary_search_fields.dart';
import 'package:cashier_system/view/reports/inventory_reports/valuation/valuation_search_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InventoryReportsScreen extends StatelessWidget {
  const InventoryReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(InventoryReportsController());
    return Scaffold(
      body: DivideScreenWidget(actionWidget:
          GetBuilder<InventoryReportsController>(builder: (controller) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ListView(
              children: [
                const CustomHeaderScreen(
                  showBackButton: true,
                  imagePath: AppImageAsset.inventorReportsIcons,
                  title: TextRoutes.inventorReports,
                ),
                verticalGap(),
                //? Inventory Section Changes:
                DropDownMenu(
                  items: const [
                    TextRoutes.inventorySummary,
                    TextRoutes.inventoryMovement,
                    TextRoutes.inventoryValuation,
                  ],
                  selectedValue: controller.selectedSection,
                  contentColor: primaryColor,
                  fieldColor: white,
                  onChanged: (value) {
                    controller.changeSection(value, controller);
                  },
                ),
                verticalGap(),

                controller.selectedSection == TextRoutes.inventorySummary
                    ? summarySearchFields(context, controller)
                    : controller.selectedSection == TextRoutes.inventoryMovement
                        ? movementsSearchFields(context, controller)
                        : valuationSearchFields(context, controller),
                verticalGap(50)
              ],
            ),
            //? Show Footer Buttons:
            screenActionButtonWidget(
              context,
              backColor: primaryColor,
              onPressedClear: () {
                controller.clearAllData();
              },
              onPressedPrint: () {},
              onPressedSearch: () {
                controller.onSearchData(true)();
              },
            ),
          ],
        );
      }), showWidget:
          GetBuilder<InventoryReportsController>(builder: (controller) {
        return Scaffold(
            appBar: customAppBarTitle(controller.selectedSection),
            floatingActionButton: customFloatingButton(
                controller.showBackToTopButton, controller.scrollControllers),
            body: HandlingDataView(
                statusRequest: controller.statusRequest,
                child: controller.changeTableWidget(controller)));
      })),
    );
  }
}
