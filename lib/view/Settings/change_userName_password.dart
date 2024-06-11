import 'package:cashier_system/controller/setting/setting_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/view/Settings/right_side_widget.dart';
import 'package:cashier_system/view/Settings/widgets/custom_textfield_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChangeUsernamePassword extends StatelessWidget {
  const ChangeUsernamePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: thirdColor,
      body: Row(
        children: [
          // مساحة العمل
          GetBuilder<SettingController>(builder: (controller) {
            return Container(
              height: double.infinity,
              width: 0.7.sw,
              decoration: BoxDecoration(
                border: Border.all(width: 1.w),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.all(20.h),
                      child: Text(
                        "Change Username and Password",
                        style: TextStyle(
                          color: white,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    CustomTextFieldSetting("Old Username",
                        controller.oldUsername, "username", Icons.person),
                    CustomTextFieldSetting("Old Password",
                        controller.oldPassword, "", Icons.security),
                    CustomTextFieldSetting("New Username",
                        controller.newUsername, "username", Icons.person),
                    CustomTextFieldSetting("New Password",
                        controller.newPassword, "", Icons.security),
                    //change button
                    Container(
                      margin: EdgeInsets.only(top: 0.02.sh),
                      padding: EdgeInsets.symmetric(
                          horizontal: 0.05.sw, vertical: 0.02.sh),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.w),
                        color: fourthColor,
                        borderRadius: BorderRadius.circular(8.w),
                      ),
                      child: Text(
                        "Change",
                        style: TextStyle(fontSize: 18.spMax, color: white),
                      ),
                    ),

                    // Request Manager password
                    Container(
                      width: 0.35.sw,
                      margin: EdgeInsets.only(top: 40.h, bottom: 20.h),
                      child: Text(
                        "Request Manager password for:",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10.h),
                      width: 450.w,
                      height: 0.04.sh,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Login",
                            style: TextStyle(fontSize: 20.sp),
                          ),
                          Switch(value: true, onChanged: (val) {}),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10.h),
                      width: 450.w,
                      height: 0.04.sh,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Setting",
                            style: TextStyle(fontSize: 20.sp),
                          ),
                          Switch(value: true, onChanged: (val) {}),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10.h),
                      width: 450.w,
                      height: 0.04.sh,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Show Data",
                            style: TextStyle(fontSize: 20.sp),
                          ),
                          Switch(value: true, onChanged: (val) {}),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          // قسم الازار
          const RightSideWidget(
          ),
        ],
      ),
    );
  }
}
