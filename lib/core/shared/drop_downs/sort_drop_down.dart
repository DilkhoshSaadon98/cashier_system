import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SortDropdown extends StatelessWidget {
  final String selectedValue;
  final List<Map<String, dynamic>> items;
  final ValueChanged<String> onChanged;
  final Color? fieldColor, contentColor;

  const SortDropdown({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    this.contentColor,
    this.fieldColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 50,
      decoration: BoxDecoration(
          color: fieldColor ?? Colors.transparent,
          border: Border.all(color: fieldColor ?? primaryColor, width: 1),
          borderRadius: BorderRadius.circular(constRadius)),
      child: DropdownButton<String>(
        isExpanded: true,
        value: selectedValue,
        style: bodyStyle.copyWith(color: fieldColor),
        icon: Icon(
          Icons.sort,
          color: contentColor ?? primaryColor,
        ),
        underline: Container(),
        dropdownColor: fieldColor,
        focusColor: Colors.transparent,
        items: items
            .map((field) => DropdownMenuItem<String>(
                  value: field['value'] as String,
                  child: Row(
                    children: [
                      Icon(
                        field['icon'] as IconData,
                        size: 18,
                        color: contentColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        field['title'].toString().tr,
                        style: bodyStyle.copyWith(color: contentColor),
                      ),
                    ],
                  ),
                ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
      ),
    );
  }
}
