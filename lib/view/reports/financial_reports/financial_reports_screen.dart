import 'package:cashier_system/controller/reports/financial_reports_controller.dart';
import 'package:cashier_system/core/class/handling_data_view.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/responsive/divide_screen_widget.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/buttons/custom_floating_button.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/drop_downs/drop_down_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FinancialReportsScreen extends StatelessWidget {
  const FinancialReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(FinancialReportsController());
    return Scaffold(
      body: DivideScreenWidget(actionWidget:
          GetBuilder<FinancialReportsController>(builder: (controller) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ListView(
              children: [
                const CustomHeaderScreen(
                  showBackButton: true,
                  imagePath: AppImageAsset.financialReportsIcons,
                  title: TextRoutes.financialReports,
                ),
                verticalGap(),
                DropDownMenu(
                  items: const [
                    TextRoutes.incomeStatement,
                    TextRoutes.ballanceSheet,
                  ],
                  selectedValue: controller.selectedSection,
                  contentColor: primaryColor,
                  fieldColor: white,
                  onChanged: (value) {
                    controller.changeSection(value, controller);
                  },
                ),
                // verticalGap(),
                // CustomTextFieldWidget(
                //     fieldColor: primaryColor,
                //     borderColor: white,
                //     controller: controller.fromDateController,
                //     hinttext: TextRoutes.fromDate,
                //     labeltext: TextRoutes.fromDate,
                //     iconData: Icons.date_range,
                //     onTap: () {
                //       selectDate(context, controller.fromDateController);
                //     },
                //     valid: (value) {
                //       return validInput(value!, 0, 100, '');
                //     },
                //     isNumber: true),
                // verticalGap(5),
                // CustomTextFieldWidget(
                //     fieldColor: primaryColor,
                //     borderColor: white,
                //     controller: controller.toDateController,
                //     hinttext: TextRoutes.toDate,
                //     labeltext: TextRoutes.toDate,
                //     iconData: Icons.date_range,
                //     onTap: () {
                //       selectDate(context, controller.toDateController);
                //     },
                //     valid: (value) {
                //       return validInput(value!, 0, 100, '');
                //     },
                //     isNumber: true),
                // verticalGap(50)
              ],
            ),
            //? Show Footer Buttons:
            // screenActionButtonWidget(
            //   context,
            //   backColor: primaryColor,
            //   onPressedClear: () => controller.clearAllData(),
            //   onPressedPrint: () {},
            //   onPressedSearch: () => controller.onSearchData(true)(),
            // ),
          ],
        );
      }), showWidget:
          GetBuilder<FinancialReportsController>(builder: (controller) {
        return Scaffold(
          appBar: customAppBarTitle(controller.selectedSection),
          floatingActionButton: customFloatingButton(
              controller.showBackToTopButton, controller.scrollControllers),
          body: HandlingDataView(
              statusRequest: controller.statusRequest,
              child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 100),
                  child: Container(
                      width: Get.width,
                      alignment: Alignment.center,
                      child: controller.changeTableWidget(controller)))),
        );
      })),
    );
  }
}
