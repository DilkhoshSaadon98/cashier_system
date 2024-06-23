import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:intl/intl.dart';

class CreditorDebtorClass {
  SqlDb sqlDb = SqlDb();
  Future<dynamic> getDebtorData({
    String? startNo,
    String? endNo,
    String? startTime,
    String? endTime,
  }) async {
    String sql = "";
    List conditions = [];
    List expensesConditions = ["export_account = 'Expenses'"];
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
    var responseData = await sqlDb.getAllData('debtorView', where: sql);
    Map<String, dynamic> data = {
      "status": "success",
      "data": responseData,
    };
    return data;
  }
}
