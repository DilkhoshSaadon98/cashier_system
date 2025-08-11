import 'package:cashier_system/controller/reports/daily_reports_controller.dart';
import 'package:cashier_system/core/class/handling_data_view.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
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
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DailyReportsScreen extends StatelessWidget {
  const DailyReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DailyReportsController());
    return Scaffold(
      body: DivideScreenWidget(actionWidget:
          GetBuilder<DailyReportsController>(builder: (controller) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ListView(
              children: [
                const CustomHeaderScreen(
                  showBackButton: true,
                  imagePath: AppImageAsset.dailyReportsIcons,
                  title: TextRoutes.dailyReports,
                ),
                verticalGap(),
                DropDownMenu(
                  items: const [
                    TextRoutes.generalLedger,
                    TextRoutes.trialBalance,
                    TextRoutes.boxReport,
                    TextRoutes.bankReport,
                    TextRoutes.customerReport,
                    TextRoutes.supplierReport,
                    TextRoutes.withdrawalReport,
                    TextRoutes.retainedEarningsReport,
                    TextRoutes.accountStatement,
                  ],
                  selectedValue: controller.selectedSection,
                  contentColor: primaryColor,
                  fieldColor: white,
                  onChanged: (value) {
                    controller.changeSection(value, controller);
                  },
                ),
                verticalGap(),
                Text(
                  TextRoutes.sortBy.tr,
                  style: titleStyle.copyWith(color: white),
                ),
                verticalGap(5),
                controller.changeActionWidgetWidget(
                  controller,
                ),
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
      }), showWidget: GetBuilder<DailyReportsController>(builder: (controller) {
        return Scaffold(
          appBar: customAppBarTitle(controller.selectedSection),
          floatingActionButton: customFloatingButton(
              controller.showBackToTopButton, controller.scrollControllers),
          body: HandlingDataView(
              statusRequest: controller.statusRequest,
              child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 100),
                  child: controller.changeTableWidget(controller))),
        );
      })),
    );
  }
}
