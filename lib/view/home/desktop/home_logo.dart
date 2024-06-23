import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildLogoDesktop([Color? color]) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: myServices.sharedPreferences.getString("lang") == "en"
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'MR.ROBOT ',
                style:
                    introStyle.copyWith(fontSize: 60.sp, color: color ?? white),
              ),
              Text(
                'COM.',
                style: introStyle.copyWith(fontSize: 60.sp, color: secondColor),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'COM.',
                style: introStyle.copyWith(fontSize: 60.sp, color: secondColor),
              ),
              Text(
                'MR.ROBOT ',
                style: introStyle.copyWith(fontSize: 60.sp, color:color?? white),
              ),
            ],
          ),
  );
}
