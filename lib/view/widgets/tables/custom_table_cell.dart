import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

DataCell customTableCell(
  String text, {
  double cellWidth = 75,
  void Function()? onTap,
  void Function()? onSecondaryTap,
  void Function(TapDownDetails)? onTapDown,
}) {
  return DataCell(
    GestureDetector(
      behavior: HitTestBehavior.translucent,
      excludeFromSemantics: true,
      onLongPress: onTap,
      onTapDown: onTapDown,
      onSecondaryTapDown: onTapDown,
      onSecondaryTap: onSecondaryTap,
      child: Container(
        alignment: Alignment.center,
        height: 40.h,
        child: Text(
          text,
          style: bodyStyle,
          maxLines: 2,
          overflow: TextOverflow.fade,
        ),
      ),
    ),
  );
}
