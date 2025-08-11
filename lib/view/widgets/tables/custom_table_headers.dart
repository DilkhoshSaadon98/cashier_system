import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

List<DataColumn> customTableHeaders(
    List<String> labels, List<double> cellWidth) {
  return List<DataColumn>.generate(labels.length, (index) {
    return DataColumn(
      label: SizedBox(
        width: cellWidth[index].w,
        child: Center(
            child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            labels[index].tr,
            style: titleStyle.copyWith(color: white),
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade,
          ),
        )),
      ),
    );
  });
}
