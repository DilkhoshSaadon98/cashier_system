import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SqlDb {
  String databaseName = "cashier_system.db";
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDb();
      return _db;
    } else {
      return _db;
    }
  }

  Future<Database?> initialDb() async {
    try {
      if (Platform.isWindows || Platform.isLinux) {
        sqfliteFfiInit();
        final databaseFactory = databaseFactoryFfi;
        final appDocumentsDir = await getApplicationDocumentsDirectory();
        final dbPath = join(appDocumentsDir.path, databaseName);

        if (!await File(dbPath).exists()) {
          await _copyDatabaseFromAssets(dbPath);
        }

        final winLinuxDB = await databaseFactory.openDatabase(
          dbPath,
          options: OpenDatabaseOptions(
            version: 1,
            onCreate: _onCreate,
          ),
        );
        return winLinuxDB;
      } else if (Platform.isAndroid || Platform.isIOS) {
        final documentsDirectory = await getApplicationDocumentsDirectory();
        final path = join(documentsDirectory.path, databaseName);

        if (!await File(path).exists()) {
          await _copyDatabaseFromAssets(path);
        }

        final iOSAndroidDB = await openDatabase(
          path,
          version: 1,
          onCreate: _onCreate,
        );
        return iOSAndroidDB;
      }

      throw Exception("Unsupported platform");
    } catch (e) {
      // Log the error
      showErrorDialog(e.toString(),
          title: "Error", message: "Error initializing database");
      return null;
    }
  }

  Future<void> _copyDatabaseFromAssets(String path) async {
    try {
      final ByteData data = await rootBundle.load('assets/$databaseName');
      final List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      final file = File(path);
      await file.writeAsBytes(bytes);
    } catch (e) {
      // Log the error
      showErrorDialog(e.toString(),
          title: "Error", message: "Error copying database from assets");
    }
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {}
  }

  _onCreate(Database db, int version) async {
    await _onUpgrade(db, 0, version);
  }

  //! Update Data:
  Future<int> updateData(String table, Map<String, dynamic> data, String where,
      {bool json = true}) async {
    Database? myDb = await db;
    List<String> cols = [];
    List<dynamic> vals = [];

    data.forEach((key, val) {
      // Skip NULL values
      if (val != null) {
        vals.add(val); // Collecting non-NULL values
        cols.add("`$key` = ?"); // Building column names with placeholders
      }
    });

    String sql = "UPDATE $table SET ${cols.join(', ')}  WHERE $where";
    int count = await myDb!
        .rawUpdate(sql, vals); // Executing update with non-NULL values

    return count;
  }

  //! Delete Data:
  Future<int> deleteData(String table, String where, {bool json = true}) async {
    Database? myDb = await db;
    int count = await myDb!.delete(table, where: where,);
    return count;
  }

  Future<dynamic> getData(String sql) async {
    Database? myDb = await db;
    List<Map<String, dynamic>> data = [];
    data = await myDb!.rawQuery(sql);
    return data;
  }

  //! Get Data:
  Future<Map<String, dynamic>> getAllData(String table,
      {String? where, List<dynamic>? values, bool json = true}) async {
    List<Map<String, dynamic>> data = [];
    int count = 0;
    Database? myDb = await db;

    if (where == null) {
      data = await myDb!.rawQuery("SELECT * FROM $table");
    } else {
      data = await myDb!.query(table, where: where, whereArgs: values);
    }

    count = data.length;

    if (json) {
      if (count > 0) {
        return {
          "status": "success",
          "data": jsonDecode(jsonEncode(data)),
        };
      } else {
        return {
          "status": "failure",
        };
      }
    } else {
      if (count > 0) {
        return {
          "status": "success",
          "data": jsonDecode(jsonEncode(data)),
        };
      } else {
        return {
          "status": "failure",
        };
      }
    }
  }

  //!Insert Data:
  Future<int> insertData(String table, Map<String, dynamic> data,
      {bool json = true}) async {
    Database? myDb = await db;
    List<String> placeholders = [];
    List<dynamic> values = [];
    data.forEach((key, value) {
      placeholders.add('?');
      values.add(value);
    });

    String fields = data.keys.join(',');
    String placeholdersStr = placeholders.join(',');

    String sql = "INSERT INTO $table ($fields) VALUES ($placeholdersStr)";

    int count = await myDb!.rawInsert(sql, values);
    return count;
  }
}
