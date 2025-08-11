import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

MyServices myServices = Get.put(MyServices());
TextStyle get titleStyle {
  String? lang = myServices.sharedPreferences.getString('lang');

  TextStyle textStyle;

  if (lang == 'en') {
    textStyle = GoogleFonts.cairo(
      textStyle: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),
    );
  } else if (lang == 'ar') {
    textStyle = GoogleFonts.cairo(
      textStyle: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),
    );
  } else {
    textStyle = GoogleFonts.amiri(
      textStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),
    );
  }

  return textStyle;
}

TextStyle get bodyStyle {
  String? lang = myServices.sharedPreferences.getString('lang');

  TextStyle textStyle;

  if (lang == 'en') {
    textStyle = GoogleFonts.barlowCondensed(
      textStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: primaryColor,
      ),
    );
  } else if (lang == 'ar') {
    textStyle = GoogleFonts.cairo(
      textStyle: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        color: primaryColor,
      ),
    );
  } else {
    textStyle = GoogleFonts.amiri(
      textStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: primaryColor,
      ),
    );
  }

  return textStyle;
}

TextStyle get introStyle {
  return GoogleFonts.monoton(
      textStyle: TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
    color: primaryColor,
  ));
}

double constScreenPadding = 15.w;
double mobileScreenWidth = 700.0;
double constRadius = 5.r;
String currentTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
