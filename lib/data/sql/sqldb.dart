import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart' show rootBundle;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

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

  initialDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, databaseName);
    if (!await File(path).exists()) {
      await _copyDatabaseFromAssets(path);
    }
    Database myDb = await openDatabase(
      path,
      onCreate: _onCreate,
      version: 2,
      onUpgrade: _onUpgrade,
    );
    return myDb;
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      //! Table Categories
      await db.execute('''
      CREATE TABLE IF NOT EXISTS "tbl_types" (
        "type_id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "type_name" TEXT NOT NULL,
        "type_createdate" TEXT NOT NULL
      )
      ''');
      //! Table Types
      await db.execute('''
      CREATE TABLE IF NOT EXISTS "tbl_categories" (
        "categories_id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "categories_name" TEXT NOT NULL,
        "categories_createdate" TEXT NOT NULL
      )
      ''');
      //! Table Admins
      await db.execute('''
CREATE TABLE "tbl_admins" (
    "admin_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "admin_name" TEXT NOT NULL,
    "admin_username" TEXT NOT NULL,
    "admin_email" TEXT NOT NULL,
    "admin_password" TEXT NOT NULL,
    "admin_role" TEXT NOT NULL,
    "admin_approve" TEXT NOT NULL DEFAULT "0",
    "admin_createdate" TEXT NOT NULL
)
      ''');
      //! Table Items
      await db.execute('''
     CREATE TABLE "tbl_items" (
    "items_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "items_name" TEXT NOT NULL,
    "items_barcode" TEXT NOT NULL,
    "items_selling" int NOT NULL,
    "items_buingprice" int NOT NULL,
    "items_wholesaleprice" int NOT NULL,
    "items_count" int NOT NULL,
    "items_costprice" int NOT NULL,
    "items_desc" TEXT NOT NULL,
    "items_createdate" TEXT NOT NULL,
    "items_cat" INTEGER NOT NULL,
    "items_type" INTEGER NOT NULL,
    FOREIGN KEY (items_type) REFERENCES tbl_types (type_id),
    FOREIGN KEY (items_cat) REFERENCES tbl_categories (categories_id)
)
      ''');
//! Table Users
      await db.execute('''
      CREATE TABLE "tbl_users" (
    "users_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "users_name" TEXT NOT NULL,
    "users_email" TEXT,
    "users_phone2" TEXT,
    "users_phone" TEXT NOT NULL,
    "users_address" TEXT NOT NULL,
    "users_role" TEXT NOT NULL,
    "users_createdate" TEXT NOT NULL,
    "users_note" TEXT
)
      ''');
//! Table Cart
      await db.execute('''
CREATE TABLE "tbl_cart" (
    "cart_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "cart_items_id" INTEGER NOT NULL,
    "cart_orders" INTEGER NOT NULL DEFAULT 0,
    "cart_number" INTEGER NOT NULL DEFAULT 0,
    "cart_item_discount" INTEGER NOT NULL DEFAULT 0,
    "cart_discount" INTEGER NOT NULL DEFAULT 0,
    "cart_item_gift" INTEGER NOT NULL DEFAULT 0,
    "cart_owner" TEXT DEFAULT 'UNKNOWN',
    "cart_items_count" INTEGER NOT NULL,
    "cart_create_date" TEXT NOT NULL,
    "cart_status" TEXT NOT NULL DEFAULT 'review',
    "cart_tax" TEXT DEFAULT '0',
    "cart_cash" TEXT DEFAULT '1',
    "cart_update" INT DEFAULT 0,
    FOREIGN KEY (cart_items_id) REFERENCES tbl_items (items_id)
)
      ''');
//! Table invoice
      await db.execute('''
CREATE TABLE "tbl_invoice" (
    "invoice_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "invoice_user_id" INTEGER NOT NULL,
    "invoice_tax" INTEGER NOT NULL,
    "invoice_discount" INTEGER NOT NULL,
    "invoice_price" INTEGER NOT NULL,
    "invoice_cost" INTEGER NOT NULL,
    "invoice_items_number" INTEGER NOT NULL,
    "invoice_payment" TEXT NOT NULL,
    "invoice_createdate" TEXT NOT NULL,
    invoice_organizer TEXT NOT NULL,
    FOREIGN KEY (invoice_user_id) REFERENCES tbl_users (users_id)
)
      ''');
