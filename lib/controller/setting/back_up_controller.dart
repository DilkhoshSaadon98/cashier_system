import 'dart:io';

import 'package:cashier_system/controller/setting/setting_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/shared/custom_snack_bar.dart';
import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:cashier_system/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BackUpController extends SettingController {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  SqlDb sqlDb = SqlDb();
  String selectedTime = '00:00';
  final List<String> timeOptions = List.generate(24 * 4, (index) {
    final int hours = index ~/ 4;
    final int minutes = (index % 4) * 15;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  });
  changeTime(String value) {
    selectedTime = value;
    update();
  }

  String? selectedFolderPath;
  Future<void> pickFolder() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      selectedFolderPath = selectedDirectory;
      myServices.sharedPreferences
          .setString("backup_path", selectedFolderPath!);
      update();
    } else {}
  }

  Future<void> saveCopyToDirectory() async {
    try {
      String databasePath = await getDatabasesPath();
      selectedFolderPath = await FilePicker.platform.getDirectoryPath();
      if (selectedFolderPath == null) {
        return;
      }
      String newFilePath = join(selectedFolderPath!, "cashier_system.db");
      await File(join(databasePath, "cashier_system.db")).copy(newFilePath);
      myServices.sharedPreferences
          .setString("backup_path", selectedFolderPath!);
      myServices.sharedPreferences.setString("backup_time", currentTime);
      customSnackBar("Success", 'Backup Done Success');
    } catch (e) {
      customSnackBar("Error", 'Error saving database copy: $e');
    }
    update();
  }

  Future<void> restoreDatabase() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['db'],
      );

      if (result == null) {
        return;
      }

      String selectedFilePath = result.files.single.path!;
      String databasePath = join(await getDatabasesPath(), sqlDb.databaseName);
      Database? dbInstance = await sqlDb.db;
      await dbInstance!.close();
      if (await File(databasePath).exists()) {
        await File(databasePath).delete();
      }
      await File(selectedFilePath).copy(databasePath);
      sqlDb = SqlDb();
      //restartApp();
      Get.offAll(const MyApp());
    } catch (e) {
      customSnackBar("Error", 'Error during database restore: $e');
    }
  }

  void restartApp() {
    navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MyApp()),
      (Route<dynamic> route) => false,
    );
  }
}
