import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/screen_routes.dart';
import 'package:cashier_system/core/dialogs/custom_snack_bar.dart';
import 'package:cashier_system/core/class/sqldb.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AddAdminController extends GetxController {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  SqlDb sqlDb = SqlDb();
  String adminId = "";
  TextEditingController? adminName;
  TextEditingController? adminUsername;
  TextEditingController? adminEmail;
  TextEditingController? adminPassword;
  TextEditingController? adminRole;
  List<String> accountListTitles = [
    "Name",
    "Username",
    "E-mail",
    "Password",
    "Admin Roll"
  ];

  addAdminData() async {
    if (key.currentState!.validate()) {
      var response = await sqlDb.getAllData("tbl_admins",
          where: "admin_username = '${adminUsername!.text}'");
      if (response['status'] == 'failure') {
        Map<String, dynamic> data = {
          "admin_name": adminName!.text,
          "admin_username": adminUsername!.text,
          "admin_email": adminEmail!.text,
          "admin_password": adminPassword!.text,
          "admin_role":
              adminRole!.text.isNotEmpty ? adminRole!.text : "Full Access",
          "admin_createdate": currentTime,
        };
        int response = await sqlDb.insertData("tbl_admins", data);
        if (response > 0) {
          myServices.sharedPreferences.setString("admins_id", adminId);
          myServices.sharedPreferences
              .setString("admins_email", adminEmail!.text);
          myServices.sharedPreferences
              .setString("admins_username", adminUsername!.text);
          myServices.sharedPreferences
              .setString("admins_name", adminName!.text);
          myServices.sharedPreferences
              .setString("admins_role", adminRole!.text);
          Get.offNamed(AppRoute.homeScreen);
        }
      } else {
        customSnackBar("Fail", "Username Already Exist");
      }
    }
  }

  List<TextEditingController> accountListController = [];
  @override
  void onInit() {
    adminName = TextEditingController();
    adminUsername = TextEditingController();
    adminEmail = TextEditingController();
    adminPassword = TextEditingController();
    adminRole = TextEditingController();
    accountListController = [
      adminName!,
      adminUsername!,
      adminEmail!,
      adminPassword!,
      adminRole!,
    ];
    super.onInit();
  }

  @override
  void dispose() {
    adminName!.dispose();
    adminUsername!.dispose();
    adminEmail!.dispose();
    adminPassword!.dispose();
    adminRole!.dispose();
    super.dispose();
  }
}
