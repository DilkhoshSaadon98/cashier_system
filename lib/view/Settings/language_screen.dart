import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/view/Settings/right_side_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: thirdColor,
      body: Row(
        children: [
          Container(
            alignment: Alignment.center,
            height: double.infinity,
            width: 0.7.sw,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customButton("English"),
                customButton("Arabic"),
                customButton("Kurdi"),
              ],
            ),
          ),
          const RightSideWidget(
          ),
        ],
      ),
    );
  }

  Widget customButton(String lang) {
    return Container(
      width: 400.w,
      height: 0.08.sh,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(10.w),
      ),
      child: InkWell(
        onTap: () {},
        child: Text(
          lang,
          style: TextStyle(
            color: primaryColor,
            fontSize: 18.sp,
          ),
        ),
      ),
    );
  }
}
