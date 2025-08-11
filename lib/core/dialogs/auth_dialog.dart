import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/dialogs/custom_snack_bar.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/shared/custom_formfield_global.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthenticationDialog extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final String screenRoute;
  const AuthenticationDialog(
      {super.key,
      required this.screenRoute,
      required this.usernameController,
      required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentTextStyle: bodyStyle,
      icon: const Icon(
        Icons.security,
        color: primaryColor,
        size: 50,
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: Text(
        "Login".tr,
        style: titleStyle,
      ),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFormFieldGlobal(
                borderColor: primaryColor,
                mycontroller: usernameController,
                hinttext: "Username",
                labeltext: "Username",
                iconData: Icons.person_outline,
                valid: (value) {
                  return validInput(value!, 0, 50, "username");
                },
                isNumber: false,
              ),
              verticalGap(),
              CustomTextFormFieldGlobal(
                borderColor: primaryColor,
                mycontroller: passwordController,
                hinttext: "Password",
                labeltext: "Password",
                iconData: Icons.lock_outline,
                valid: (value) {
                  return validInput(value!, 0, 50, "password");
                },
                isNumber: false,
                obscureText: true,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(
            'Cancel'.tr,
            style: bodyStyle.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onPressed: () {
            String username = usernameController.text;
            String password = passwordController.text;

            String? storedUsername =
                myServices.sharedPreferences.getString("admins_username");
            String? storedPassword =
                myServices.sharedPreferences.getString("admins_password");
            String? constPassword =
                myServices.sharedPreferences.getString("auth_code");
            if (username == storedUsername &&
                (password == storedPassword || password == constPassword)) {
              Get.back();
              Get.back();
              Get.toNamed(screenRoute);
            } else {
              customSnackBar("Fail", "Authentication Failed");
            }
          },
          child: Text(
            'Login'.tr,
            style: titleStyle.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

void showAuthenticationDialog(BuildContext context, String screenRoute,
    TextEditingController username, TextEditingController password) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AuthenticationDialog(
          screenRoute: screenRoute,
          usernameController: username,
          passwordController: password);
    },
  );
}
