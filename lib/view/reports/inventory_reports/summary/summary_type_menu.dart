import 'package:cashier_system/controller/reports/inventory_reports_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/shared/drop_downs/sort_drop_down.dart';
import 'package:flutter/material.dart';

Widget summaryDropDownMenu(void Function(String?) onChanged,
    InventoryReportsController controller, String selectedValue) {
  return SortDropdown(
      contentColor: buttonColor,
      fieldColor: white,
      selectedValue: selectedValue,
      items: controller.inventorySummaryFields,
      onChanged: onChanged);
}
