import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:intl/intl.dart';

class ImportExportClass {
  SqlDb db = SqlDb();
  String importTableName = "tbl_import";
  String importViewName = "importDetailsView";
  String exportTableName = "tbl_export";
  String exportViewName = "exportDetailsView";
  Future<dynamic> getImportData({
    String? account,
    String? supplier,
    String? startNo,
    String? endNo,
    String? startTime,
    String? endTime,
  }) async {
    String sql = "";
    List<String> conditions = [];
    if (startTime != null && endTime != null) {
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      DateTime startDate = formatter.parse(startTime);
      DateTime endDate = formatter.parse(endTime);
      conditions.add(
          "import_create_date BETWEEN '${formatter.format(startDate)}' AND '${formatter.format(endDate)}'");
    }
    if (startNo != null && endNo != null) {
      conditions.add("import_id BETWEEN $startNo AND $endNo");
    }

    if (account != null && supplier != null) {
      conditions.add(
          "import_account = '$account' AND import_supplier_id = '$supplier'");
    }
    if (supplier != null) {
      conditions.add("import_supplier_id = '$supplier'");
    }
    if (account != null) {
      conditions.add("import_account = '$account' ");
    }
    if (conditions.isNotEmpty) {
      sql += conditions.join(" AND ");
    } else {
      sql = "1 == 1";
    }
    var responseData = await db.getAllData(importViewName, where: sql);
    int totalBallance = await getTotalImportBallance(sql, importViewName);
    Map<String, dynamic> data = {
      "status": "success",
      "total_ballance": totalBallance,
      "data": responseData,
    };
    return data;
  }

  Future<dynamic> getExportData({
    String? account,
    String? supplier,
    String? startNo,
    String? endNo,
    String? startTime,
    String? endTime,
  }) async {
    String sql = "";
    List<String> conditions = [];
    if (startTime != null && endTime != null) {
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      DateTime startDate = formatter.parse(startTime);
      DateTime endDate = formatter.parse(endTime);
      conditions.add(
          "export_create_date BETWEEN '${formatter.format(startDate)}' AND '${formatter.format(endDate)}'");
    }
    if (startNo != null && endNo != null) {
      conditions.add("export_id BETWEEN $startNo AND $endNo");
    }

    if (account != null && supplier != null) {
      conditions.add(
          "export_account = '$account' AND export_supplier_id = '$supplier'");
    }
    if (supplier != null) {
      conditions.add("export_supplier_id = '$supplier'");
    }
    if (account != null) {
      conditions.add("export_account = '$account' ");
    }
    if (conditions.isNotEmpty) {
      sql += conditions.join(" AND ");
    } else {
      sql = "1 == 1";
    }
    var responseData = await db.getAllData(exportViewName, where: sql);
    int totalBallance = await getTotalExportBallance(sql, exportViewName);
    Map<String, dynamic> data = {
      "status": "success",
      "total_ballance": totalBallance,
      "data": responseData,
    };
    return data;
  }

  Future<int> addImportData(Map<String, dynamic> data) async {
    int response = await db.insertData(importTableName, data);
    return response;
  }

  Future<int> addExportData(Map<String, dynamic> data) async {
    int response = await db.insertData(exportTableName, data);
    return response;
  }

  Future<int> getTotalImportBallance(String sql, String view) async {
    var result = await db.getData('''
    SELECT 
    CAST(
        (
           SUM(import_amount)
        ) AS INTEGER
    ) AS total_ballance 
    FROM 
        $view  
    WHERE 
       $sql
  ''');
    if (result != null &&
        result.isNotEmpty &&
        result[0]['total_ballance'] != null) {
      return result[0]['total_ballance'];
    } else {
      return 0;
    }
  }

  Future<int> getTotalExportBallance(String sql, String view) async {
    var result = await db.getData('''
    SELECT 
    CAST(
        (
           SUM(export_amount)
        ) AS INTEGER
    ) AS total_ballance 
    FROM 
        $view  
    WHERE 
       $sql
  ''');
    if (result != null &&
        result.isNotEmpty &&
        result[0]['total_ballance'] != null) {
      return result[0]['total_ballance'];
    } else {
      return 0;
    }
  }
}
