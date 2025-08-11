import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:intl/intl.dart';

class ReportsData {
  SqlDb db = SqlDb();
  String generalLedgerView = "view_general_ledger";
  String viewTrialBalance = "view_trial_balance";
  String viewCashReports = "view_cash_report";
  String viewBankReports = "view_bank_report";
  String viewCustomerReports = "view_customer_ledger";
  String viewSupplierReports = "view_supplier_ledger";
  String viewWithDrawReports = "view_withdrawals_report";
  String viewRetainedEarningsReports = "view_retained_earnings_report";
  String viewAccountStatementData = "view_account_statement";
  String accountTableName = "tbl_accounts";
  String sourceAccountView = "view_source_accounts";
  String viewTransactionReceiptDetails = "view_receipt_transaction_details";
  String viewTransactionPaymentDetails = "view_payment_transaction_details";
  String exportViewName = "exportDetailsView";
//? General Ledger
  Future<Map<String, dynamic>> getGeneralLedgerData({
    String? sortBy,
    bool? ascSort = true,
    int? sourceAccount,
    int? targetAccount,
    String? transactionType,
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
            "( transaction_date BETWEEN '${formatter.format(startDate)}' AND '${formatter.format(endDate)}' )");
      } else {
        DateTime startDate = formatter.parse(startTime.trim());
        conditions
            .add("( transaction_date = '${formatter.format(startDate)}' )");
      }
    }

    // Handle transaction ID range
    if (startNo != null && endNo != null) {
      conditions.add("( voucher_no BETWEEN $startNo AND $endNo )");
    } else if (startNo != null) {
      conditions.add("( voucher_no = $startNo )");
    }

    // Account and type filters
    if (sourceAccount != null) {
      conditions.add("( source_account_id = $sourceAccount )");
    }
    if (targetAccount != null) {
      conditions.add("( target_account_id = $targetAccount )");
    }
    if (transactionType != null &&
        transactionType != TextRoutes.allTransactions) {
      conditions.add("( transaction_type = '$transactionType' )");
    }

    // Build WHERE clause
    whereClause = conditions.isNotEmpty ? conditions.join(" AND ") : "1 = 1";
    print(whereClause);
    // Final SQL query
    String sql =
        "SELECT * FROM $generalLedgerView WHERE $whereClause ORDER BY $sortBy ${ascSort! ? 'ASC' : "DESC"} LIMIT $limit OFFSET $offset";

    var responseData = await db.getData(sql);
    return {'status': 'success', 'data': responseData};
  }

  //? Trial Balance
  Future<Map<String, dynamic>> getTrialBalanceData({
    String? sortBy,
    bool? ascSort,
    String? startNo,
    String? endNo,
    int limit = 50,
    int offset = 0,
  }) async {
    String whereClause = "";
    List<String> conditions = [];

    // Handle transaction ID range
    if (startNo != null && endNo != null) {
      conditions.add("( voucher_no BETWEEN $startNo AND $endNo )");
    } else if (startNo != null) {
      conditions.add("( voucher_no = $startNo )");
    }

    // Build WHERE clause
    whereClause = conditions.isNotEmpty ? conditions.join(" AND ") : "1 = 1";

    // Final SQL query
    String sql =
        "SELECT * FROM $viewTrialBalance WHERE $whereClause ORDER BY $sortBy ${ascSort! ? 'ASC' : "DESC"} LIMIT $limit OFFSET $offset";

    var responseData = await db.getData(sql);
    return {'status': 'success', 'data': responseData};
  }

  //? Box Data
  Future<Map<String, dynamic>> getBoxData({
    String? sortBy,
    bool? ascSort = true,
    int? sourceAccount,
    int? targetAccount,
    String? transactionType,
    String? startNo,
    String? endNo,
    String? startTime,
    String? endTime,
    int limit = 100,
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
            "( transaction_date BETWEEN '${formatter.format(startDate)}' AND '${formatter.format(endDate)}' )");
      } else {
        DateTime startDate = formatter.parse(startTime.trim());
        conditions
            .add("( transaction_date = '${formatter.format(startDate)}' )");
      }
    }

    // Handle transaction ID range
    if (startNo != null && endNo != null) {
      conditions.add("( voucher_no BETWEEN $startNo AND $endNo )");
    } else if (startNo != null) {
      conditions.add("( voucher_no = $startNo )");
    }

    // Account and type filters
    if (sourceAccount != null) {
      conditions.add("( account_id = $sourceAccount )");
    }
    if (transactionType != null &&
        transactionType != TextRoutes.allTransactions) {
      conditions.add("( transaction_type = '$transactionType' )");
    }

    // Build WHERE clause
    whereClause = conditions.isNotEmpty ? conditions.join(" AND ") : "1 = 1";

    // Final SQL query
    String sql =
        "SELECT * FROM $viewCashReports WHERE $whereClause ORDER BY $sortBy ${ascSort! ? 'ASC' : "DESC"} LIMIT $limit OFFSET $offset";
    print(sql);
    var responseData = await db.getData(sql);
    return {'status': 'success', 'data': responseData};
  }

  //? Bank Report:
  Future<Map<String, dynamic>> getBankData({
    String? sortBy,
    bool? ascSort = true,
    int? sourceAccount,
    int? targetAccount,
    String? transactionType,
    String? startNo,
    String? endNo,
    String? startTime,
    String? endTime,
    int limit = 100,
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
            "( transaction_date BETWEEN '${formatter.format(startDate)}' AND '${formatter.format(endDate)}' )");
      } else {
        DateTime startDate = formatter.parse(startTime.trim());
        conditions
            .add("( transaction_date = '${formatter.format(startDate)}' )");
      }
    }

    // Handle transaction ID range
    if (startNo != null && endNo != null) {
      conditions.add("( voucher_no BETWEEN $startNo AND $endNo )");
    } else if (startNo != null) {
      conditions.add("( voucher_no = $startNo )");
    }

    // Account and type filters
    if (sourceAccount != null) {
      conditions.add("( account_id = $sourceAccount )");
    }
    if (targetAccount != null) {
      conditions.add("( target_account_id = $targetAccount )");
    }
    if (transactionType != null &&
        transactionType != TextRoutes.allTransactions) {
      conditions.add("( transaction_type = '$transactionType' )");
    }

    // Build WHERE clause
    whereClause = conditions.isNotEmpty ? conditions.join(" AND ") : "1 = 1";

    // Final SQL query
    String sql =
        "SELECT * FROM $viewBankReports WHERE $whereClause ORDER BY $sortBy ${ascSort! ? 'ASC' : "DESC"} LIMIT $limit OFFSET $offset";
    print(sql);
    var responseData = await db.getData(sql);
    return {'status': 'success', 'data': responseData};
  }

  //? Customer Report:
  Future<Map<String, dynamic>> getCustomerData({
    String? sortBy,
    bool? ascSort = true,
    int? sourceAccount,
    int? targetAccount,
    String? transactionType,
    String? startNo,
    String? endNo,
    String? startTime,
    String? endTime,
    int limit = 100,
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
            "( transaction_date BETWEEN '${formatter.format(startDate)}' AND '${formatter.format(endDate)}' )");
      } else {
        DateTime startDate = formatter.parse(startTime.trim());
        conditions
            .add("( transaction_date = '${formatter.format(startDate)}' )");
      }
    }

    // Handle transaction ID range
    if (startNo != null && endNo != null) {
      conditions.add("( voucher_no BETWEEN $startNo AND $endNo )");
    } else if (startNo != null) {
      conditions.add("( voucher_no = $startNo )");
    }

    // Account and type filters
    if (sourceAccount != null) {
      conditions.add("( account_id = $sourceAccount )");
    }
    if (targetAccount != null) {
      conditions.add("( target_account_id = $targetAccount )");
    }
    if (transactionType != null &&
        transactionType != TextRoutes.allTransactions) {
      conditions.add("( transaction_type = '$transactionType' )");
    }

    // Build WHERE clause
    whereClause = conditions.isNotEmpty ? conditions.join(" AND ") : "1 = 1";

    // Final SQL query
    String sql =
        "SELECT * FROM $viewCustomerReports WHERE $whereClause ORDER BY $sortBy ${ascSort! ? 'ASC' : "DESC"} LIMIT $limit OFFSET $offset";
    print(sql);
    var responseData = await db.getData(sql);
    return {'status': 'success', 'data': responseData};
  }

  //? Supplier Report:
  Future<Map<String, dynamic>> getSupplierData({
    String? sortBy,
    bool? ascSort = true,
    int? sourceAccount,
    int? targetAccount,
    String? transactionType,
    String? startNo,
    String? endNo,
    String? startTime,
    String? endTime,
    int limit = 100,
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
            "( transaction_date BETWEEN '${formatter.format(startDate)}' AND '${formatter.format(endDate)}' )");
      } else {
        DateTime startDate = formatter.parse(startTime.trim());
        conditions
            .add("( transaction_date = '${formatter.format(startDate)}' )");
      }
    }

    // Handle transaction ID range
    if (startNo != null && endNo != null) {
      conditions.add("( voucher_no BETWEEN $startNo AND $endNo )");
    } else if (startNo != null) {
      conditions.add("( voucher_no = $startNo )");
    }

    // Account and type filters
    if (sourceAccount != null) {
      conditions.add("( account_id = $sourceAccount )");
    }
    if (targetAccount != null) {
      conditions.add("( target_account_id = $targetAccount )");
    }
    if (transactionType != null &&
        transactionType != TextRoutes.allTransactions) {
      conditions.add("( transaction_type = '$transactionType' )");
    }

    // Build WHERE clause
    whereClause = conditions.isNotEmpty ? conditions.join(" AND ") : "1 = 1";

    // Final SQL query
    String sql =
        "SELECT * FROM $viewSupplierReports WHERE $whereClause ORDER BY $sortBy ${ascSort! ? 'ASC' : "DESC"} LIMIT $limit OFFSET $offset";
    print(sql);
    var responseData = await db.getData(sql);
    return {'status': 'success', 'data': responseData};
  }

  //? Withdraw Reports:
  Future<Map<String, dynamic>> getWithdrawData({
    String? sortBy,
    bool? ascSort = true,
    int? sourceAccount,
    int? targetAccount,
    String? transactionType,
    String? startNo,
    String? endNo,
    String? startTime,
    String? endTime,
    int limit = 100,
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
            "( transaction_date BETWEEN '${formatter.format(startDate)}' AND '${formatter.format(endDate)}' )");
      } else {
        DateTime startDate = formatter.parse(startTime.trim());
        conditions
            .add("( transaction_date = '${formatter.format(startDate)}' )");
      }
    }

    // Handle transaction ID range
    if (startNo != null && endNo != null) {
      conditions.add("( voucher_no BETWEEN $startNo AND $endNo )");
    } else if (startNo != null) {
      conditions.add("( voucher_no = $startNo )");
    }

    // Account and type filters
    if (sourceAccount != null) {
      conditions.add("( account_id = $sourceAccount )");
    }
    if (targetAccount != null) {
      conditions.add("( target_account_id = $targetAccount )");
    }
    if (transactionType != null &&
        transactionType != TextRoutes.allTransactions) {
      conditions.add("( transaction_type = '$transactionType' )");
    }

    // Build WHERE clause
    whereClause = conditions.isNotEmpty ? conditions.join(" AND ") : "1 = 1";

    // Final SQL query
    String sql =
        "SELECT * FROM $viewWithDrawReports WHERE $whereClause ORDER BY $sortBy ${ascSort! ? 'ASC' : "DESC"} LIMIT $limit OFFSET $offset";
    print(sql);
    var responseData = await db.getData(sql);
    return {'status': 'success', 'data': responseData};
  }

  //? Withdraw Reports:
  Future<Map<String, dynamic>> getRetainedEarningsData({
    String? sortBy,
    bool? ascSort = true,
    int? sourceAccount,
    int? targetAccount,
    String? transactionType,
    String? startNo,
    String? endNo,
    String? startTime,
    String? endTime,
    int limit = 100,
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
            "( transaction_date BETWEEN '${formatter.format(startDate)}' AND '${formatter.format(endDate)}' )");
      } else {
        DateTime startDate = formatter.parse(startTime.trim());
        conditions
            .add("( transaction_date = '${formatter.format(startDate)}' )");
      }
    }

    // Handle transaction ID range
    if (startNo != null && endNo != null) {
      conditions.add("( voucher_no BETWEEN $startNo AND $endNo )");
    } else if (startNo != null) {
      conditions.add("( voucher_no = $startNo )");
    }

    // Account and type filters
    if (sourceAccount != null) {
      conditions.add("( account_id = $sourceAccount )");
    }
    if (targetAccount != null) {
      conditions.add("( target_account_id = $targetAccount )");
    }
    if (transactionType != null &&
        transactionType != TextRoutes.allTransactions) {
      conditions.add("( transaction_type = '$transactionType' )");
    }

    // Build WHERE clause
    whereClause = conditions.isNotEmpty ? conditions.join(" AND ") : "1 = 1";

    // Final SQL query
    String sql =
        "SELECT * FROM $viewRetainedEarningsReports WHERE $whereClause ORDER BY $sortBy ${ascSort! ? 'ASC' : "DESC"} LIMIT $limit OFFSET $offset";
    print(sql);
    var responseData = await db.getData(sql);
    return {'status': 'success', 'data': responseData};
  }

  //? Account Statement Reports:
  Future<Map<String, dynamic>> getAccountStatementData({
    String? sortBy,
    bool? ascSort = true,
    int? sourceAccount,
    int? targetAccount,
    String? transactionType,
    String? startNo,
    String? endNo,
    String? startTime,
    String? endTime,
    int limit = 100,
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
            "( transaction_date BETWEEN '${formatter.format(startDate)}' AND '${formatter.format(endDate)}' )");
      } else {
        DateTime startDate = formatter.parse(startTime.trim());
        conditions
            .add("( transaction_date = '${formatter.format(startDate)}' )");
      }
    }

    // Handle transaction ID range
    if (startNo != null && endNo != null) {
      conditions.add("( voucher_no BETWEEN $startNo AND $endNo )");
    } else if (startNo != null) {
      conditions.add("( voucher_no = $startNo )");
    }

    // Account and type filters
    if (sourceAccount != null) {
      conditions.add("( account_id = $sourceAccount )");
    }
    if (targetAccount != null) {
      conditions.add("( target_account_id = $targetAccount )");
    }
    if (transactionType != null &&
        transactionType != TextRoutes.allTransactions) {
      conditions.add("( transaction_type = '$transactionType' )");
    }

    // Build WHERE clause
    whereClause = conditions.isNotEmpty ? conditions.join(" AND ") : "1 = 1";

    // Final SQL query
    String sql =
        "SELECT * FROM $viewAccountStatementData WHERE $whereClause ORDER BY $sortBy ${ascSort! ? 'ASC' : "DESC"} LIMIT $limit OFFSET $offset";
    print(sql);
    var responseData = await db.getData(sql);
    return {'status': 'success', 'data': responseData};
  }
}
