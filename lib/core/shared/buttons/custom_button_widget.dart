import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

Widget customButtonWidget(final void Function()? onTap, final String title,
    {Color? color,
    IconData? iconData,
    Color? textColor,
    double? width,
    double? height,
    bool? isSvg = false,
    String? svgPath}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: width ?? Get.width,
      height: height ?? 50,
      margin: EdgeInsets.symmetric(vertical: 5.h),
      decoration: BoxDecoration(
          color: color ?? white,
          border: Border.all(color: textColor ?? thirdColor, width: .5),
          borderRadius: BorderRadius.circular(5.r)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            title.tr,
            style: bodyStyle.copyWith(
                fontSize: 12.sp,
                color: textColor ?? thirdColor,
                fontWeight: FontWeight.w600),
          ),
          !isSvg!
              ? Icon(
                  iconData,
                  size: 20,
                  color: textColor ?? thirdColor,
                )
              : SvgPicture.asset(
                  svgPath!,
                  width: 25,
                  color: textColor ?? thirdColor,
                ),
        ],
      ),
    ),
  );
}
