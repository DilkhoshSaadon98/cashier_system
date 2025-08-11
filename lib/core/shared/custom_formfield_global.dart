import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class CustomTextFormFieldGlobal extends StatelessWidget {
  final String hinttext;
  final String labeltext;
  final IconData iconData;
  IconData? suffixIconData;
  Color? borderColor;
  TextEditingController? mycontroller;
  final String? Function(String?) valid;
  final bool isNumber;
  final bool? readOnly;
  void Function()? onTap;
  final bool? obscureText;
  final void Function(String)? onChanged;
  final void Function()? onTapIcon;

  CustomTextFormFieldGlobal(
      {super.key,
      this.obscureText,
      this.onTapIcon,
      required this.hinttext,
      required this.labeltext,
      required this.iconData,
      this.mycontroller,
      this.suffixIconData,
      required this.valid,
      required this.isNumber,
      this.readOnly,
      this.onTap,
      this.onChanged,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      //  autofocus: true,
      onTap: onTap,
      validator: valid,
      textInputAction: TextInputAction.next,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: onTap != null
          ? TextInputType.none
          : isNumber == true
              ? TextInputType.number
              : TextInputType.text,
      obscureText: obscureText ?? false,
      controller: mycontroller,
      style: bodyStyle.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 14.sp,
          overflow: TextOverflow.clip,
          color: borderColor ?? primaryColor),
      textAlign: TextAlign.start,
      readOnly: readOnly ?? false,
      onChanged: onChanged,
      decoration: InputDecoration(
        fillColor: fieldColor,
        filled: true,
        errorStyle: bodyStyle.copyWith(color: Colors.red),
        hintText: hinttext.tr,
        hintStyle: bodyStyle.copyWith(color: borderColor ?? primaryColor),
        floatingLabelStyle: bodyStyle.copyWith(
            fontSize: 14.sp, color: borderColor ?? primaryColor),
        label: Text(
          labeltext.tr,
          overflow: TextOverflow.clip,
          style: bodyStyle.copyWith(color: borderColor ?? primaryColor),
        ),
        prefixIcon: Icon(
          iconData,
          color: borderColor ?? primaryColor,
          size: 20,
        ),
        suffixIcon: onTapIcon == null
            ? Container(
                width: 0,
              )
            : IconButton(
                onPressed: onTapIcon,
                icon: suffixIconData != null
                    ? Icon(
                        suffixIconData,
                        color: primaryColor,
                      )
                    : Icon(
                        obscureText == true
                            ? Icons.remove_red_eye
                            : Icons.remove_red_eye_outlined,
                        color: white,
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
