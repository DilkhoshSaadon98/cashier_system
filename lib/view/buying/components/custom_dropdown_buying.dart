import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/responsive/responisve_text_body.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class CustomDropDownBuying extends StatelessWidget {
  final String? title;
  final IconData? iconData;
  final List<SelectedListItem> listData;
  Color? color;
  TextEditingController? contrllerName;
  TextEditingController? contrllerId;

  CustomDropDownBuying(
      {super.key,
      this.title,
      required this.listData,
      this.color,
      this.contrllerName,
      this.contrllerId,
      this.iconData});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: contrllerName,
      cursorColor: color ?? white,
      onTap: () {
        FocusScope.of(context).unfocus();
        showDropDownList(context);
      },
      style: titleStyle.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: responsiveFontSize(Get.width),
          color: color ?? white),
      textAlign: TextAlign.start,
      decoration: InputDecoration(
        fillColor: fieldColor,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        label: Text(
          title!,
          style: titleStyle.copyWith(
              color: color ?? white,
              fontWeight: FontWeight.w100,
              fontSize: 10.sp),
        ),
        // hintText: contrllerName.text == "" ? title : contrllerName.text,
        hintText: title,
        hintStyle: titleStyle.copyWith(
            fontSize: responsiveFontSize(Get.width),
            fontWeight: FontWeight.w700,
            color: color ?? white),
        prefixIcon: Icon(
          iconData,
          color: color ?? white,
        ),
        suffixIcon: Icon(
          Icons.arrow_drop_down,
          color: color ?? white,
        ),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: secondColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(5.r))),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: thirdColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(5.r))),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: secondColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: color ?? white, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
      ),
    );
  }

  void showDropDownList(context) {
    DropDownState(
      DropDown(
        bottomSheetTitle: Text(title!, style: titleStyle),
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
