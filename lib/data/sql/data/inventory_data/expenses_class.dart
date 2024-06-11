import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:intl/intl.dart';

class ExpensesClass {
  SqlDb db = SqlDb();

  String exportTableName = "tbl_export";
  String exportViewName = "exportDetailsView";
  Future<dynamic> getExpensesData({
    String? startNo,
    String? endNo,
    String? startTime,
    String? endTime,
  }) async {
    String sql = "";
    List conditions = ["export_account = 'Expenses'"];
    if (startTime != null && endTime != null) {
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      DateTime startDate = formatter.parse(startTime);
      DateTime endDate = formatter.parse(endTime);
      conditions.add(
          "export_create_date BETWEEN '${formatter.format(startDate)}' AND  '${formatter.format(endDate)}'");
    }
    if (startNo != null && endNo != null) {
      conditions.add("export_id BETWEEN $startNo AND  $endNo");
    }
    if (startNo != null &&
        endNo != null &&
        startTime != null &&
        endTime != null) {
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      DateTime startDate = formatter.parse(startTime);
      DateTime endDate = formatter.parse(endTime);
      conditions.add(
          "(export_id BETWEEN $startNo AND  $endNo ) AND (export_create_date BETWEEN '${formatter.format(startDate)}' AND  '${formatter.format(endDate)}')");
    }
    if (conditions.isNotEmpty) {
      sql += conditions.join(" OR ");
    } else {
      sql =
          "";
    }
    var responseData = await db.getAllData(exportViewName, where: sql);
    int totalPrice = await getTotalExpensesPrice(sql);
    Map<String, dynamic> data = {
      "status": "success",
      "total_expenses_price": totalPrice,
      "data": responseData,
    };
    return data;
  }

  Future<int> getTotalExpensesPrice(String sql) async {
    var result = await db.getData('''
    SELECT 
    CAST(
        (
           SUM(export_amount)
        ) AS INTEGER
    ) AS total_expenses_price 
    FROM 
        tbl_export  
    WHERE 
      $sql
  ''');
    if (result != null &&
        result.isNotEmpty &&
        result[0]['total_expenses_price'] != null) {
      return result[0]['total_expenses_price'];
    } else {
      return 0;
    }
  }
}
