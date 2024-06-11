import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:intl/intl.dart';

class ExportClass {
  SqlDb db = SqlDb();
  String exportTableName = "tbl_export";
  String exportViewName = "exportDetailsView";

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
          "( export_create_date BETWEEN '${formatter.format(startDate)}' AND '${formatter.format(endDate)}' )");
    }
    if (startNo != null && endNo != null) {
      conditions.add("( export_id BETWEEN $startNo AND $endNo )");
    }
    if (supplier != null) {
      conditions.add("( export_supplier_id = '$supplier' )");
    }
    if (account != null) {
      conditions.add("( export_account = '$account' )");
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

  Future<int> addExportData(Map<String, dynamic> data) async {
    int response = await db.insertData(exportTableName, data);
    return response;
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

  Future<int> deleteExportData(List<String> items) async {
    String importId = items.join(',');
    return await db.deleteData('tbl_export', 'export_id IN ($importId)');
  }
}
