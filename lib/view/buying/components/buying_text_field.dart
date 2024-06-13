import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextFormFieldBuying extends StatelessWidget {
  final String hinttext;
  TextEditingController? nameController;
  TextEditingController? idController;
  final String? Function(String?) valid;
  List<SelectedListItem>? data;
  final bool isNumber;
  void Function()? onTap;
  void Function(String)? onChanged;
  CustomTextFormFieldBuying(
      {super.key,
      required this.hinttext,
      this.nameController,
      this.idController,
      required this.valid,
      required this.isNumber,
      this.onTap,
      this.onChanged,
      this.data});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: nameController,
      textAlign: TextAlign.center,
      style: titleStyle,
      validator: valid,
      onChanged: onChanged,
      onTap: onTap != null
          ? () {
              showDropDownList(context);
            }
          : null,
      decoration: InputDecoration(
          errorStyle: bodyStyle.copyWith(color: Colors.red),
          hintText: hinttext,
          hintStyle: bodyStyle,
          border: InputBorder.none),
    );
  }

  void showDropDownList(context) {
    DropDownState(
      DropDown(
        bottomSheetTitle: Text("Search Items", style: titleStyle),
        submitButtonChild: const Text(
          'Done',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        data: data!,
        selectedItems: (List<dynamic> selectedList) {
          SelectedListItem selectedListItem = selectedList[0];
          nameController!.text = selectedListItem.name;
          idController!.text = selectedListItem.value!;
        },
      ),
    ).showModal(context);
  }
}
