import 'dart:async';
import 'dart:convert';
import 'package:cashier_system/core/class/crud.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/core/dialogs/custom_snack_bar.dart';
import 'package:cashier_system/data/source/auth/register_class.dart';
import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

import 'package:http/http.dart' as http;

class BackUpController extends GetxController {
  //? Data Define :
  String databaseName = "cashier_system.db";
  Timer? backupTimer;
  String selectedTime = '00:00';
  String? selectedFolderPath;
  SqlDb sqlDb = SqlDb();
  //? Divide Time:
  final List<String> timeOptions = List.generate(24 * 4, (index) {
    final int hours = index ~/ 4;
    final int minutes = (index % 4) * 15;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  });

  //? Set Backup to automatic:
  void autoBackup(bool val) {
    myServices.sharedPreferences.setBool("auto_back_up", val);
    update();
  }

  //? Change Next Backup Period:
  void changeTime(String value) {
    selectedTime = value;
    myServices.sharedPreferences.setString("next_backup", selectedTime);
    update();
    scheduleBackup();
  }

  //? Load Backup Time :
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

    DateTime(now.year, now.month, now.day, hour, minute);
  }

  void scheduleBackup() {
    if (myServices.sharedPreferences.getBool("auto_back_up") == true) {
      if (backupTimer != null) {
        backupTimer!.cancel();
      }
      final parts = selectedTime.split(':');
      final int hours = int.parse(parts[0]);
      final int minutes = int.parse(parts[1]);

      DateTime now = DateTime.now();
      DateTime nextBackupTime =
          DateTime(now.year, now.month, now.day, hours, minutes);

      // If the next backup time is in the past, schedule it for the next occurrence
      if (nextBackupTime.isBefore(now)) {
        nextBackupTime = nextBackupTime.add(const Duration(days: 1));
      }
      Duration durationUntilNextBackup = nextBackupTime.difference(now);

      backupTimer = Timer(durationUntilNextBackup, () async {
        await saveCopyToDirectory();
        scheduleBackup();
      });
    }

    update();
  }

  //? Get path for Backup:
  Future<void> pickFolder() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      selectedFolderPath = selectedDirectory;
      myServices.sharedPreferences
          .setString("backup_path", selectedFolderPath!);
      update();
    }
  }

  //? Backup Function:
  Future<void> saveCopyToDirectory() async {
    try {
      if (Platform.isWindows) {
        // For Windows, use the Documents directory
        Directory documentsDirectory = await getApplicationDocumentsDirectory();
        String path = join(documentsDirectory.path, 'cashier_system.db');

        // Check if the file exists and copy it if necessary
        if (await File(path).exists()) {
          String newFilePath =
              join(documentsDirectory.path, 'backup_cashier_system.db');
          await File(path).copy(newFilePath);
        }
      } else if (Platform.isAndroid) {
        // For Android, handle scoped storage or external storage permission
        await requestStoragePermission();

        Directory documentsDirectory = await getApplicationDocumentsDirectory();
        String path = join(documentsDirectory.path, 'cashier_system.db');

        String backupDirPath = '/storage/emulated/0/Mr robot/';
        String newFilePath = join(backupDirPath, 'cashier_system.db');

        final backupDir = Directory(backupDirPath);
        if (!await backupDir.exists()) {
          await backupDir.create(recursive: true);
        }

        if (await File(newFilePath).exists()) {
          await File(newFilePath).delete();
        }

        await File(path).copy(newFilePath);
        String backupTime =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
        await myServices.sharedPreferences
            .setString('backup_path', backupDirPath);
        await myServices.sharedPreferences.setString('backup_time', backupTime);
      }
    } catch (e) {
      showErrorDialog("Error during save to file to directory",
          title: "Error", message: "Error during save to file to directory");
    }
  }

  RegisterClass registerClass = RegisterClass(Get.put(Crud()));
  //? Backup Function:
  Future<void> saveCopyToCloud() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, 'cashier_system.db');

      if (await File(path).exists()) {
        String newFilePath = join(documentsDirectory.path, 'cashier_system.db');
        final tempFile = File(newFilePath);
        var response = await registerClass.storeBackup(
            myServices.sharedPreferences.getString("register_code") ?? '',
            tempFile);
        if (response['status'] == 'success') {
          customSnackBar("Success", "Backup done success");
        } else {
          customSnackBar("Fail", "Backup Fail");
        }
      }
    } catch (e) {
      showErrorDialog("Error during save to file to directory",
          title: "Error", message: "Error during save to file to directory");
    }
  }

  Future<void> requestStoragePermission() async {
    if (await Permission.manageExternalStorage.request().isGranted) {
      showErrorDialog("Permission granted to manage external storage",
          title: "Error",
          message: "Permission granted to manage external storage");
    } else {
      openAppSettings();
      showErrorDialog("Permission denied",
          title: "Error", message: "Permission denied");
    }
  }

  //? Restore Database :
  Future<void> restoreDatabase() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowedExtensions: ['db'],
      );

      if (result == null) {
        return;
      }

      String selectedFilePath = result.files.single.path!;
      String databasePath = join("assets", sqlDb.databaseName);
      Database? dbInstance = await sqlDb.db;
      await dbInstance!.close();
      if (await File(databasePath).exists()) {
        File(databasePath).deleteSync();
      }
      File(selectedFilePath).copySync(databasePath);

      customSnackBar("Success", 'Database restored successfully');
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: 'Error during database restore');
    }
  }

  Future<void> restoreDatabaseFromCloud() async {
    try {
      // Fetch file path from the server
      var registerCode =
          myServices.sharedPreferences.getString("register_code") ?? "";
      var fileName = "cashier_system.db"; // Replace with the exact file name

      String _basicAuth =
          'Basic ${base64Encode(utf8.encode('dddd:sdfsdfsdfsdfdsf'))}';
      // Construct the file download URL
      var fileDownloadUrl = "https://dcduhok.shop/cashier/restore_backup.php";

      // Perform a POST request to retrieve the file
      var response = await http.post(
        Uri.parse(fileDownloadUrl),
        body: {"register_code": registerCode, "file_name": fileName},
        headers: {'authorization': _basicAuth}, // Add headers if needed
      );

      if (response.statusCode == 200) {
        // Get the application's documents directory
        const directory = "/storage/emulated/0/Mr robot";

        // Create a file in the directory
        final filePath = '$directory/$fileName';
        final file = File(filePath);

        // Write the file's bytes to the local file
        await file.writeAsBytes(response.bodyBytes);
        customSnackBar(
            "Success", "Database restored successfully: $filePath", true);
      } else {
        showErrorDialog(
          "",
          title: "Error",
          message: "Failed to download the file: ${response.statusCode}",
        );
      }
    } catch (e) {
      showErrorDialog(
        e.toString(),
        title: "Error",
        message: "Error during database restore from host",
      );
    }
  }

  @override
  void onClose() {
    backupTimer?.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    loadBackupTime();
    scheduleBackup();
  }
}
