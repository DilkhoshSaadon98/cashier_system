import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/data/model/account_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';

class DropDownAccountsSearch extends StatelessWidget {
  final String label;
  final bool isSource;
  final IconData iconData;
  final Color? borderColor;
  final Color? fieldColor;
  final AccountModel? selectedAccount;
  final List<AccountModel> items;
final   void Function(dynamic)? onChanged;

  const DropDownAccountsSearch({
    super.key,
    required this.label,
    required this.selectedAccount,
    this.isSource = true,
    required this.iconData,
    this.borderColor,
    this.fieldColor,
    required this.items, this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<AccountModel>(
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
      items: items,
      selectedItem: selectedAccount,
      itemAsString: (account) {
        return "${account.accountName!.tr} (${account.accountType!.tr})";
      },
      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          autocorrect: true,
          style: bodyStyle.copyWith(color: fieldColor),
          decoration: InputDecoration(
            hintText: TextRoutes.search.tr,
            labelStyle: bodyStyle.copyWith(color: fieldColor ?? primaryColor),
            hintStyle: bodyStyle.copyWith(color: fieldColor ?? primaryColor),
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
        itemBuilder: (context, AccountModel account, bool isSelected) {
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
                    "${account.accountName!.tr} (${account.accountType!.tr})",
                    style: bodyStyle.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      onChanged: onChanged,
    );
  }
}
