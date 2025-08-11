import 'dart:io';

import 'package:cashier_system/core/class/crud.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/dev_config.dart';
import 'package:cashier_system/core/constant/screen_routes.dart';
import 'package:cashier_system/core/dialogs/custom_snack_bar.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/data/source/auth/register_class.dart';
import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class RegisterController extends GetxController {
  bool alreadyHaveAccount = false;
  SqlDb sqlDb = SqlDb();
  String? platform = "unknown";
  String? model = "unknown";
  RegisterClass registerClass = RegisterClass(Get.put(Crud()));
  TextEditingController otpController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerPhoneController = TextEditingController();
  TextEditingController customerPasswordController = TextEditingController();
  TextEditingController customerUsernameController = TextEditingController();
  TextEditingController customerEmailController = TextEditingController();
  TextEditingController verifyCodeController = TextEditingController();
  GlobalKey<FormState> formStateRegister = GlobalKey<FormState>();
  GlobalKey<FormState> formVerifyAccount = GlobalKey<FormState>();
  bool showPasswordData = false;
  void changePasswordShowing() {
    showPasswordData = !showPasswordData;
    update();
  }

  bool showOtpData = false;
  void changeOtpShowing() {
    showOtpData = !showOtpData;
    update();
  }

  File? file;
  Future<void> loadAssetAsFile() async {
    // Load the asset file as bytes
    final byteData = await rootBundle.load('assets/cashier_system.db');
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/cashier_system.db');
    await tempFile.writeAsBytes(byteData.buffer.asUint8List());
    file = tempFile;
  }

  Map<String, Map<String, dynamic>> inputData = {
    "otp": {
      "label": "OTP",
      "icon": Icons.code,
    },
    "customer_name": {
      "label": "Customer Name",
      "icon": Icons.person_4_outlined
    },
    "customer_phone": {
      "label": "Customer Phone",
      "icon": Icons.phone_outlined,
    },
    "customer_email": {
      "label": "E-mail",
      "icon": Icons.email_outlined,
    },
    "customer_password": {
      "label": "Password",
      "icon": Icons.security_outlined,
    },
  };
  void alreadyHaveAccounts(bool value) {
    alreadyHaveAccount = value;
    update();
  }

  Future<void> getDeviceInfo() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (GetPlatform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        model = androidInfo.model;
        platform = 'Android';
      } else if (GetPlatform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

        model = iosInfo.model;
        platform = 'iOS';
      } else if (GetPlatform.isWindows) {
        WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
        model = windowsInfo.deviceId;
        platform = "Windows";
      }
      update();
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error fetching device info");
    }
  }

  Future<void> register() async {
    try {
      loadAssetAsFile();
      if (formStateRegister.currentState!.validate()) {
        // Development mode bypass
        if (DevConfig.isDevelopmentMode && otpController.text.trim() == DevConfig.devOtpCode) {
          await _createDevAccount();
          myServices.sharedPreferences.setString("step", "verify");
          Get.offAndToNamed(AppRoute.verifyAccountScreen);
          return;
        }
        
        //! Check Otp Code if Exist:
        var response =
            await registerClass.checkData(otpController.text.trim(), model!);
        //! IF Exist true:
        if (response['status'] == "success") {
          //? First Time Register(Account Not Activate):
          myServices.sharedPreferences
              .setString("register_code", response['data']['register_code']);
          myServices.sharedPreferences
              .setString("email", response['data']['customer_email']);
          if (response['data']['register_active'] == 0 &&
              response['data']['register_platform_id'] == null) {
            var registerData = await registerClass.registerData(
                otpController.text.trim(),
                customerNameController.text.trim(),
                customerUsernameController.text.trim(),
                customerPhoneController.text.trim(),
                customerEmailController.text.trim(),
                customerPasswordController.text.trim(),
                model!,
                platform!,
                file!);
            if (registerData['status'] == 'success') {
              myServices.sharedPreferences.setString("step", "verify");
              Get.offAndToNamed(AppRoute.verifyAccountScreen);
            } else {
              showErrorDialog(
                  registerData['message'] ??
                      "Error: otp code or user data not correct",
                  title: "Error",
                  message: registerData['message'] ??
                      "Error: otp code or user data not correct");
            }
          }
          //? Seconde Time Register(Account Activated):
          else if (response['data']['register_active'] == 1 ||
              alreadyHaveAccount == true) {
            var loginData = await registerClass.loginData(
              otpController.text.trim(),
              customerEmailController.text.trim(),
              customerPasswordController.text.trim(),
              model!,
              platform!,
            );
            if (loginData['status'] == 'success') {
              myServices.sharedPreferences.setString("step", "verify");
              Get.offAndToNamed(AppRoute.verifyAccountScreen);
            } else {
              showErrorDialog(
                  loginData['message'] ??
                      "Error: otp code or user data not correct",
                  title: "Error",
                  message: loginData['message'] ??
                      "Error: otp code or user data not correct");
            }
          } else {
            showErrorDialog("",
                title: "Error",
                message: "OTP Code Already Used Please Contact Seller");
          }
        }
        //! If Exist False:
        else {
          showErrorDialog("",
              title: "Error",
              message:
                  "The OTP code is not recognized. Please check and enter it again.");
        }
      }
    } catch (e) {
      showErrorDialog(e.toString(), title: "Error", message: "$e");
    } finally {
      update();
    }
  }

  Future<void> verifyAccount() async {
    try {
      // Development mode bypass
      if (DevConfig.isDevelopmentMode && verifyCodeController.text == DevConfig.devVerifyCode) {
        await _finalizeDevAccount();
        await myServices.sharedPreferences.setString("step", "login");
        Get.offAndToNamed(AppRoute.loginScreen);
        showLoginDialog();
        return;
      }
      
      //! Verify account with registerClass
      var response = await registerClass.verifyAccount(
        myServices.sharedPreferences.getString("register_code")!,
        verifyCodeController.text,
      );

      //! Check if the response is successful
      if (response['status'] == 'success') {
        // Query the database for matching admin credentials
        var query = """
        SELECT * FROM tbl_admins 
        WHERE admin_email = '${customerEmailController.text}' 
        AND admin_password = '${customerPasswordController.text}'
      """;
        var dataResponse = await sqlDb.getData(query);

        //! Insert data if the query result is empty (admin does not exist)
        if (dataResponse.isEmpty) {
          await sqlDb.insertData("tbl_admins", {
            "admin_name": customerNameController.text,
            "admin_username": "admin",
            "admin_email": customerEmailController.text,
            "admin_password": customerPasswordController.text,
            "admin_role": "Full Access",
            "admin_createdate": currentTime,
          });
        }

        //! Update shared preferences and navigate to the login screen
        await myServices.sharedPreferences.setString("step", "login");
        Get.offAndToNamed(AppRoute.loginScreen);

        //! Show a success dialog or message
        showLoginDialog();
      } else {
        throw Exception(
            "Account verification failed. Please check the verification code.");
      }
    } catch (e) {
      // Handle and display error messages
      showErrorDialog(
        e.toString(),
        title: "Error",
        message: "An error occurred during account verification: $e",
      );
    }
  }

  Future<void> resendCode() async {
    try {
      //! Verify account with registerClass
      var response = await registerClass
          .resendCode(myServices.sharedPreferences.getString("email")!);
      //! Check if the response is successful
      if (response['status'] == 'success') {
        customSnackBar("Success", "verify code resend success");
      } else {
        throw Exception(
            "Account verification failed. Please check the verification code.");
      }
    } catch (e) {
      // Handle and display error messages
      showErrorDialog(
        e.toString(),
        title: "Error",
        message: "An error occurred during account verification: $e",
      );
    }
  }

  void showLoginDialog() {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Login Details',
            style: titleStyle,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "username: admin",
                style: titleStyle,
              ),
              Text(
                "password: (your account password)",
                style: titleStyle,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text(
                'Confirm',
                style: titleStyle,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _createDevAccount() async {
    // Set development account data
    customerNameController.text = "Development User";
    customerUsernameController.text = "dev_admin";
    customerEmailController.text = "dev@example.com";
    customerPasswordController.text = DevConfig.devPassword;
    myServices.sharedPreferences.setString("register_code", "DEV_CODE");
    myServices.sharedPreferences.setString("email", "dev@example.com");
  }

  Future<void> _finalizeDevAccount() async {
    var query = """
      SELECT * FROM tbl_admins 
      WHERE admin_email = 'dev@example.com' 
      AND admin_password = '${DevConfig.devPassword}'
    """;
    var dataResponse = await sqlDb.getData(query);

    if (dataResponse.isEmpty) {
      await sqlDb.insertData("tbl_admins", {
        "admin_name": "Development User",
        "admin_username": "dev_admin",
        "admin_email": "dev@example.com",
        "admin_password": DevConfig.devPassword,
        "admin_role": "Full Access",
        "admin_createdate": currentTime,
      });
    }
  }

  List<TextEditingController>? controllerList = [];
  @override
  void onInit() {
    getDeviceInfo();
    controllerList = [
      otpController,
      customerNameController,
      customerPhoneController,
      customerEmailController,
      customerPasswordController,
    ];
    super.onInit();
  }
}
