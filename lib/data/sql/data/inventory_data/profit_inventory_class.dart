import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:intl/intl.dart';

class TotalProfitClass {
  SqlDb db = SqlDb();

  Future<dynamic> getProfitData({
    String? startNo,
    String? endNo,
    String? startTime,
    String? endTime,
  }) async {
    String sql = "";
    String expensesSql = "";
    List conditions = [];
    List expensesConditions = ["(export_account = 'Expenses' OR export_account = 'Cash Expenses')"];
    if (startTime != null && endTime != null) {
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      DateTime startDate = formatter.parse(startTime);
      DateTime endDate = formatter.parse(endTime);
      conditions.add(
          "invoice_createdate BETWEEN '${formatter.format(startDate)}' AND  '${formatter.format(endDate)}'");
      expensesConditions.add(
          "export_create_date BETWEEN '${formatter.format(startDate)}' AND  '${formatter.format(endDate)}'");
    }
    if (startNo != null && endNo != null) {
      conditions.add("invoice_id BETWEEN $startNo AND  $endNo");
      expensesConditions.add("export_id BETWEEN $startNo AND  $endNo");
    }
    if (conditions.isNotEmpty) {
      sql += conditions.join(" AND ");
    } else {
      sql = "1 == 1";
    }
    if (expensesConditions.length > 1) {
      expensesSql += expensesConditions.join(" AND ");
    } else {
      expensesSql = expensesConditions[0];
    }
    var responseData = await db.getAllData('totalProfitView', where: sql);
    var profitResponseData = await db.getAllData('tbl_invoice', where: sql);
    int totalPrice = await getTotalProfitPrice(sql);
    int totalCostPrice = await getTotalInvoiceCost(sql);
    int totalExpensesPrice = await getTotalExpensesPrice(expensesSql);
    Map<String, dynamic> data = {
      "status": "success",
      "total_Invoice_price": totalPrice,
      "profit_data": profitResponseData,
      "total_invoice_cost": totalCostPrice,
      "total_expenses_price": totalExpensesPrice,
      "data": responseData,
    };
    return data;
  }

  Future<int> getTotalProfitPrice(String sql) async {
    var result = await db.getData('''
    SELECT 
    CAST(
        (
           SUM(invoice_price)-SUM(invoice_cost)
        ) AS INTEGER
    ) AS total_invoice_price 
    FROM 
        tbl_invoice  
    WHERE $sql
  ''');
    if (result != null &&
        result.isNotEmpty &&
        result[0]['total_invoice_price'] != null) {
      return result[0]['total_invoice_price'];
    } else {
      return 0;
    }
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
    WHERE $sql
  ''');
    if (result != null &&
        result.isNotEmpty &&
        result[0]['total_expenses_price'] != null) {
      return result[0]['total_expenses_price'];
    } else {
      return 0;
    }
  }

  Future<int> getTotalInvoiceCost(String sql) async {
    var result = await db.getData('''
    SELECT 
    CAST(
        (
           SUM(invoice_cost )
        ) AS INTEGER
    ) AS total_invoice_cost 
    FROM 
        tbl_invoice  
    WHERE 
        $sql
  ''');
    if (result != null &&
        result.isNotEmpty &&
        result[0]['total_invoice_cost'] != null) {
      return result[0]['total_invoice_cost'];
    } else {
      return 0;
    }
  }
}
