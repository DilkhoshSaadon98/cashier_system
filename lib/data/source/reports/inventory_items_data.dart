import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InventoryItemsData {
  SqlDb db = SqlDb();
  String viewInventorySummary = 'view_inventory_summary';
  String viewInventoryMovements = 'view_inventory_movements';
  String viewInventoryValuation = 'view_inventory_valuation';
  Future<dynamic> getSourceAccountData(int parentId) async {
    var response = await db.getData(
        "SELECT * FROM tbl_accounts WHERE account_parent_id = $parentId");
    return {'status': 'success', 'data': response};
  }

  //? Inventory Summary
  Future<Map<String, dynamic>> getInventorySummaryData({
    String? sortBy,
    bool? ascSort = true,
    String? accountName,
    String? itemsName,
    String? summaryType,
    String? startNo,
    String? endNo,
    String? startTime,
    String? endTime,
    int limit = 50,
    int offset = 0,
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

    // Handle transaction ID range
    if (startNo != null && endNo != null && startNo.isNum && endNo.isNum) {
      conditions.add("( invoice_number BETWEEN $startNo AND $endNo )");
    } else if (startNo != null && startNo.isNum) {
      conditions.add("( invoice_number = $startNo )");
    }

    // Account and type filters
    if (accountName != null && accountName != TextRoutes.cashAgent) {
      conditions.add("( account_name LIKE '%$accountName%' )");
    }
    if (accountName == TextRoutes.cashAgent) {
      conditions.add("( account_name IS NULL )");
    }
    if (itemsName != null) {
      conditions.add("( item_name LIKE '%$itemsName%' )");
    }
    if (summaryType != null) {
      conditions.add("( type = '$summaryType' )");
    }

    // Build WHERE clause
    whereClause = conditions.isNotEmpty ? conditions.join(" AND ") : "1 = 1";

    // Final SQL query
    String sql =
        "SELECT * FROM $viewInventorySummary WHERE $whereClause ORDER BY $sortBy ${ascSort! ? 'ASC' : "DESC"} LIMIT $limit OFFSET $offset";
    print("summary_sql:$sql");
    var responseData = await db.getData(sql);
    return {'status': 'success', 'data': responseData};
  }

  //? Inventory Movements
  Future<Map<String, dynamic>> getInventoryMovementsData({
    String? sortBy,
    bool? ascSort = true,
    String? itemsQty,
    String? itemsName,
    String? startNo,
    String? endNo,
    String? startTime,
    String? endTime,
    int limit = 50,
    int offset = 0,
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

    // Handle transaction ID range
    if (startNo != null && endNo != null && startNo.isNum && endNo.isNum) {
      conditions.add("( invoice_number BETWEEN $startNo AND $endNo )");
    } else if (startNo != null && startNo.isNum) {
      conditions.add("( invoice_number = $startNo )");
    }

    if (itemsName != null) {
      conditions.add("( item_name LIKE '%$itemsName%' )");
    }
    if (itemsQty != null && itemsQty.isNum) {
      conditions.add("( quantity_remaining = $itemsQty )");
    }

    // Build WHERE clause
    whereClause = conditions.isNotEmpty ? conditions.join(" AND ") : "1 = 1";

    // Final SQL query
    String sql =
        "SELECT * FROM $viewInventoryMovements WHERE $whereClause ORDER BY $sortBy ${ascSort! ? 'ASC' : "DESC"} LIMIT $limit OFFSET $offset";
    print("movements_sql:$sql");
    var responseData = await db.getData(sql);
    return {'status': 'success', 'data': responseData};
  }

  //? Inventory Movements
  Future<Map<String, dynamic>> getInventoryValuationData({
    String? sortBy,
    bool? ascSort = true,
    String? accountName,
    String? itemsName,
    String? startNo,
    String? endNo,
    String? startTime,
    String? endTime,
    int limit = 50,
    int offset = 0,
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
            "( movement_date BETWEEN '${formatter.format(startDate)}' AND '${formatter.format(endDate)}' )");
      } else {
        DateTime startDate = formatter.parse(startTime.trim());
        conditions.add("( movement_date = '${formatter.format(startDate)}' )");
      }
    }

    // Handle transaction ID range
    if (startNo != null && endNo != null && startNo.isNum && endNo.isNum) {
      conditions.add("( invoice_number BETWEEN $startNo AND $endNo )");
    } else if (startNo != null && startNo.isNum) {
      conditions.add("( invoice_number = $startNo )");
    }

    // Account and type filters
    if (accountName != null) {
      conditions.add("( account_name LIKE '%$accountName%' )");
    }
    if (itemsName != null) {
      conditions.add("( item_name LIKE '%$itemsName%' )");
    }

    // Build WHERE clause
    whereClause = conditions.isNotEmpty ? conditions.join(" AND ") : "1 = 1";

    // Final SQL query
    String sql =
        "SELECT * FROM $viewInventoryValuation WHERE $whereClause ORDER BY $sortBy ${ascSort! ? 'ASC' : "DESC"} LIMIT $limit OFFSET $offset";

    var responseData = await db.getData(sql);
    return {'status': 'success', 'data': responseData};
  }
}