//! Table import
      await db.execute('''
      CREATE TABLE IF NOT EXISTS "tbl_import" (
        "import_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        "import_supplier_id" INTEGER NOT NULL,
        "import_amount" INTEGER NOT NULL,
        "import_account" TEXT NOT NULL,
        "import_note" TEXT NOT NULL,
        "import_create_date" TEXT NOT NULL
      )
      ''');
//! Table Export
      await db.execute('''
      CREATE TABLE IF NOT EXISTS "tbl_export" (
        "export_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        "export_supplier_id" INTEGER NOT NULL,
        "export_amount" INTEGER NOT NULL,
        "export_account" TEXT NOT NULL,
        "export_note" TEXT NOT NULL,
        "export_create_date" TEXT NOT NULL
      )
      ''');
      //! Table Purchase
      await db.execute('''
     CREATE TABLE tbl_purchase (
    "purchase_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "purchase_items_id" INTEGER NOT NULL,
    "purchase_price" TEXT NOT NULL,
    "purchase_quantity" INTEGER NOT NULL,
    "purchase_total_price" TEXT NOT NULL,
    "purchase_payment" TEXT NOT NULL,
    "purchase_supplier_id" INTEGER NOT NULL,
    "purchase_discount" INT NOT NULL,
    "purchase_date" DATETIME NOT NULL,
    "purchase_number" INT NOT NULL DEFAULT 0,
    FOREIGN KEY (purchase_items_id) REFERENCES tbl_items (items_id)
)
        ''');
//! View Cart
      await db.execute('''
      CREATE VIEW IF NOT EXISTS cartview AS
      SELECT SUM(
              CAST(
                  tbl_items.items_selling - tbl_items.items_selling * tbl_cart.cart_item_discount / 100 AS INT
              )
          ) AS items_price_discount, tbl_cart.*, tbl_items.*
      FROM tbl_cart
          INNER JOIN tbl_items ON tbl_items.items_id = tbl_cart.cart_items_id
      WHERE
          cart_orders = 0
      GROUP BY
          tbl_cart.cart_items_id,
          tbl_cart.cart_number,
          tbl_cart.cart_orders
      ''');
//! View Export
      await db.execute('''
      CREATE VIEW IF NOT EXISTS exportDetailsView AS
      SELECT tbl_users.*, tbl_export.*
      FROM tbl_users
          JOIN tbl_export ON tbl_users.users_id = tbl_export.export_supplier_id
      ''');
//! View Import
      await db.execute('''
      CREATE VIEW IF NOT EXISTS importDetailsView AS
      SELECT tbl_users.*, tbl_import.*
      FROM tbl_users
          JOIN tbl_import ON tbl_users.users_id = tbl_import.import_supplier_id
      ''');
//! View Items
      await db.execute('''
      CREATE VIEW IF NOT EXISTS itemsView AS
      SELECT tbl_items.*, tbl_categories.categories_name, tbl_types.type_name
      FROM
          tbl_items
          INNER JOIN tbl_categories ON tbl_items.items_cat = tbl_categories.categories_id
          INNER JOIN tbl_types ON tbl_items.items_type = tbl_types.type_id
      GROUP BY
          tbl_items.items_id,
          tbl_categories.categories_id,
          tbl_types.type_id
      ''');
