import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildLogoDesktop([Color? color]) {
  return CircleAvatar(
    radius: 350.w,
    backgroundColor: primaryColor,
    child: Image.asset(
      AppImageAsset.mainLogo,
      width: 350.w,
    ),
  );
}
