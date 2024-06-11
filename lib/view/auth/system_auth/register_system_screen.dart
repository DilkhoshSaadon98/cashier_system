import 'package:cashier_system/controller/auth/login_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RegisterSystemScreen extends StatelessWidget {
  const RegisterSystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.put(LoginController());
    final focusNodes = List.generate(4, (index) => FocusNode());
    return Scaffold(
      backgroundColor: primaryColor,
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
                  "System Registeration",
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
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Form(
                                  //key: _formKey,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: List.generate(4, (index) {
                                      return SizedBox(
                                        width: 80,
                                        child: TextFormField(
                                          //  controller: _otpControllers[index],
                                          textAlign: TextAlign.center,
                                          maxLength: 4,
                                          focusNode: focusNodes[index],
                                          style:
                                              titleStyle.copyWith(color: white),
                                          decoration: InputDecoration(
                                            counterText: '',
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: secondColor,
                                                            width: 1),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5.r))),
                                            errorBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: white, width: 1),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5.r))),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                                    borderSide:
                                                        BorderSide(
                                                            color: secondColor,
                                                            width: 1),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5))),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                                    borderSide:
                                                        BorderSide(
                                                            color: white,
                                                            width: 1),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5))),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.length != 4) {
                                              return 'Enter 4 digits';
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            if (value.length == 4 &&
                                                index < 3) {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      focusNodes[index + 1]);
                                            } else if (value.length == 4 &&
                                                index == 3) {
                                              focusNodes[index].unfocus();
                                            }
                                          },
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(4),
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        customSizedBox(),
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
