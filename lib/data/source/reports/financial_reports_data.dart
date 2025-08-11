import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FinancialReportsData {
  SqlDb db = SqlDb();
  String viewIncomeStatement = 'view_income_statement';
  String viewInventoryMovements = 'view_inventory_movements';
  String viewBalanceSheet = 'view_balance_sheet_summary';

  //?IncomeStatement
  Future<Map<String, dynamic>> getIncomeStatementData({
    String? startTime,
    String? endTime,
  }) async {
    String whereClause = "";
    List<String> conditions = [];
    DateFormat formatter = DateFormat('yyyy-MM-dd');

    // Handle date range
    if (startTime != null && startTime.trim().isNotEmpty) {
      if (endTime != null && endTime.trim().isNotEmpty) {
        DateTime startDate = formatter.parse(startTime.trim());
        DateTime endDate = formatter.parse(endTime.trim());
        conditions.add(
            "( date BETWEEN '${formatter.format(startDate)}' AND '${formatter.format(endDate)}' )");
      } else {
        DateTime startDate = formatter.parse(startTime.trim());
        conditions.add("( date = '${formatter.format(startDate)}' )");
      }
    }

    // Build WHERE clause
    whereClause = conditions.isNotEmpty ? conditions.join(" AND ") : "1 = 1";

    // Final SQL query
    String sql = "SELECT * FROM $viewIncomeStatement WHERE $whereClause ";
    var responseData = await db.getData(sql);
    return {'status': 'success', 'data': responseData};
  }

  //?IncomeStatement
  Future<Map<String, dynamic>> getBalanceSheetData({
    String? startTime,
    String? endTime,
  }) async {
    String whereClause = "";
    List<String> conditions = [];
    DateFormat formatter = DateFormat('yyyy-MM-dd');

    // Handle date range
    if (startTime != null && startTime.trim().isNotEmpty) {
      if (endTime != null && endTime.trim().isNotEmpty) {
        DateTime startDate = formatter.parse(startTime.trim());
        DateTime endDate = formatter.parse(endTime.trim());
        conditions.add(
            "( date BETWEEN '${formatter.format(startDate)}' AND '${formatter.format(endDate)}' )");
      } else {
        DateTime startDate = formatter.parse(startTime.trim());
        conditions.add("( date = '${formatter.format(startDate)}' )");
      }
    }

    // Build WHERE clause
    whereClause = conditions.isNotEmpty ? conditions.join(" AND ") : "1 = 1";

    // Final SQL query
    String sql = "SELECT * FROM $viewBalanceSheet WHERE $whereClause ";
    print("summary_sql:$sql");
    var responseData = await db.getData(sql);
    return {'status': 'success', 'data': responseData};
  }
}
