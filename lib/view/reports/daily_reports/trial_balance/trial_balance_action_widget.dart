import 'package:cashier_system/controller/reports/daily_reports_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_divider.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/custom_text_field_widget.dart';
import 'package:cashier_system/core/shared/drop_downs/sort_drop_down.dart';
import 'package:cashier_system/data/model/account_model.dart';
import 'package:cashier_system/core/shared/drop_downs/transaction_accounts_dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class TrialBalanceActionWidget extends StatelessWidget {
  final DailyReportsController controller;
  const TrialBalanceActionWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SortDropdown(
          selectedValue: controller.selectedSortField,
          items: controller.sortTrialBalanceFields,
          onChanged: controller.changeSortField,
          contentColor: primaryColor,
          fieldColor: white,
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
        customDivider(white),
        Text(
          TextRoutes.searchBy.tr,
          style: titleStyle.copyWith(color: white),
        ),
        verticalGap(5),
        verticalGap(),
        CustomDropdownSearchWidget<AccountModel>(
          iconData: Icons.account_balance,
          items: controller.dropDownListSourceAccounts,
          label: TextRoutes.sourceAccount,
          onChanged: (value) {
            if (value != null) {
              controller.selectedSourceAccount = value;
              controller.selectedSourceAccountId = value.accountId;
              controller.update();
            }
          },
          selectedItem: controller.selectedSourceAccount,
          fieldColor: primaryColor,
          borderColor: white,
          itemToString: (p0) {
            return p0.accountName!;
          },
        ),
        verticalGap(),
        Text(
          TextRoutes.invoiceNumber.tr,
          style: bodyStyle.copyWith(color: white),
        ),
        verticalGap(5),
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
      ],
    );
  }
}
