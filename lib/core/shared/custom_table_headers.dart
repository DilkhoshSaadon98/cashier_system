import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

List<DataColumn> customTableHeaders(List<String> labels) {
  return labels.map((label) {
    return DataColumn(
      label: Text(
        label.tr,
        textAlign: TextAlign.center,
        style: titleStyle.copyWith(color: white, fontSize: 14),
      ),
      headingRowAlignment: MainAxisAlignment.center,
    );
  }).toList();
}