// //! View Profits
//       await db.execute('''
//       CREATE VIEW totalProfitView AS
// WITH
//     CombinedInvoices AS (
//         SELECT
//             'Cash' AS invoice_source_table,
//             tbl_invoice.invoice_price AS invoice_price,
//             tbl_invoice.invoice_createdate AS invoice_createdate,
//             tbl_invoice.invoice_id AS invoice_row_id
//         FROM tbl_invoice
//         WHERE
//             tbl_invoice.invoice_payment = 'Cash'
//         UNION ALL
//         SELECT
//             'Export' AS invoice_source_table,
//             tbl_export.export_amount AS invoice_price,
//             tbl_export.export_create_date AS invoice_createdate,
//             tbl_export.export_id AS invoice_row_id
//         FROM tbl_export
//         WHERE
//             tbl_export.export_account = 'Expenses'
//     )
// SELECT
//     invoice_source_table,
//     invoice_price,
//     invoice_createdate,invoice_row_id,
//     ROW_NUMBER() OVER (
//         ORDER BY invoice_createdate
//     ) AS invoice_id
// FROM CombinedInvoices
//       ''');
// //! View Box
//       await db.execute('''
//       CREATE VIEW boxView AS
// WITH
//     CombinedInvoices AS (
//         SELECT
//             'Cash' AS invoice_source_table,
//             tbl_invoice.invoice_price AS invoice_price,
//             tbl_invoice.invoice_createdate AS invoice_createdate,
//             tbl_invoice.invoice_id AS invoice_row_id
//         FROM tbl_invoice
//         WHERE
//             tbl_invoice.invoice_payment = 'Cash'
//         UNION ALL
//         SELECT
//             'Import' AS invoice_source_table,
//             tbl_import.import_amount AS invoice_price,
//             tbl_import.import_create_date AS invoice_createdate,
//             tbl_import.import_id AS invoice_row_id
//         FROM tbl_import
//         UNION ALL
//         SELECT
//             'Export' AS invoice_source_table,
//             tbl_export.export_amount AS invoice_price,
//             tbl_export.export_create_date AS invoice_createdate,
//             tbl_export.export_id AS invoice_row_id
//         FROM tbl_export
//     )
// SELECT
//     invoice_source_table,
//     invoice_price,
//     invoice_createdate,
//     invoice_row_id,
//     ROW_NUMBER() OVER (
//         ORDER BY invoice_createdate
//     ) AS 'invoice_id'
// FROM CombinedInvoices
//       ''');
//! View Invoice
      await db.execute('''
      CREATE VIEW IF NOT EXISTS invoiceView AS
      SELECT tbl_invoice.*
      FROM tbl_invoice
      LEFT JOIN tbl_users ON tbl_invoice.invoice_user_id = tbl_users.users_id
      ''');
//! View Purchaes
      await db.execute('''
    CREATE VIEW purchaseView AS
SELECT tbl_purchase.*, tbl_users.users_name, tbl_items.items_name
FROM
    tbl_purchase
    INNER JOIN tbl_users ON tbl_purchase.purchase_supplier_id = tbl_users.users_id
    INNER JOIN tbl_items ON tbl_purchase.purchase_items_id = tbl_items.items_id
      ''');
    }
    // ignore: avoid_print
    print("-------------------- DB Updated to version $newVersion");
  }

  _onCreate(Database db, int version) async {
    print("oncreate==============================");
    await _onUpgrade(db, 0, version);
  }

  Future<Uint8List?> getCategoryImage(int categoryId) async {
    Database? myDb = await db;
    List<Map<String, dynamic>> result = await myDb!.query(
      'tbl_categories',
      columns: ['categories_image'],
      where: 'categories_id = ?',
      whereArgs: [categoryId],
    );

    if (result.isNotEmpty) {
      return result.first['categories_image'];
    }

    return null;
  }

  Future<void> _copyDatabaseFromAssets(String path) async {
    ByteData data = await rootBundle.load('assets/$databaseName');
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes);
  }

  Future<int> insertCategoryWithImage(String name, Uint8List imageBytes) async {
    String base64Image = base64Encode(imageBytes);
    Map<String, dynamic> data = {
      'categories_name': name,
      'categories_createdate': DateTime.now().millisecondsSinceEpoch,
      'categories_image': base64Image,
    };
    return await insertData('tbl_categories', data);
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
    int count = await myDb!.delete(table, where: where);
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
