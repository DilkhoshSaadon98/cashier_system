import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/routes.dart';
import 'package:cashier_system/data/sql/data/auth_class.dart';
import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  SqlDb sqlDb = SqlDb();
  GlobalKey<FormState> formstateLogin = GlobalKey<FormState>();
  AuthClass authClass = AuthClass();
  late TextEditingController email;
  late TextEditingController password;
  bool isshowpassword = true; //! Show Password and Hide :
  showPassword() {
    isshowpassword = isshowpassword == true ? false : true;
    update();
  } //! Login Method :

  login() async {
    if (formstateLogin.currentState!.validate()) {
      update();
      var response =
          await authClass.login(email.text.trim(), password.text.trim());
      if (response['status'] == "success") {
        if (response['data'][0]['admin_approve'] == "1") {
          myServices.sharedPreferences.setString(
              "admins_id", response['data'][0]['admin_id'].toString());
          myServices.sharedPreferences
              .setString("admins_email", response['data'][0]['admin_email']);
          myServices.sharedPreferences.setString(
              "admins_username", response['data'][0]['admin_username']);
          myServices.sharedPreferences
              .setString("admins_name", response['data'][0]['admin_name']);
          myServices.sharedPreferences.setString("step", "2");
          Get.offNamed(AppRoute.homeScreen);
        } else {
          print("not approved");
        }
      } else {
        Get.defaultDialog(
            title: 'Error'.tr,
            titleStyle: titleStyle,
            content: Text(
              'Invalid username or password.\n Please try again.'.tr,
              textAlign: TextAlign.center,
              style: bodyStyle,
            ),
            actions: [
              CircleAvatar(
                backgroundColor: primaryColor,
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.check,
                    color: secondColor,
                  ),
                ),
              )
            ]);
      }
      update();
    } else {}
  }

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
