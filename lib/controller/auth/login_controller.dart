import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/screen_routes.dart';
import 'package:cashier_system/core/constant/dev_config.dart';
import 'package:cashier_system/core/dialogs/custom_snack_bar.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/data/source/auth_class.dart';
import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  SqlDb sqlDb = SqlDb();
  GlobalKey<FormState> formStateLogin = GlobalKey<FormState>();
  AuthClass authClass = AuthClass();
  late TextEditingController email;
  late TextEditingController password;
  bool isShowPassword = true; //! Show Password and Hide :
  showPassword() {
    isShowPassword = isShowPassword == true ? false : true;
    update();
  } //! Login Method :

  login() async {
    try {
      if (formStateLogin.currentState!.validate()) {
        // Development mode bypass
        if (DevConfig.isDevelopmentMode && 
            email.text.trim() == DevConfig.devUsername && 
            password.text.trim() == DevConfig.devPassword) {
          _setDevLoginSession();
          Get.offAndToNamed(AppRoute.homeScreen);
          return;
        }
        
        var response =
            await authClass.login(email.text.trim(), password.text.trim());
        if (response['status'] == "success") {
          myServices.sharedPreferences.setString(
              "admins_id", response['data'][0]['admin_id'].toString());

          myServices.sharedPreferences.setString(
              "admins_username", response['data'][0]['admin_username']);
          myServices.sharedPreferences
              .setString("admins_role", response['data'][0]['admin_role']);
          myServices.sharedPreferences.setString(
              "admins_password", response['data'][0]['admin_password']);
          myServices.sharedPreferences
              .setString("admins_name", response['data'][0]['admin_name']);
          myServices.systemSharedPreferences.setString("cart_number", "1");
          myServices.systemSharedPreferences.setBool("start_new_cart", true);
          myServices.sharedPreferences.setString("step", "dashboard");
          Get.offAndToNamed(AppRoute.homeScreen);
        } else {
          customSnackBar("Fail", "Username or password not correct");
        }
      }
    } catch (e) {
      showErrorDialog("", title: "Error", message: "Error during login");
    } finally {
      update();
    }
  }

  void _setDevLoginSession() {
    myServices.sharedPreferences.setString("admins_id", "999");
    myServices.sharedPreferences.setString("admins_username", "dev_admin");
    myServices.sharedPreferences.setString("admins_role", "Full Access");
    myServices.sharedPreferences.setString("admins_password", DevConfig.devPassword);
    myServices.sharedPreferences.setString("admins_name", "Development Admin");
    myServices.systemSharedPreferences.setString("cart_number", "1");
    myServices.systemSharedPreferences.setBool("start_new_cart", true);
    myServices.sharedPreferences.setString("step", "dashboard");
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
