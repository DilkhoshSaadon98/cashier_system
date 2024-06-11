import 'package:cashier_system/controller/setting/setting_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/shared/custom_snack_bar.dart';
import 'package:flutter/material.dart';

class SecurityController extends SettingController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  changeUsernamePassword() async {
    if (formstate.currentState!.validate()) {
      int response = await usersClass.changeUsernamePassword(oldUsername!.text,
          oldPassword!.text, newUsername!.text, newPassword!.text);
      if (response > 0) {
        customSnackBar("Success", "Username and Password Updated Success");
        myServices.sharedPreferences
            .setString("admins_username", newUsername!.text);
        clearFiled();
      } else {
        customSnackBar("Error", "Error While updatting");
      }
    }
  }

  clearFiled() {
    oldUsername!.clear();
    newUsername!.clear();
    oldPassword!.clear();
    newPassword!.clear();
  }

  @override
  void onInit() {
    oldUsername = TextEditingController();
    newUsername = TextEditingController();
    oldPassword = TextEditingController();
    newPassword = TextEditingController();
    super.onInit();
  }
}
