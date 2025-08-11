import 'package:cashier_system/controller/transactions/transaction_payment_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/dialogs/delete_dialog.dart';
import 'package:cashier_system/core/dialogs/show_form_dialog.dart';
import 'package:cashier_system/core/dialogs/snackbar_helper.dart';
import 'package:cashier_system/core/functions/date_picker.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/buttons/screen_action_buttons.dart';
import 'package:cashier_system/core/shared/custom_divider.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/custom_text_field_widget.dart';
import 'package:cashier_system/core/shared/drop_downs/sort_drop_down.dart';
import 'package:cashier_system/data/model/account_model.dart';
import 'package:cashier_system/view/transactions/components/transaction_accounts_dropdown_widget.dart';
import 'package:cashier_system/view/transactions/payment/widgets/transaction_payment_dialog_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class TransactionPaymentActionWidget extends StatelessWidget {
  final bool isMobile;
  const TransactionPaymentActionWidget({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    Color backColor = isMobile ? white : primaryColor;
    Color textColor = isMobile ? primaryColor : white;
    Get.put(TransactionPaymentController());
    return Container(
      color: backColor,
      child: GetBuilder<TransactionPaymentController>(builder: (controller) {
        return FocusTraversalGroup(
          policy: WidgetOrderTraversalPolicy(),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ListView(
                children: [
                  //! Header Side
                  if (!isMobile) ...[
                    CustomHeaderScreen(
                      title: TextRoutes.receipts.tr,
                      showBackButton: true,
                      imagePath: AppImageAsset.importIcons,
                    ),
                    verticalGap(),
                  ],
                  Text(
                    TextRoutes.sortBy.tr,
                    style: titleStyle.copyWith(color: textColor),
                  ),
                  verticalGap(5),
                  SortDropdown(
                    selectedValue: controller.selectedSortField,
                    items: controller.sortFields,
                    onChanged: controller.changeSortField,
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
                        style: bodyStyle.copyWith(color: textColor),
                      ),
                      IconButton(
                        icon: Icon(
                          controller.sortAscending
                              ? FontAwesomeIcons.arrowDownAZ
                              : FontAwesomeIcons.arrowDownZA,
                          color: textColor,
                        ),
                        onPressed: controller.toggleSortOrder,
                        tooltip: controller.sortAscending
                            ? TextRoutes.sortAsc.tr
                            : TextRoutes.sortDesc.tr,
                      ),
                    ],
                  ),
                  customDivider(textColor),
                  Text(
                    TextRoutes.searchBy.tr,
                    style: titleStyle.copyWith(color: textColor),
                  ),
                  verticalGap(10),
                  CustomTextFieldWidget(
                    hinttext: TextRoutes.transactionNumber,
                    iconData: Icons.numbers,
                    labeltext: TextRoutes.transactionNumber,
                    isNumber: false,
                    fieldColor: backColor,
                    borderColor: textColor,
                    controller: controller.transactionNumber,
                    valid: (value) {
                      return validInput(value!, 0, 100, "");
                    },
                  ),
                  verticalGap(10),
                  TransactionAccountsDropdownWidget<AccountModel>(
                    iconData: Icons.account_balance,
                    items: controller.dropDownListSourceAccounts,
                    label: TextRoutes.sourceAccount,
                    onChanged: (value) {
                      if (value != null) {
                        controller.searchSelectedSourceAccount = value;
                        controller.searchSelectedSourceAccountId =
                            value.accountId;
                        controller.update();
                      }
                    },
                    selectedItem: controller.searchSelectedSourceAccount,
                    fieldColor: backColor,
                    borderColor: textColor,
                    itemToString: (p0) {
                      return p0.accountName!;
                    },
                  ),
                  verticalGap(10),
                  TransactionAccountsDropdownWidget<AccountModel>(
                    iconData: Icons.account_balance,
                    items: controller.dropDownListTargetAccounts,
                    label: TextRoutes.targetAccount,
                    onChanged: (value) {
                      if (value != null) {
                        controller.searchSelectedTargetAccount = value;
                        controller.searchSelectedTargetAccountId =
                            value.accountId;
                        controller.update();
                      }
                    },
                    selectedItem: controller.searchSelectedTargetAccount,
                    fieldColor: backColor,
                    borderColor: textColor,
                    itemToString: (p0) {
                      return p0.accountName!;
                    },
                  ),
                  verticalGap(),

                  Text(
                    TextRoutes.invoiceNumber.tr,
                    style: titleStyle.copyWith(color: textColor),
                  ),
                  verticalGap(5),
                  CustomTextFieldWidget(
                    hinttext: TextRoutes.fromInvoiceNumber,
                    iconData: Icons.numbers,
                    labeltext: TextRoutes.fromInvoiceNumber,
                    isNumber: true,
                    fieldColor: backColor,
                    borderColor: textColor,
                    controller: controller.noFromController,
                    valid: (value) {
                      return validInput(value!, 0, 100, "number");
                    },
                  ),
                  verticalGap(5),
                  CustomTextFieldWidget(
                    hinttext: TextRoutes.toInvoiceNumber,
                    iconData: Icons.numbers,
                    labeltext: TextRoutes.toInvoiceNumber,
                    isNumber: true,
                    controller: controller.noToController,
                    fieldColor: backColor,
                    borderColor: textColor,
                    valid: (value) {
                      return validInput(value!, 0, 100, "number");
                    },
                  ),
                  verticalGap(),
                  Text(
                    TextRoutes.date.tr,
                    style: titleStyle.copyWith(color: textColor, fontSize: 16),
                  ),
                  verticalGap(5),
                  CustomTextFieldWidget(
                    hinttext: TextRoutes.fromDate,
                    iconData: Icons.date_range,
                    labeltext: TextRoutes.fromDate,
                    isNumber: false,
                    controller: controller.dateFromController,
                    onTap: () {
                      selectDate(context, controller.dateFromController);
                    },
                    fieldColor: backColor,
                    borderColor: textColor,
                    readOnly: true,
                    valid: (value) {
                      return validInput(value!, 0, 100, "");
                    },
                  ),
                  verticalGap(5),
                  CustomTextFieldWidget(
                    hinttext: TextRoutes.toDate,
                    iconData: Icons.date_range,
                    onTap: () {
                      selectDate(context, controller.dateToController);
                    },
                    fieldColor: backColor,
                    borderColor: textColor,
                    labeltext: TextRoutes.toDate,
                    isNumber: false,
                    readOnly: true,
                    controller: controller.dateToController,
                    valid: (value) {
                      return validInput(value!, 0, 100, "");
                    },
                  ),

                  verticalGap(60),
                  // customButtonGlobal(() {
                  //   controller.getReceiptTransactionData(
                  //       isInitialSearch: true);
                  // }, TextRoutes.search, Icons.search, buttonColor, white),
                ],
              ),
              screenActionButtonWidget(
                context,
                backColor: backColor,
                onPressedSearch: () {
                  controller.getPaymentTransactionData(isInitialSearch: true);
                },
                onPressedAdd: () {
                  showFormDialog(context,
                      isUpdate: false,
                      addText: TextRoutes.addTransaction,
                      editText: TextRoutes.editTransaction,
                      child: const TransactionPaymentDialogFormWidget(
                        isUpdate: false,
                        isReceipt: true,
                      ));
                },
                onPressedClear: () {
                  controller.clearSearchFileds();
                },
                onPressedPrint: () {},
                onPressedRemove: () {
                  if (controller.selectedRows.isNotEmpty) {
                    showDeleteDialog(
                        context: context,
                        title: "",
                        content: "",
                        onPressed: () async {
                          await controller.removeReceiptTransactionDatas(
                              controller.selectedRows);
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                        });
                  } else {
                    showErrorSnackBar(TextRoutes.selectOneRowAtLeast);
                  }
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
