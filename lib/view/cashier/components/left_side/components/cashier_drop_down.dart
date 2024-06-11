import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/data/model/locale/custom_selected_list_items.dart';
import 'package:cashier_system/view/cashier/components/left_side/components/show_drop_down_items_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CashierDropDownSearch extends GetView<CashierController> {
  final String? title;
  final IconData? iconData;
  final List<CustomSelectedListItems> listData;
  final TextEditingController contrllerName;
  final TextEditingController contrllerId;

  const CashierDropDownSearch(
      {super.key,
      this.title,
      required this.listData,
      required this.contrllerName,
      required this.contrllerId,
      this.iconData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 47,
      child: TextFormField(
        controller: contrllerName,
        cursorColor: Colors.black,
        onTap: () {
          //  FocusScope.of(context).unfocus();
          showDropDownList(context, listData, contrllerId, contrllerName);
        },
        style: titleStyle.copyWith(
            color: primaryColor, fontWeight: FontWeight.w100, fontSize: 13),
        textAlign: TextAlign.start,
        autofocus: true,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          hintText: contrllerName.text == "" ? title : contrllerName.text,
          prefixIcon: Icon(
            iconData,
            color: primaryColor,
          ),
          suffixIcon: Icon(
            Icons.keyboard_arrow_down_sharp,
            color: primaryColor,
          ),
          focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: secondColor, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: thirdColor, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.greenAccent, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(5))),
        ),
      ),
    );
  }
}
