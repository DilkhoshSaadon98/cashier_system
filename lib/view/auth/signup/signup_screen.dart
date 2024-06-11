import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/shared/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_formfield_global.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        color: primaryColor,
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(),
                customSizedBox(75),
                Text(
                  "Sign Up",
                  style: titleStyle.copyWith(
                    color: white,
                    fontSize: 25,
                  ),
                ),
                customSizedBox(),
                SizedBox(
                  width: Get.width / 3,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Text(
                            "User name",
                            style:
                                titleStyle.copyWith(color: white, fontSize: 18),
                          )),
                          Expanded(
                            flex: 3,
                            child: CustomTextFormFieldGlobal(
                              hinttext: 'username',
                              labeltext: "Username",
                              iconData: Icons.person,
                              valid: (value) {
                                return validInput(value!, 0, 100, "");
                              },
                              isNumber: false,
                              borderColor: white,
                            ),
                          )
                        ],
                      ),
                      customSizedBox(),
                      Row(
                        children: [
                          Expanded(
                              child: Text(
                            "E-mail",
                            style:
                                titleStyle.copyWith(color: white, fontSize: 18),
                          )),
                          Expanded(
                            flex: 3,
                            child: CustomTextFormFieldGlobal(
                              hinttext: 'E-mail',
                              labeltext: "E-mail",
                              iconData: Icons.person,
                              valid: (value) {
                                return validInput(value!, 0, 100, "email");
                              },
                              isNumber: false,
                              borderColor: white,
                            ),
                          )
                        ],
                      ),
                      customSizedBox(),
                      Row(
                        children: [
                          Expanded(
                              child: Text(
                            "Password",
                            style:
                                titleStyle.copyWith(color: white, fontSize: 18),
                          )),
                          Expanded(
                            flex: 3,
                            child: CustomTextFormFieldGlobal(
                              hinttext: 'password',
                              labeltext: "Passord",
                              iconData: Icons.password,
                              valid: (value) {
                                return validInput(value!, 0, 100, "");
                              },
                              isNumber: false,
                              borderColor: white,
                            ),
                          )
                        ],
                      ),
                      customSizedBox(5),
                      Container(
                        width: Get.width,
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Forget Password",
                          style: bodyStyle.copyWith(color: white),
                        ),
                      ),
                      customSizedBox(5),
                      customButtonGlobal(
                          () {}, "Login", Icons.login, Colors.blue, white),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customButtonGlobal(() {}, "Sign Up", Icons.person_add,
                              Colors.teal, white, 200, 50),
                          customButtonGlobal(
                              () {},
                              "Contact us",
                              Icons.support_agent,
                              Colors.redAccent,
                              white,
                              200,
                              50),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildLogo() {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'MR.ROBOT ',
          style: introStyle.copyWith(fontSize: 60.sp, color: white),
        ),
        Text(
          'COM.',
          style: introStyle.copyWith(fontSize: 60.sp, color: secondColor),
        ),
      ],
    ),
  );
}
