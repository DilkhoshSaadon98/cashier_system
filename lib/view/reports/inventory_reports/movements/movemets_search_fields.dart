import 'package:cashier_system/controller/reports/inventory_reports_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/date_picker.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_divider.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/custom_text_field_widget.dart';
import 'package:cashier_system/view/reports/inventory_reports/movements/movements_type_menu.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

Widget movementsSearchFields(
    BuildContext context, InventoryReportsController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      customDivider(white),
      Text(
        TextRoutes.sortBy.tr,
        style: titleStyle.copyWith(color: white),
      ),
      verticalGap(5),
      movementsDropDownMenu((value) {
        controller.changeMovementsSortField(value!);
      }, controller, controller.movementSortFields),
      verticalGap(5),
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
      CustomTextFieldWidget(
          fieldColor: primaryColor,
          borderColor: white,
          controller: controller.itemsNameController,
          hinttext: TextRoutes.itemsName,
          labeltext: TextRoutes.itemsName,
          iconData: Icons.category,
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
      verticalGap(),
      CustomTextFieldWidget(
          fieldColor: primaryColor,
          borderColor: white,
          controller: controller.itemsQtyController,
          hinttext: TextRoutes.availableQTY,
          labeltext: TextRoutes.availableQTY,
          iconData: Icons.numbers,
          valid: (value) {
            return validInput(value!, 0, 100, 'realNumber');
          },
          isNumber: true),
    ],
  );
}
