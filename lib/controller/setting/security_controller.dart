import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/core/dialogs/custom_snack_bar.dart';
import 'package:cashier_system/data/source/users_class.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecurityController extends GetxController {
  UsersClass usersClass = UsersClass();

  bool checkValidUser = false;

  // Updated to non-nullable controllers
  TextEditingController oldUsername = TextEditingController();
  TextEditingController newUsername = TextEditingController();
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();

  GlobalKey<FormState> currentFormState = GlobalKey<FormState>();
  GlobalKey<FormState> newFormState = GlobalKey<FormState>();

  //? Validate Current User:
  Future<void> validateUser() async {
    try {
      if (currentFormState.currentState != null &&
          currentFormState.currentState!.validate()) {
        int response = await usersClass.validateUserAccount(
          oldUsername.text,
          oldPassword.text,
        );
        if (response > 0) {
          checkValidUser = true;
        } else {
          checkValidUser = false;
          showErrorDialog("",
              title: "Error", message: "Invalid username or password.");
        }
      }
    } catch (e) {
      showErrorDialog(e.toString(), title: "Error", message: "");
    } finally {
      update();
    }
  }

  //? Change Username and Password:
  Future<void> changeUsernamePassword() async {
    try {
      if (newFormState.currentState != null &&
          newFormState.currentState!.validate()) {
        int response = await usersClass.changeUsernamePassword(oldUsername.text,
            oldPassword.text, newUsername.text, newPassword.text);
        if (response > 0) {
          customSnackBar(
              "Success", "Username and Password Updated Successfully");
          myServices.sharedPreferences
              .setString("admins_username", newUsername.text);
          myServices.sharedPreferences
              .setString("admins_password", newPassword.text);
          checkValidUser = false;
          clearFields();
        } else {
          showErrorDialog("",
              title: "Error", message: "Error while updating user data");
        }
      }
    } catch (e) {
      showErrorDialog(e.toString(), title: "Error", message: "");
    } finally {
      update();
    }
  }

  List<String> securitySwitchTitle = [
    "Show Data",
    "Login",
    "Settings",
  ];

  List<bool> securitySwitchState = [
    myServices.sharedPreferences.getBool("show_data") ?? false,
    myServices.sharedPreferences.getBool("login") ?? false,
    myServices.sharedPreferences.getBool("settings") ?? false,
  ];

  void setSecurityData(int index, bool val) async {
    // Update the shared preference value
    if (index == 0) {
      await myServices.sharedPreferences.setBool("show_data", val);
    } else if (index == 1) {
      await myServices.sharedPreferences.setBool("login", val);
    } else if (index == 2) {
      await myServices.sharedPreferences.setBool("settings", val);
    }
    securitySwitchState[index] = val;

    update();
  }

  // Clear all text fields
  void clearFields() {
    oldUsername.clear();
    newUsername.clear();
    oldPassword.clear();
    newPassword.clear();
  }
}
