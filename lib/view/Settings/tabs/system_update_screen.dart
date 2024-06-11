import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpdateSystemScreen extends StatelessWidget {
  const UpdateSystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarTitle("System Update"),
      backgroundColor: white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            margin: EdgeInsets.all(20.h),
            child: Text(
              "OS version 1.0.0",
              style: TextStyle(
                fontSize: 35.sp,
                color: white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.h),
            width: 0.35.sw,
            height: 0.1.sh,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Automatic updates",
                  style: TextStyle(fontSize: 20.sp),
                ),
                Switch(value: false, onChanged: (val) {}),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.all(10.h),
            width: 0.35.sw,
            height: 0.1.sh,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Download OS updates",
                  style: TextStyle(fontSize: 20.sp),
                ),
                Switch(value: true, onChanged: (val) {}),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.h),
            width: 0.35.sw,
            height: 0.1.sh,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "install OS updates",
                  style: TextStyle(fontSize: 20.sp),
                ),
                Switch(value: true, onChanged: (val) {}),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.all(10.h),
            width: 0.50.sw,
            height: 0.1.sh,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Time for Automatic Updates : ",
                  style: TextStyle(fontSize: 20.sp),
                ),
                Container(
                  height: 0.1.sh,
                  width: 0.2.sw,
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                )
              ],
            ),
          ),

          //button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buttonStyle("Check For Update", secondColor),
              SizedBox(width: 20.w),
              _buttonStyle("Update Now", secondColor),
              SizedBox(width: 20.w),
            ],
          )
        ],
      ),
    );
  }
}

Widget _buttonStyle(String butName, Color color) {
  return Container(
    margin: EdgeInsets.only(top: 0.02.sh),
    padding: EdgeInsets.symmetric(horizontal: 0.03.sw, vertical: 0.02.sh),
    decoration: BoxDecoration(
      border: Border.all(width: 1.w),
      color: color,
      borderRadius: BorderRadius.circular(8.w),
    ),
    child: Text(
      butName,
      style: TextStyle(fontSize: 18.spMax, color: white),
    ),
  );
}
