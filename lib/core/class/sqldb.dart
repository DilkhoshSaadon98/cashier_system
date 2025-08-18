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
            version: 2,
            onCreate: _onCreate,
            onUpgrade: (db, oldVersion, newVersion) {
              return _onUpgrade(db, oldVersion, newVersion);
            },
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
    Database? myDb = await db;
    if (oldVersion < newVersion) {
      myDb.rawQuery("DROP VIEW view_items");
      myDb.rawQuery('''
CREATE VIEW view_items AS
SELECT
    i.item_id,
    i.item_name,
    i.item_description,
    i.item_buying_price,
    i.item_cost_price,
    i.item_wholesale_price,
    i.item_count,
    i.item_category_id,
    i.item_image,
    i.item_create_date,
    i.item_production_date,
    i.item_expiry_date,
    mu.item_price AS main_unit_price,
    mu.item_barcode AS main_unit_barcode,
    un.base_unit_name AS main_unit_name,
    mu.unit_id AS main_unit_id,
    ca.categories_name,
    (
        SELECT json_group_array(
                json_object(
                    'unit_id', up.unit_id, 'unit_name', un2.base_unit_name, 'price', up.item_price, 'barcode', up.item_barcode, 'factor', up.factor
                )
            )
        FROM
            tbl_units_price up
            LEFT JOIN tbl_units un2 ON up.unit_id = un2.unit_id
        WHERE
            up.item_id = i.item_id
            AND up.unit_id != mu.unit_id
    ) AS alt_units
FROM
    tbl_items i
    LEFT JOIN tbl_units_price mu ON i.item_id = mu.item_id
    AND mu.unit_id = i.unit_id
    LEFT JOIN tbl_units un ON mu.unit_id = un.unit_id
    LEFT JOIN tbl_categories ca ON ca.categories_id = i.item_category_id
''');
    }
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

  Future<int> updateDataAllowNull(
      String table, Map<String, dynamic> data, String where) async {
    Database? myDb = await db;
    // Build SQL that handles null values
    final sets = data.entries.map((e) {
      if (e.value == null) {
        return '${e.key} = NULL';
      } else {
        return '${e.key} = ?';
      }
    }).join(', ');

    // Only bind non-null values
    final values = data.values.where((v) => v != null).toList();

    final sql = 'UPDATE $table SET $sets WHERE $where';
    return await myDb!.rawUpdate(sql, values);
  }

  //! Delete Data:
  Future<int> deleteData(String table, String where, {bool json = true}) async {
    Database? myDb = await db;
    int count = await myDb!.delete(
      table,
      where: where,
    );
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
