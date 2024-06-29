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
    String debtorSql = "";
    List debtoConditions = ["status = 'Debtor'"];
    List expensesConditions = ["export_account = 'Expenses'"];
    if (startTime != null && endTime != null) {
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      DateTime startDate = formatter.parse(startTime);
      DateTime endDate = formatter.parse(endTime);
      debtoConditions.add(
          "invoice_createdate BETWEEN '${formatter.format(startDate)}' AND  '${formatter.format(endDate)}'");
      expensesConditions.add(
          "export_create_date BETWEEN '${formatter.format(startDate)}' AND  '${formatter.format(endDate)}'");
    }
    if (startNo != null && endNo != null) {
      debtoConditions.add("invoice_id BETWEEN $startNo AND  $endNo");
      expensesConditions.add("export_id BETWEEN $startNo AND  $endNo");
    }
    if (debtoConditions.length > 1) {
      debtorSql += debtoConditions.join(" AND ");
    } else {
      debtorSql = debtoConditions[0];
    }
    var responseData =
        await sqlDb.getAllData('creditorDebtorView', where: debtorSql);
    Map<String, dynamic> data = {
      "status": "success",
      "data": responseData,
    };
    return data;
  }
  Future<dynamic> getCreditorData({
    String? startNo,
    String? endNo,
    String? startTime,
    String? endTime,
  }) async {
    String creditorSql = "";
    List creditorConditions = ["status = 'Creditor'"];
    List expensesConditions = ["export_account = 'Expenses'"];
    if (startTime != null && endTime != null) {
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      DateTime startDate = formatter.parse(startTime);
      DateTime endDate = formatter.parse(endTime);
      creditorConditions.add(
          "invoice_createdate BETWEEN '${formatter.format(startDate)}' AND  '${formatter.format(endDate)}'");
      expensesConditions.add(
          "export_create_date BETWEEN '${formatter.format(startDate)}' AND  '${formatter.format(endDate)}'");
    }
    if (startNo != null && endNo != null) {
      creditorConditions.add("invoice_id BETWEEN $startNo AND  $endNo");
      expensesConditions.add("export_id BETWEEN $startNo AND  $endNo");
    }
    if (creditorConditions.length > 1) {
      creditorSql += creditorConditions.join(" AND ");
    } else {
      creditorSql = creditorConditions[0];
    }
    var responseData =
        await sqlDb.getAllData('creditorDebtorView', where: creditorSql);
    Map<String, dynamic> data = {
      "status": "success",
      "data": responseData,
    };
    return data;
  }
}
