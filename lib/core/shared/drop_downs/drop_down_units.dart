import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

// ignore: must_be_immutable
class CustomDropDownUnits extends StatelessWidget {
  final String? title;
  final IconData? iconData;
  final List<SelectedListItem> listData;
  Color? color;
  TextEditingController? contrllerName;
  TextEditingController? contrllerId;
  void Function(String)? onChanged;
  final bool? readOnly;

  String? Function(String?)? valid;

  CustomDropDownUnits(
      {super.key,
      this.title,
      required this.listData,
      this.color,
      this.contrllerName,
      this.contrllerId,
      this.onChanged,
      this.iconData,
      this.valid,
      this.readOnly});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: contrllerName,
      cursorColor: color ?? white,
      keyboardType: TextInputType.none,
      onTap: () {
        FocusScope.of(context).unfocus();
        showDropDownList(context);
      },
      validator: valid,
      onChanged: onChanged,
      readOnly: true,
      style: titleStyle.copyWith(
          fontSize: 14, fontWeight: FontWeight.w700, color: color ?? white),
      textAlign: TextAlign.start,
      decoration: InputDecoration(
        errorStyle: bodyStyle.copyWith(color: Colors.red),
        fillColor: fieldColor,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        label: Text(
          title!.tr,
          style: titleStyle.copyWith(
            fontSize: 14,
            color: color ?? white,
            fontWeight: FontWeight.w100,
          ),
        ),
        hintText: title?.tr,
        hintStyle: titleStyle.copyWith(
            fontSize: 14, fontWeight: FontWeight.w700, color: color ?? white),
        prefixIcon: Icon(
          size: 20,
          iconData,
          color: color ?? white,
        ),
        suffixIcon: Icon(
          Icons.arrow_drop_down,
          color: color ?? white,
        ),
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
            borderSide: BorderSide(color: color ?? white, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(constRadius))),
      ),
    );
  }

  void showDropDownList(context) {
    DropDownState(
      DropDown(
        bottomSheetTitle: Text(title!.tr, style: titleStyle),
        submitButtonChild: const Text(
          'Done',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        data: listData,
        selectedItems: (List<dynamic> selectedList) {
          SelectedListItem selectedListItem = selectedList[0];
          contrllerName!.text = selectedListItem.name;
          contrllerId!.text = selectedListItem.value!;
        },
      ),
    ).showModal(context);
  }
}
