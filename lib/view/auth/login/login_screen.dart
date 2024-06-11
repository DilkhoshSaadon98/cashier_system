import 'package:cashier_system/controller/auth/login_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/shared/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_formfield_global.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.put(LoginController());
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
                  "login",
                  style: titleStyle.copyWith(
                    color: white,
                    fontSize: 25,
                  ),
                ),
                customSizedBox(),
                SizedBox(
                  width: Get.width / 3,
                  child: Form(
                    key: controller.formstateLogin,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              "User name",
                              style: titleStyle.copyWith(
                                  color: white, fontSize: 18),
                            )),
                            Expanded(
                              flex: 3,
                              child: CustomTextFormFieldGlobal(
                                hinttext: 'username',
                                labeltext: "Username",
                                iconData: Icons.person,
                                mycontroller: controller.email,
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
                              "Password",
                              style: titleStyle.copyWith(
                                  color: white, fontSize: 18),
                            )),
                            GetBuilder<LoginController>(builder: (controller) {
                              return Expanded(
                                flex: 3,
                                child: CustomTextFormFieldGlobal(
                                  hinttext: 'password',
                                  labeltext: "Passord",
                                  iconData: Icons.password,
                                  mycontroller: controller.password,
                                  valid: (value) {
                                    return validInput(value!, 0, 100, "");
                                  },
                                  obscureText: controller.isshowpassword,
                                  onTapIcon: () {
                                    controller.showPassword();
                                  },
                                  isNumber: false,
                                  borderColor: white,
                                ),
                              );
                            })
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
                        customButtonGlobal(() async {
                          await controller.login();
                        }, "Login", Icons.login, Colors.tealAccent,
                            primaryColor),
                        customButtonGlobal(
                          () {},
                          "Contact us",
                          Icons.support_agent,
                          Colors.redAccent,
                          primaryColor,
                        ),
                      ],
                    ),
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
