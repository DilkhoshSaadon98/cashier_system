import 'dart:async';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/shared/custom_snack_bar.dart';
import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:sqflite/sqflite.dart';

class BackUpController extends GetxController {
  Timer? backupTimer;
  String selectedTime = '00:00';
  final List<String> timeOptions = List.generate(24 * 4, (index) {
    final int hours = index ~/ 4;
    final int minutes = (index % 4) * 15;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  });

  String? selectedFolderPath;
  SqlDb sqlDb = SqlDb();

  @override
  void onInit() {
    super.onInit();
    loadBackupTime();
    scheduleBackup();
  }

  void autoBackup(bool val) {
    myServices.sharedPreferences.setBool("auto_back_up", val);
    update();
  }

  void changeTime(String value) {
    selectedTime = value;
    myServices.sharedPreferences.setString("next_backup", selectedTime);
    update();
    scheduleBackup();
  }

  Future<void> loadBackupTime() async {
    // Load the backup time from shared preferences
    String backupTime =
        myServices.sharedPreferences.getString("next_backup") ?? '00:15';
    // Validate the loaded time
    if (timeOptions.contains(backupTime)) {
      selectedTime = backupTime;
    } else {
      selectedTime = '00:15';
    }
    selectedFolderPath = myServices.sharedPreferences.getString("backup_path");

    DateTime now = DateTime.now();
    List<String> timeParts = selectedTime.split(':');
    print(timeParts);
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    DateTime backupDateTime =
        DateTime(now.year, now.month, now.day, hour, minute);

    // Log the loading time
    print('Backup time loaded: $backupDateTime');
  }

  void scheduleBackup() {
    if (myServices.sharedPreferences.getBool("auto_back_up") == true &&
        myServices.sharedPreferences.getBool("auto_back_up") != null) {
      if (backupTimer != null) {
        backupTimer!.cancel();
      }

      final parts = selectedTime.split(':');
      final hours = int.parse(parts[0]);
      final minutes = int.parse(parts[1]);

      DateTime now = DateTime.now();
      DateTime nextBackupTime =
          DateTime(now.year, now.month, now.day, now.hour, now.minute);

      // If the next backup time is in the past, schedule it for the next day
      if (nextBackupTime.isBefore(now)) {
        nextBackupTime =
            nextBackupTime.add(Duration(hours: hours, minutes: minutes));
      }
      print(nextBackupTime);
      Duration durationUntilNextBackup = nextBackupTime.difference(now);
      backupTimer = Timer(durationUntilNextBackup, () async {
        await saveCopyToDirectory();
        scheduleBackup();
      });
    }

    update();
  }

  Future<void> pickFolder() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      selectedFolderPath = selectedDirectory;
      myServices.sharedPreferences
          .setString("backup_path", selectedFolderPath!);
      update();
    }
  }

  Future<void> saveCopyToDirectory() async {
    try {
      String databasePath = await getDatabasesPath();
      if (selectedFolderPath == null) {
        customSnackBar("Error", "Backup path not set");
        return;
      }
      String newFilePath = join(selectedFolderPath!, "cashier_system.db");

      // Check if the backup file already exists and delete it
      if (await File(newFilePath).exists()) {
        File(newFilePath).deleteSync();
      }

      // Copy the database file to the backup path
      File(join(databasePath, "cashier_system.db")).copySync(newFilePath);

      // Save the backup path and time to shared preferences
      myServices.sharedPreferences
          .setString("backup_path", selectedFolderPath!);
      myServices.sharedPreferences.setString("backup_time", currentTime);

      //  customSnackBar("Success", 'Backup Done Success');
    } catch (e) {
      print(e);
      customSnackBar("Error", 'Error saving database copy: $e');
    }
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
    } catch (e) {
      customSnackBar("Error", 'Error during database restore: $e');
    }
  }
}
