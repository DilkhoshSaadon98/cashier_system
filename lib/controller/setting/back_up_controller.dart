import 'dart:async';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/shared/custom_snack_bar.dart';
import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

class BackUpController extends GetxController {
  String databaseName = "cashier_system.db";
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
    String backupTime =
        myServices.sharedPreferences.getString("next_backup") ?? '00:15';
    if (timeOptions.contains(backupTime)) {
      selectedTime = backupTime;
    } else {
      selectedTime = '00:15';
    }
    selectedFolderPath = myServices.sharedPreferences.getString("backup_path");

    DateTime now = DateTime.now();
    List<String> timeParts = selectedTime.split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    DateTime backupDateTime =
        DateTime(now.year, now.month, now.day, hour, minute);

    print('Backup time loaded: $backupDateTime');
  }

  void scheduleBackup() {
    if (myServices.sharedPreferences.getBool("auto_back_up") == true) {
      if (backupTimer != null) {
        backupTimer!.cancel();
      }
      final parts = selectedTime.split(':');
      print("parts : $parts");
      final int hours = int.parse(parts[0]);
      final int minutes = int.parse(parts[1]);

      DateTime now = DateTime.now();
      print("now : $now");
      DateTime nextBackupTime =
          DateTime(now.year, now.month, now.day, hours, minutes);

      // If the next backup time is in the past, schedule it for the next occurrence
      if (nextBackupTime.isBefore(now)) {
        print("======");
        nextBackupTime = nextBackupTime.add(Duration(days: 1));
      }
      print("nextBackupTime : $nextBackupTime");
      Duration durationUntilNextBackup = nextBackupTime.difference(now);
      print('Next backup scheduled in: $durationUntilNextBackup');

      backupTimer = Timer(durationUntilNextBackup, () async {
        await saveCopyToDirectory();
        print("+++++++++++++++++++++++++++++++++++++++++++++");
        scheduleBackup(); // Reschedule the backup after completion
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
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, databaseName);

      if (!await File(path).exists()) {
        await _copyDatabaseFromAssets(path);
      }

      if (selectedFolderPath == null) {
        customSnackBar("Error", "Backup path not set");
        return;
      }

      String newFilePath = join(selectedFolderPath!, "cashier_system.db");

      if (await File(newFilePath).exists()) {
        await File(newFilePath).delete();
      }

      await File(path).copy(newFilePath);

      String backupTime = DateTime.now().toString();

      await myServices.sharedPreferences
          .setString("backup_path", selectedFolderPath!);
      await myServices.sharedPreferences.setString("backup_time", backupTime);

      customSnackBar("Success", 'Backup done successfully');
    } catch (e) {
      print(e);
      customSnackBar("Error", 'Error saving database copy: $e');
    }
  }

  Future<void> _copyDatabaseFromAssets(String path) async {
    ByteData data = await rootBundle.load('assets/$databaseName');
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes);
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

      customSnackBar("Success", 'Database restored successfully');
    } catch (e) {
      customSnackBar("Error", 'Error during database restore: $e');
    }
  }
}
