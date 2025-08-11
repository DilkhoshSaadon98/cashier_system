import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildLogoMobile() {
  return Image.asset(
    fit: BoxFit.contain,
    AppImageAsset.mainLogo,
    width: 300.w,
    height: 300.h,
  );
}
