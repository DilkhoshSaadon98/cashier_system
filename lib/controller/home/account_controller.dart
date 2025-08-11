import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/screen_routes.dart';
import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
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
    "Email",
    "Password",
    "Admin Role",
  ];
  getAdminData(String username) async {
    var response = await sqlDb.getAllData("tbl_admins",
        where: "admin_username = '$username'");
    if (response['status'] == 'success') {
      adminId = response['data'][0]['admin_id'].toString();
      adminName!.text = response['data'][0]['admin_name'];
      adminUsername!.text = response['data'][0]['admin_username'];
      adminEmail!.text = response['data'][0]['admin_email'];
      adminPassword!.text = response['data'][0]['admin_password'];
      adminRole!.text = response['data'][0]['admin_role'];
    }
  }

  editAdminData() async {
    Map<String, dynamic> data = {
      "admin_name": adminName!.text,
      "admin_username": adminUsername!.text,
      "admin_email": adminEmail!.text,
      "admin_password": adminPassword!.text,
      "admin_role":
          adminRole!.text.isNotEmpty ? adminRole!.text : "Full Access",
      "admin_createdate": currentTime,
    };
    int response =
        await sqlDb.updateData("tbl_admins", data, "admin_id = $adminId");
    if (response > 0) {
      myServices.sharedPreferences.setString("admins_id", adminId);
      myServices.sharedPreferences.setString("admins_email", adminEmail!.text);
      myServices.sharedPreferences
          .setString("admins_username", adminUsername!.text);
      myServices.sharedPreferences.setString("admins_role", adminRole!.text);
      myServices.sharedPreferences.setString("admins_name", adminName!.text);
      Get.offNamed(AppRoute.homeScreen);
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
      adminRole!
    ];
    getAdminData(myServices.sharedPreferences.getString("admins_username")!);
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
