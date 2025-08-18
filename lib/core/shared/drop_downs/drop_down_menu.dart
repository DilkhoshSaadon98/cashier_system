// ignore_for_file: deprecated_member_use

import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class DropDownMenu extends StatelessWidget {
  final String selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final Color? fieldColor;
  final Color? contentColor;
  bool? showBorder;

  DropDownMenu({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    this.fieldColor,
    this.contentColor,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveContentColor = contentColor ?? primaryColor;
    String effectiveSelectedValue = selectedValue;

    if (!items.contains(selectedValue) && items.isNotEmpty) {
      effectiveSelectedValue = items[0];
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 50,
      decoration: BoxDecoration(
        color: fieldColor,
        border: showBorder!
            ? Border.all(color: effectiveContentColor, width: 1)
            : null,
        borderRadius: BorderRadius.circular(constRadius),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: effectiveSelectedValue,
          icon: Icon(Icons.arrow_drop_down, color: effectiveContentColor),
          dropdownColor: !showBorder! ? white : fieldColor ?? Colors.white,
          focusColor: Colors.transparent,
          style: bodyStyle.copyWith(color: effectiveContentColor),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  Icon(Icons.type_specimen_sharp,
                      size: 18, color: effectiveContentColor.withOpacity(0.7)),
                  const SizedBox(width: 8),
                  Text(
                    item.tr,
                    style: bodyStyle.copyWith(color: effectiveContentColor),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
