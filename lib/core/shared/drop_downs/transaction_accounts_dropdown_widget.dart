import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class CustomDropdownSearchWidget<T> extends StatelessWidget {
  final String label;
  final IconData iconData;
  final List<T> items;
  final T? selectedItem;
  final void Function(T?) onChanged;
  final String Function(T)? itemToString;
  final Color? borderColor;
  final Color? fieldColor;
  String? Function(T?)? validator;

  CustomDropdownSearchWidget({
    super.key,
    required this.label,
    required this.iconData,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    this.itemToString,
    this.borderColor,
    this.fieldColor,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      items: items,
      selectedItem: selectedItem,
      itemAsString: (item) => itemToString?.call(item) ?? item.toString(),
      onChanged: onChanged,
      dropdownDecoratorProps: DropDownDecoratorProps(
        baseStyle: bodyStyle.copyWith(color: borderColor ?? primaryColor),
        dropdownSearchDecoration: InputDecoration(
          filled: true,
          fillColor: fieldColor,
          labelText: label.tr,
          labelStyle: bodyStyle.copyWith(color: borderColor ?? primaryColor),
          prefixIcon: Icon(
            iconData,
            color: borderColor,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: secondColor, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(constRadius))),
          errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: primaryColor, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(constRadius))),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: secondColor, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(constRadius))),
          enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: borderColor ?? primaryColor, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(constRadius))),
        ),
      ),
      validator: validator,
      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          autocorrect: true,
          style: bodyStyle.copyWith(color: primaryColor),
          decoration: InputDecoration(
            focusColor: Colors.teal,
            hintText: TextRoutes.search.tr,
            labelStyle: bodyStyle.copyWith(color: fieldColor ?? primaryColor),
            hintStyle: bodyStyle.copyWith(color: primaryColor),
          ),
        ),
        containerBuilder: (context, popupWidget) {
          return Container(
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(constRadius),
            ),
            padding: const EdgeInsets.all(8),
            child: popupWidget,
          );
        },
        emptyBuilder: (context, searchEntry) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: primaryColor, size: 40),
                const SizedBox(height: 10),
                Text(
                  TextRoutes.noDataFound.tr,
                  style: titleStyle,
                ),
              ],
            ),
          );
        },
        searchDelay: const Duration(microseconds: 100),
        itemBuilder: (context, item, isSelected) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(constRadius),
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.account_circle, color: primaryColor),
                horizontalGap(),
                Expanded(
                  child: Text(
                    itemToString?.call(item) ?? item.toString(),
                    style: bodyStyle.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
