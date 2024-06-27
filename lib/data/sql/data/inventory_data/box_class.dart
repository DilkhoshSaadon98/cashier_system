import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:intl/intl.dart';

class BoxClass {
  SqlDb db = SqlDb();

  Future<dynamic> getBoxData({
    String? startNo,
    String? endNo,
    String? startTime,
    String? endTime,
  }) async {
    String invoiceSql = "";
    String boxSql = "";
    String importSql = "";
    String exportSql = "";
    List invoiceConditions = ["invoice_payment = 'Cash'"];
    List boxConditions = [];
    List importConditions = [];
    List exportConditions = ["export_account != 'Employee'"];
    if (startTime != null && endTime != null) {
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      DateTime startDate = formatter.parse(startTime);
      DateTime endDate = formatter.parse(endTime);
      invoiceConditions.add(
          "( invoice_createdate BETWEEN '${formatter.format(startDate)}' AND  '${formatter.format(endDate)}' )");
      boxConditions.add(
          "( invoice_createdate BETWEEN '${formatter.format(startDate)}' AND  '${formatter.format(endDate)}' )");

      importConditions.add(
          "( import_create_date BETWEEN '${formatter.format(startDate)}' AND '${formatter.format(endDate)}' )");

      exportConditions.add(
          "( export_create_date BETWEEN '${formatter.format(startDate)}' AND '${formatter.format(endDate)}' )");
    }
    if (startNo != null && endNo != null) {
      invoiceConditions.add("( invoice_id BETWEEN $startNo AND  $endNo )");
      boxConditions.add("( invoice_id BETWEEN $startNo AND $endNo )");
      importConditions.add("( import_id BETWEEN $startNo AND $endNo )");
      exportConditions.add("( export_id BETWEEN $startNo AND $endNo )");
    }
    if (invoiceConditions.length > 1) {
      invoiceSql += invoiceConditions.join(" AND ");
    } else {
      invoiceSql = invoiceConditions[0];
    }

    if (exportConditions.length > 1) {
      exportSql += exportConditions.join(" AND ");
    } else {
      exportSql = exportConditions[0];
    }
    if (boxConditions.isNotEmpty ||
        importConditions.isNotEmpty ) {
      boxSql += boxConditions.join(" AND ");
      importSql += importConditions.join(" AND ");
    } else {
      importSql = " 1 == 1";
      boxSql = " 1 == 1";
    }
    var responseData = await db.getAllData('tbl_invoice', where: invoiceSql);
    var boxResponseData = await db.getAllData('boxView', where: boxSql);
    int totalPrice = await getTotalBoxPrice(invoiceSql);
    int totalCostPrice = await getTotalInvoiceCost(invoiceSql);
    int totalImportPrice = await getTotalImportPrice(importSql);
    int totalExportPrice = await getTotalExportPrice(exportSql);
    Map<String, dynamic> data = {
      "status": "success",
      "total_box_price": totalPrice,
      "total_box_cost": totalCostPrice,
      "total_import_price": totalImportPrice,
      "total_export_price": totalExportPrice,
      "data": responseData,
      "all_data": boxResponseData,
    };
    return data;
  }

  Future<int> getTotalBoxPrice(String sql) async {
    var result = await db.getData('''
    SELECT 
    CAST(
        (
           SUM(invoice_price)
        ) AS INTEGER
    ) AS total_box_price 
    FROM 
        tbl_invoice  
    WHERE $sql
  ''');
    if (result != null &&
        result.isNotEmpty &&
        result[0]['total_box_price'] != null) {
      return result[0]['total_box_price'];
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
    ) AS total_box_cost 
    FROM 
        tbl_invoice  
    WHERE 
        $sql AND invoice_payment = 'Cash'
  ''');
    if (result != null &&
        result.isNotEmpty &&
        result[0]['total_box_cost'] != null) {
      return result[0]['total_box_cost'];
    } else {
      return 0;
    }
  }

  Future<int> getTotalImportPrice(String sql) async {
    var result = await db.getData('''
    SELECT 
    CAST(
        (
           SUM(import_amount)
        ) AS INTEGER
    ) AS total_import_price
    FROM 
        tbl_import  
    WHERE 
        $sql 
  ''');
    if (result != null &&
        result.isNotEmpty &&
        result[0]['total_import_price'] != null) {
      return result[0]['total_import_price'];
    } else {
      return 0;
    }
  }

  Future<int> getTotalExportPrice(String sql) async {
    var result = await db.getData('''
    SELECT 
    CAST(
        (
           SUM(export_amount)
        ) AS INTEGER
    ) AS total_export_price
    FROM 
        tbl_export  
    WHERE 
        $sql 
  ''');
    if (result != null &&
        result.isNotEmpty &&
        result[0]['total_export_price'] != null) {
      return result[0]['total_export_price'];
    } else {
      return 0;
    }
  }
}
