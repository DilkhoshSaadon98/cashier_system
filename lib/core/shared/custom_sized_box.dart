import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget verticalGap([double? height]) {
  return SizedBox(
    height: height ?? 15.h,
  );
}

Widget horizontalGap([double? width]) {
  return SizedBox(
    width: width ?? 15.w,
  );
}
