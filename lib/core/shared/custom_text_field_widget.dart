import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class CustomTextFieldWidget extends StatelessWidget {
  final String hinttext;
  final String labeltext;
  final IconData iconData;
  IconData? suffixIconData;
  Color? borderColor;
  Color? fieldColor;
  TextEditingController? controller;
  final String? Function(String?) valid;
  final bool isNumber;
  final bool? readOnly;
  void Function()? onTap;
  final void Function(String)? onChanged;
  final void Function()? onTapIcon;

  CustomTextFieldWidget(
      {super.key,
      this.onTapIcon,
      required this.hinttext,
      required this.labeltext,
      required this.iconData,
      this.controller,
      this.suffixIconData,
      required this.valid,
      required this.isNumber,
      this.readOnly,
      this.onTap,
      this.onChanged,
      this.borderColor,
      this.fieldColor});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      validator: valid,
      textInputAction: TextInputAction.next,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: onTap != null
          ? TextInputType.none
          : isNumber
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
      inputFormatters: isNumber
          ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))]
          : [],
      controller: controller,
      style: bodyStyle.copyWith(
          fontSize: 12.sp,
          fontWeight: FontWeight.w200,
          overflow: TextOverflow.clip,
          color: borderColor ?? primaryColor),
      textAlign: TextAlign.start,
      readOnly: readOnly ?? false,
      onChanged: onChanged,
      decoration: InputDecoration(
        fillColor: fieldColor,
        filled: true,
        errorStyle: bodyStyle.copyWith(color: Colors.red, fontSize: 10),
        hintText: hinttext.tr,
        hintStyle: bodyStyle.copyWith(
            fontSize: 12.sp, color: borderColor ?? primaryColor),
        floatingLabelStyle: bodyStyle.copyWith(
            fontSize: 14.sp, color: borderColor ?? primaryColor),
        label: Text(
          labeltext.tr,
          maxLines: 1,
          overflow: TextOverflow.clip,
          style: bodyStyle.copyWith(
              fontSize: 12.sp, color: borderColor ?? primaryColor),
        ),
        hintMaxLines: 1,
        prefixIcon: Icon(
          iconData,
          color: borderColor ?? primaryColor,
          size: 20,
        ),
        suffixIcon: onTapIcon == null
            ? null
            : IconButton(
                onPressed: onTapIcon,
                icon: Icon(
                  suffixIconData,
                  color: actionSideColor,
                )),
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
    );
  }
}
