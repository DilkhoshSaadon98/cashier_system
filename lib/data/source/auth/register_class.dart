import 'dart:io';

import 'package:cashier_system/core/class/crud.dart';

class RegisterClass {
  Crud crud;
  RegisterClass(this.crud);
  checkData(
    String registerCode,
    String platFormCode,
  ) async {
    var response =
        await crud.postData("https://dcduhok.shop/cashier/check_code.php", {
      "platform_code": platFormCode,
      "register_code": registerCode,
    });
    return response.fold((l) => l, (r) => r);
  }

  registerData(
      String registerCode,
      String customerName,
      String customerUsername,
      String customerPhone,
      String customerEmail,
      String customerPassword,
      String platFormCode,
      String platform,
      File file) async {
    var response = await crud.addRequestWithOneFile(
        "https://dcduhok.shop/cashier/register.php",
        {
          "platform_code": platFormCode,
          "register_code": registerCode,
          "register_platform": platform,
          "customer_name": customerName,
          "customer_username": customerUsername,
          "customer_phone": customerPhone,
          "customer_email": customerEmail,
          "customer_password": customerPassword,
        },
        file);
    return response.fold((l) => l, (r) => r);
  }

  loginData(
    String registerCode,
    String customerEmail,
    String customerPassword,
    String platFormCode,
    String platform,
  ) async {
    var response =
        await crud.postData("https://dcduhok.shop/cashier/login.php", {
      "platform_code": platFormCode,
      "register_code": registerCode,
      "register_platform": platform,
      "customer_email": customerEmail,
      "customer_password": customerPassword,
    });
    return response.fold((l) => l, (r) => r);
  }

  verifyAccount(String registerCode, String verifyCode) async {
    var response = await crud.postData(
        "https://dcduhok.shop/cashier/verify_code.php",
        {"register_code": registerCode, "verify_code": verifyCode});
    return response.fold((l) => l, (r) => r);
  }

  resendCode(String email) async {
    var response = await crud.postData(
        "https://dcduhok.shop/cashier/resend_code.php", {"email": email});
    return response.fold((l) => l, (r) => r);
  }

  storeBackup(String registerCode, File file) async {
    var response = await crud.addRequestWithOneFile(
        "https://dcduhok.shop/cashier/store_backup.php",
        {
          "register_code": registerCode,
        },
        file);
    return response.fold((l) => l, (r) => r);
  }

  restoreBackup(String registerCode) async {
    var response =
        await crud.postData("https://dcduhok.shop/cashier/restore_backup.php", {
      "register_code": registerCode,
    });
    return response.fold((l) => l, (r) => r);
  }
}
