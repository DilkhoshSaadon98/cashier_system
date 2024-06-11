import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/responsive/responisve_text_body.dart';
import 'package:cashier_system/core/responsive/responsive_icons.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropDownSearch extends StatelessWidget {
  final String? title;
  final IconData? iconData;
  final List<SelectedListItem> listData;
  final TextEditingController contrllerName;
  final TextEditingController contrllerId;

  const CustomDropDownSearch(
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
          FocusScope.of(context).unfocus();
          showDropDownList(context);
        },
        style: titleStyle.copyWith(
            color: primaryColor,
            fontWeight: FontWeight.w100,
            fontSize: responsivefontSize(Get.width)),
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          hintText: contrllerName.text == "" ? title : contrllerName.text,
          prefixIcon: Icon(
            iconData,
            color: primaryColor,
            size: responsiveIconSize(Get.width),
          ),
          suffixIcon: Icon(
            Icons.arrow_drop_down_circle_outlined,
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
          contrllerName.text = selectedListItem.name;
          contrllerId.text = selectedListItem.value!;
          //  showSnackBar(list.toString());
        },
      ),
    ).showModal(context);
  }
}
