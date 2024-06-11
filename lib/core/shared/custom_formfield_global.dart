import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/responsive/responisve_text_body.dart';
import 'package:cashier_system/core/responsive/responsive_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class CustomTextFormFieldGlobal extends StatelessWidget {
  final String hinttext;
  final String labeltext;
  final IconData iconData;
  Color? borderColor;
  TextEditingController? mycontroller;
  final String? Function(String?) valid;
  final bool isNumber;
  final bool? readOnly;
  void Function()? onTap;
  final bool? obscureText;
  final bool? capitalizeText;
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
      required this.valid,
      required this.isNumber,
      this.readOnly,
      this.onTap,
      this.capitalizeText,
      this.onChanged,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      onTap: onTap,
      textCapitalization: capitalizeText == true
          ? TextCapitalization.sentences
          : TextCapitalization.none,
      validator: valid,
      textInputAction: TextInputAction.next,
      textAlignVertical: TextAlignVertical.center,
      keyboardType:
          isNumber == true ? TextInputType.number : TextInputType.text,
      obscureText: obscureText ?? false,
      controller: mycontroller,
      style: bodyStyle.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: responsivefontSize(Get.width),
          color: borderColor ?? thirdColor),
      textAlign: TextAlign.start,
      readOnly: readOnly ?? false,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hinttext.tr,
        hintStyle: bodyStyle.copyWith(
            fontSize: responsivefontSize(Get.width),
            fontWeight: FontWeight.w500,
            color: borderColor ?? thirdColor),
        alignLabelWithHint: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        floatingLabelStyle: titleStyle.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: responsivefontSize(Get.width),
            color: borderColor ?? thirdColor),
        label: Text(
          labeltext.tr,
          style: titleStyle.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: responsivefontSize(Get.width),
              color: borderColor ?? thirdColor),
        ),
        prefixIcon: Icon(
          iconData,
          color: borderColor ?? thirdColor,
          size: responsiveIconSize(Get.width),
        ),
        // suffixIcon: onTapIcon == null
        //     ? Container(width: 0,)
        //     : IconButton(
        //         onPressed: onTapIcon,
        //         icon: Icon(
        //           obscureText == true
        //               ? Icons.remove_red_eye
        //               : Icons.remove_red_eye_outlined,
        //           color: white,
        //         )),
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
            borderSide:
                BorderSide(color: borderColor ?? primaryColor, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
      ),
    );
  }
}
