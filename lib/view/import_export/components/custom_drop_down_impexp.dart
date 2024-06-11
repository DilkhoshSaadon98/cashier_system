import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class CustomDropDownImpExp extends StatelessWidget {
  final String? title;
  final IconData? iconData;
  final List<SelectedListItem> listData;
  Color? color;
  TextEditingController? contrllerName;
  TextEditingController? contrllerId;

  CustomDropDownImpExp(
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
        showDropDownList(context);
      },
      textInputAction: TextInputAction.next,
      style: titleStyle.copyWith(
          color: color ?? white, fontWeight: FontWeight.w100, fontSize: 15),
      textAlign: TextAlign.start,

      decoration: InputDecoration(
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
        hintText: title,
        hintStyle: bodyStyle.copyWith(
            color: color ?? white,
            fontWeight: FontWeight.w100,
            fontSize: 10.sp),
        prefixIcon: Icon(
          iconData,
          color: color ?? white,
        ),
        suffixIcon: Icon(
          Icons.arrow_drop_down_outlined,
          color: color ?? white,
        ),
        focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: secondColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: thirdColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.greenAccent, width: 1),
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
