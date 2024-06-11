import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget customSizedBox([double? height]) {
  return SizedBox(
    height: height ?? 15.h,
  );
}
