import 'package:cashier_system/controller/clients_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/date_picker.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_divider.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/custom_text_field_widget.dart';
import 'package:cashier_system/core/shared/drop_downs/sort_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

Widget customerActionWidget(
    ClientsController controller, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      verticalGap(),
      Text(
        TextRoutes.sortBy.tr,
        style: titleStyle.copyWith(color: white),
      ),
      verticalGap(5),
      SortDropdown(
        selectedValue: controller.selectedSortField,
        items: controller.accountSortFields,
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
      CustomTextFieldWidget(
          fieldColor: primaryColor,
          borderColor: white,
          controller: controller.nameController,
          hinttext: TextRoutes.customerName,
          labeltext: TextRoutes.customerName,
          iconData: Icons.person,
          valid: (value) {
            return validInput(value!, 0, 100, '');
          },
          isNumber: false),
      verticalGap(10),
      CustomTextFieldWidget(
          fieldColor: primaryColor,
          borderColor: white,
          controller: controller.phoneController,
          hinttext: TextRoutes.phoneNumber,
          labeltext: TextRoutes.phoneNumber,
          iconData: Icons.person,
          valid: (value) {
            return validInput(value!, 0, 100, '');
          },
          isNumber: true),
      verticalGap(10),
      CustomTextFieldWidget(
          fieldColor: primaryColor,
          borderColor: white,
          controller: controller.addressController,
          hinttext: TextRoutes.address,
          labeltext: TextRoutes.address,
          iconData: Icons.person,
          valid: (value) {
            return validInput(value!, 0, 100, '');
          },
          isNumber: false),
      verticalGap(10),
      Text(
        TextRoutes.userId.tr,
        style: bodyStyle.copyWith(color: white),
      ),
      verticalGap(10),
      CustomTextFieldWidget(
          fieldColor: primaryColor,
          borderColor: white,
          controller: controller.fromNoController,
          hinttext: TextRoutes.fromUserId,
          labeltext: TextRoutes.fromUserId,
          iconData: Icons.numbers,
          valid: (value) {
            return validInput(value!, 0, 100, 'number');
          },
          isNumber: true),
      verticalGap(10),
      CustomTextFieldWidget(
          fieldColor: primaryColor,
          borderColor: white,
          controller: controller.toNoController,
          hinttext: TextRoutes.toUserId,
          labeltext: TextRoutes.toUserId,
          iconData: Icons.numbers,
          valid: (value) {
            return validInput(value!, 0, 100, 'number');
          },
          isNumber: true),
      verticalGap(10),
      Text(
        TextRoutes.date.tr,
        style: bodyStyle.copyWith(color: white),
      ),
      verticalGap(10),
      CustomTextFieldWidget(
          fieldColor: primaryColor,
          borderColor: white,
          controller: controller.fromDateController,
          hinttext: TextRoutes.fromDate,
          labeltext: TextRoutes.fromDate,
          iconData: Icons.date_range,
          readOnly: true,
          onTap: () {
            selectDate(context, controller.fromDateController);
          },
          valid: (value) {
            return validInput(value!, 0, 100, '');
          },
          isNumber: true),
      verticalGap(10),
      CustomTextFieldWidget(
          fieldColor: primaryColor,
          borderColor: white,
          controller: controller.toDateController,
          hinttext: TextRoutes.toDate,
          labeltext: TextRoutes.toDate,
          iconData: Icons.date_range,
          readOnly: true,
          onTap: () {
            selectDate(context, controller.toDateController);
          },
          valid: (value) {
            return validInput(value!, 0, 100, '');
          },
          isNumber: true),
      verticalGap(50)
    ],
  );
}
