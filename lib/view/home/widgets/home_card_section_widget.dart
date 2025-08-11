import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

Widget customHomeItemsCard(Map data) {
  return InkWell(
    onTap: data['on_tap'],
    child: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(12.w),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              data['icon'],
              semanticsLabel: 'Icon',
              color: primaryColor,
              width: 75,
              height: 75,
            ),
            SizedBox(height: 10.h),
            Text(
              data['title'].toString().tr,
              textAlign: TextAlign.center,
              style: titleStyle.copyWith(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
