import 'package:cashier_system/controller/inventory/inventory_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class CustomDropDownInventory extends GetView<InventoryController> {
  final String? title;
  final IconData? iconData;
  final List<SelectedListItem> listData;
  Color? color;
  TextEditingController? contrllerName;
  TextEditingController? contrllerId;

  CustomDropDownInventory(
      {super.key,
      this.title,
      required this.listData,
      this.color,
      this.contrllerName,
      this.contrllerId,
      this.iconData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        // controller: contrllerName,
        cursorColor: color ?? white,
        onTap: () {
          FocusScope.of(context).unfocus();
          showDropDownList(context);
        },
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
          // hintText: contrllerName.text == "" ? title : contrllerName.text,
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
              borderSide: BorderSide(color: secondColor, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: thirdColor, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.greenAccent, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: color ?? white, width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(5))),
        ),
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
          controller.changeIndex(contrllerName!.text);
        },
      ),
    ).showModal(context);
  }
}
