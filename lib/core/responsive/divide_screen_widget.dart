import 'package:cashier_system/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DivideScreenWidget extends StatelessWidget {
  final Widget showWidget, actionWidget;
  const DivideScreenWidget(
      {super.key, required this.showWidget, required this.actionWidget});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
          width: 350,
          color: primaryColor,
          child: actionWidget,
        ),
        Expanded(child: showWidget),
      ],
    );
  }
}
