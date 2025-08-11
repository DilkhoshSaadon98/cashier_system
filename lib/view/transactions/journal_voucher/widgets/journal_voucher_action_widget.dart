import 'package:cashier_system/core/shared/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:cashier_system/controller/transactions/journal_voucher_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/dialogs/show_form_dialog.dart';
import 'package:cashier_system/core/functions/date_picker.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/buttons/screen_action_buttons.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/custom_text_field_widget.dart';
import 'package:cashier_system/core/shared/drop_downs/sort_drop_down.dart';
import 'package:cashier_system/view/transactions/journal_voucher/widgets/journal_voucher_add_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class JournalVoucherActionWidget extends StatelessWidget {
  final bool isMobile;
  const JournalVoucherActionWidget({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    Color backColor = isMobile ? white : primaryColor;
    Color textColor = isMobile ? primaryColor : white;
    Get.put(JournalVoucherController());
    return Container(
      color: backColor,
      child: GetBuilder<JournalVoucherController>(builder: (controller) {
        return FocusTraversalGroup(
          policy: WidgetOrderTraversalPolicy(),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ListView(
                children: [
                  if (!isMobile) ...[
                    const CustomHeaderScreen(
                      showBackButton: true,
                      title: TextRoutes.journalVoucher,
                      imagePath: AppImageAsset.journalVoucherIcons,
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
                  verticalGap(5),
                  CustomTextFieldWidget(
                    hinttext: TextRoutes.voucherNumber,
                    iconData: Icons.numbers,
                    labeltext: TextRoutes.voucherNumber,
                    isNumber: false,
                    fieldColor: backColor,
                    borderColor: textColor,
                    controller: controller.voucherNumber,
                    valid: (value) {
                      return validInput(value!, 0, 100, "");
                    },
                  ),
                  verticalGap(),
                  Text(
                    TextRoutes.invoiceNumber.tr,
                    style: titleStyle.copyWith(color: white),
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
                    style: titleStyle.copyWith(color: white, fontSize: 16),
                  ),
                  verticalGap(5),
                  CustomTextFieldWidget(
                    hinttext: TextRoutes.fromDate,
                    iconData: Icons.date_range,
                    labeltext: TextRoutes.fromDate,
                    isNumber: true,
                    controller: controller.dateFromController,
                    onTap: () {
                      selectDate(context, controller.dateFromController);
                    },
                    fieldColor: backColor,
                    borderColor: textColor,
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
                    isNumber: true,
                    controller: controller.dateToController,
                    valid: (value) {
                      return validInput(value!, 0, 100, "");
                    },
                  ),
                  verticalGap(),
                  // customButtonGlobal(() {
                  //   controller.fetchVoucherData(isInitialSearch: true);
                  // }, TextRoutes.search, Icons.search, buttonColor, white),
                ],
              ),
              screenActionButtonWidget(
                context,
                backColor: backColor,
                onPressedSearch: () {
                  controller.fetchVoucherData(isInitialSearch: true);
                },
                onPressedAdd: () {
                  showFormDialog(context,
                      isUpdate: false,
                      addText: TextRoutes.addAccount,
                      editText: TextRoutes.editAccount,
                      child: const JournalVoucherAddDialog(
                          // isUpdate: false,
                          // isReceipt: false,
                          ));
                },
                onPressedPrint: () {},
                onPressedRemove: () {},
                onPressedClear: () {
                  controller.clearSearchFields();
                },
              )
            ],
          ),
        );
      }),
    );
  }
}
