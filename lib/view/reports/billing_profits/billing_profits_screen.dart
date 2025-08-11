import 'package:cashier_system/controller/reports/billing_profits_controller.dart';
import 'package:cashier_system/core/class/handling_data_view.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/functions/date_picker.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/responsive/divide_screen_widget.dart';
import 'package:cashier_system/core/shared/buttons/screen_action_buttons.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/buttons/custom_floating_button.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/custom_text_field_widget.dart';
import 'package:cashier_system/core/shared/drop_downs/sort_drop_down.dart';
import 'package:cashier_system/view/reports/billing_profits/components/billing_profits_table.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class BillingProfitsScreen extends StatelessWidget {
  const BillingProfitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(BillingProfitsController());
    return Scaffold(
      body: DivideScreenWidget(actionWidget:
          GetBuilder<BillingProfitsController>(builder: (controller) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ListView(
              children: [
                const CustomHeaderScreen(
                  showBackButton: true,
                  imagePath: AppImageAsset.billingProfitsIcons,
                  title: TextRoutes.billingProfits,
                ),
                verticalGap(),
                Text(
                  TextRoutes.sortBy.tr,
                  style: titleStyle.copyWith(color: white),
                ),
                verticalGap(5),
                SortDropdown(
                  selectedValue: controller.invoiceSortFileds,
                  items: controller.invoiceSortFields,
                  onChanged: controller.changeInvoicesSortField,
                  contentColor: white,
                  fieldColor: buttonColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      controller.sortAscending
                          ? TextRoutes.sortAsc.tr
                          : TextRoutes.sortDesc.tr,
                      style: bodyStyle.copyWith(color: white),
                    ),
                    IconButton(
                      icon: Icon(
                        controller.sortAscending
                            ? FontAwesomeIcons.arrowDownAZ
                            : FontAwesomeIcons.arrowDownZA,
                        color: white,
                      ),
                      onPressed: controller.toggleSortOrder,
                      tooltip: controller.sortAscending
                          ? TextRoutes.sortAsc.tr
                          : TextRoutes.sortDesc.tr,
                    ),
                  ],
                ),
                Text(
                  TextRoutes.searchBy.tr,
                  style: titleStyle.copyWith(color: white),
                ),
                verticalGap(5),
                CustomTextFieldWidget(
                    fieldColor: primaryColor,
                    borderColor: white,
                    controller: controller.accountNameController,
                    hinttext: TextRoutes.customerName,
                    labeltext: TextRoutes.customerName,
                    iconData: Icons.person,
                    valid: (value) {
                      return validInput(value!, 0, 100, '');
                    },
                    isNumber: false),
                verticalGap(),
                CustomTextFieldWidget(
                    fieldColor: primaryColor,
                    borderColor: white,
                    controller: controller.fromNoController,
                    hinttext: TextRoutes.fromInvoiceNumber,
                    labeltext: TextRoutes.fromInvoiceNumber,
                    iconData: Icons.numbers,
                    valid: (value) {
                      return validInput(value!, 0, 100, 'number');
                    },
                    isNumber: true),
                verticalGap(5),
                CustomTextFieldWidget(
                    fieldColor: primaryColor,
                    borderColor: white,
                    controller: controller.toNoController,
                    hinttext: TextRoutes.toInvoiceNumber,
                    labeltext: TextRoutes.toInvoiceNumber,
                    iconData: Icons.numbers,
                    valid: (value) {
                      return validInput(value!, 0, 100, 'number');
                    },
                    isNumber: true),
                verticalGap(),
                CustomTextFieldWidget(
                    fieldColor: primaryColor,
                    borderColor: white,
                    controller: controller.fromDateController,
                    hinttext: TextRoutes.fromDate,
                    labeltext: TextRoutes.fromDate,
                    iconData: Icons.date_range,
                    onTap: () {
                      selectDate(context, controller.fromDateController);
                    },
                    valid: (value) {
                      return validInput(value!, 0, 100, '');
                    },
                    isNumber: true),
                verticalGap(5),
                CustomTextFieldWidget(
                    fieldColor: primaryColor,
                    borderColor: white,
                    controller: controller.toDateController,
                    hinttext: TextRoutes.toDate,
                    labeltext: TextRoutes.toDate,
                    iconData: Icons.date_range,
                    onTap: () {
                      selectDate(context, controller.toDateController);
                    },
                    valid: (value) {
                      return validInput(value!, 0, 100, '');
                    },
                    isNumber: true),
                verticalGap(50)
              ],
            ),
            //? Show Footer Buttons:
            screenActionButtonWidget(
              context,
              backColor: primaryColor,
              onPressedClear: () => controller.clearAllData(),
              onPressedPrint: () {},
              onPressedSearch: () =>
                  controller.fetchInvoicesReportData(isRefresh: true),
            ),
          ],
        );
      }), showWidget:
          GetBuilder<BillingProfitsController>(builder: (controller) {
        return Scaffold(
            appBar: customAppBarTitle(TextRoutes.billingProfits),
            floatingActionButton: customFloatingButton(
                controller.showBackToTopButton, controller.scrollControllers),
            body: HandlingDataView(
                statusRequest: controller.statusRequest,
                child: BillingProfitsTable(
                  controller: controller,
                )));
      })),
    );
  }
}
