import 'package:cashier_system/controller/reports/inventory_reports_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/shared/drop_downs/sort_drop_down.dart';
import 'package:flutter/material.dart';

Widget movementsDropDownMenu(void Function(String?) onChanged,
    InventoryReportsController controller, String selectedValue) {
  return SortDropdown(
      contentColor: white,
      fieldColor: buttonColor,
      selectedValue: selectedValue,
      items: controller.movementsSortFields,
      onChanged: onChanged);
}
