import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropDownMenu extends StatelessWidget {
  final String selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final Color? fieldColor;
  final Color? contentColor;

  const DropDownMenu({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    this.fieldColor,
    this.contentColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveContentColor = contentColor ?? primaryColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 50,
      decoration: BoxDecoration(
        color: fieldColor,
        border: Border.all(color: effectiveContentColor, width: 1),
        borderRadius: BorderRadius.circular(constRadius),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedValue,
          icon: Icon(Icons.arrow_drop_down, color: effectiveContentColor),
          dropdownColor: fieldColor ?? Colors.white,
          focusColor: Colors.transparent,
          style: bodyStyle.copyWith(color: effectiveContentColor),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  Icon(Icons.file_copy,
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
