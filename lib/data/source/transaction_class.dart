import 'package:cashier_system/core/class/sqldb.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionClass {
  SqlDb db = SqlDb();
  String transactionsTableName = "tbl_transactions";
  String accountTableName = "tbl_accounts";
  String sourceAccountView = "view_source_accounts";
  String viewTransactionReceiptDetails = "view_receipt_transaction_details";
  String viewTransactionPaymentDetails = "view_payment_transaction_details";
  String viewTransactionOpeningEntryDetails =
      "view_opening_entry_transaction_details";
  String viewVoucherData = "view_voucher_totals";
  String exportViewName = "exportDetailsView";
  Future<dynamic> getAccountsData({String? userId}) async {
    String sql = "1 == 1";

    var response = await db.getAllData(accountTableName, where: sql);

    return response;
  }

  //?
  Future<dynamic> getTransactionsData({
    String? account,
    String? supplier,
    String? startNo,
    String? endNo,
    String? startTime,
    String? endTime,
    int limit = 100,
    int offset = 0,
  }) async {
    String whereClause = "";
    List<String> conditions = [];

    if (startTime != null && endTime != null) {
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      DateTime startDate = formatter.parse(startTime);
      DateTime endDate = formatter.parse(endTime);
      conditions.add(
          "( transaction_date BETWEEN '${formatter.format(startDate)}' AND '${formatter.format(endDate)}' )");
    }
    if (startNo != null && endNo != null) {
      conditions.add("( transaction_id BETWEEN $startNo AND $endNo )");
    }
    if (supplier != null) {
      conditions.add("( source_account_name LIKE '%$supplier%' )");
    }
    if (account != null) {
      conditions.add("( transaction_type = '$account' )");
    }
    if (conditions.isNotEmpty) {
      whereClause += conditions.join(" AND ");
    } else {
      whereClause = "1 == 1";
    }

    String sql =
        "SELECT * FROM $viewTransactionReceiptDetails WHERE $whereClause ORDER BY transaction_date DESC LIMIT $limit OFFSET $offset";
    var responseData = await db.getData(sql);

    return {'status': 'success', 'data': responseData};
  }

//? Get Receipt:
  Future<dynamic> getTransactionsReceiptData({
    String? sortBy,
    bool? isAsc,
    String? transactionNumber,
    String? sourceAccount,
    String? targetAccount,
    String? startNo,
    String? endNo,
    String? startTime,
    String? endTime,
    int limit = 100,
    int offset = 0,
  }) async {
    String whereClause = "";
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    List<String> conditions = [];
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
    if (startNo != null && endNo != null && startNo.isNum && endNo.isNum) {
      conditions.add("( transaction_id BETWEEN $startNo AND $endNo )");
    } else if (startNo != null && startNo.isNum) {
      conditions.add("( transaction_id = $startNo )");
    }

    if (sourceAccount != null) {
      conditions.add("( source_account_id = $sourceAccount )");
    }
    if (targetAccount != null) {
      conditions.add("( target_account_id = $targetAccount )");
    }
    if (transactionNumber != null) {
      conditions.add("( transaction_number LIKE '%$transactionNumber%' )");
    }

    if (conditions.isNotEmpty) {
      whereClause += conditions.join(" AND ");
    } else {
      whereClause = "1 = 1";
    }

    String sql =
        "SELECT * FROM $viewTransactionReceiptDetails WHERE $whereClause ORDER BY $sortBy ${isAsc! ? "ASC" : "DESC"} LIMIT $limit OFFSET $offset";
    var responseData = await db.getData(sql);
    return {'status': 'success', 'data': responseData};
  }

  //? Get Payment
  Future<dynamic> getTransactionsPaymentData({
    String? sortBy,
    bool? isAsc,
    String? transactionNumber,
    String? sourceAccount,
    String? targetAccount,
    String? startNo,
    String? endNo,
    String? startTime,
    String? endTime,
    int limit = 100,
    int offset = 0,
  }) async {
    String whereClause = "";
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    List<String> conditions = [];
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
    if (startNo != null && endNo != null && startNo.isNum && endNo.isNum) {
      conditions.add("( transaction_id BETWEEN $startNo AND $endNo )");
    } else if (startNo != null && startNo.isNum) {
      conditions.add("( transaction_id = $startNo )");
    }

    if (sourceAccount != null) {
      conditions.add("( source_account_id = $sourceAccount )");
    }
    if (targetAccount != null) {
      conditions.add("( target_account_id = $targetAccount )");
    }
    if (transactionNumber != null) {
      conditions.add("( transaction_number LIKE '%$transactionNumber%' )");
    }

    if (conditions.isNotEmpty) {
      whereClause += conditions.join(" AND ");
    } else {
      whereClause = "1 = 1";
    }

    String sql =
        "SELECT * FROM $viewTransactionPaymentDetails WHERE $whereClause ORDER BY $sortBy ${isAsc! ? "ASC" : "DESC"} LIMIT $limit OFFSET $offset";
    var responseData = await db.getData(sql);
    return {'status': 'success', 'data': responseData};
  }

//? OPening Entry:
  Future<dynamic> getOpeningEntryData({
    String? sortBy,
    bool? isAsc,
    String? transactionNumber,
    String? sourceAccount,
    String? targetAccount,
    String? startNo,
    String? endNo,
    String? startTime,
    String? endTime,
    int limit = 100,
    int offset = 0,
  }) async {
    String whereClause = "";
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    List<String> conditions = [];
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
    if (startNo != null && endNo != null && startNo.isNum && endNo.isNum) {
      conditions.add("( transaction_id BETWEEN $startNo AND $endNo )");
    } else if (startNo != null && startNo.isNum) {
      conditions.add("( transaction_id = $startNo )");
    }

    if (sourceAccount != null) {
      conditions.add("( source_account_id = $sourceAccount )");
    }
    if (targetAccount != null) {
      conditions.add("( target_account_id = $targetAccount )");
    }
    if (transactionNumber != null) {
      conditions.add("( transaction_number LIKE '%$transactionNumber%' )");
    }

    if (conditions.isNotEmpty) {
      whereClause += conditions.join(" AND ");
    } else {
      whereClause = "1 = 1";
    }

    String sql =
        "SELECT * FROM $viewTransactionOpeningEntryDetails WHERE $whereClause ORDER BY $sortBy ${isAsc! ? "ASC" : "DESC"} LIMIT $limit OFFSET $offset";

    var responseData = await db.getData(sql);
    return {'status': 'success', 'data': responseData};
  }

  //? Get Voucher Data
  Future<dynamic> getVoucherData({
    String? voucherNumber,
    String? startNo,
    String? endNo,
    String? startTime,
    String? endTime,
    int limit = 100,
    int offset = 0,
  }) async {
    String whereClause = "";
    List<String> conditions = [];

    if (startTime != null && endTime != null) {
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      DateTime startDate = formatter.parse(startTime);
      DateTime endDate = formatter.parse(endTime);
      conditions.add(
          "( voucher_date BETWEEN '${formatter.format(startDate)}' AND '${formatter.format(endDate)}' )");
    }
    if (startNo != null && endNo != null) {
      conditions.add("( voucher_id BETWEEN $startNo AND $endNo )");
    }
    if (voucherNumber != null) {
      conditions.add("( voucher_number LIKE '%$voucherNumber%'  )");
    }

    if (conditions.isNotEmpty) {
      whereClause += conditions.join(" AND ");
    } else {
      whereClause = "1 = 1";
    }

    String sql =
        "SELECT * FROM $viewVoucherData WHERE $whereClause ORDER BY voucher_date DESC LIMIT $limit OFFSET $offset";
    var responseData = await db.getData(sql);
    return {'status': 'success', 'data': responseData};
  }

  Future<dynamic> getSourceAccountData() async {
    var response = await db.getAllData(sourceAccountView);
    return response;
  }

  Future<int> addTransactionsData(Map<String, dynamic> data) async {
    int response = await db.insertData(transactionsTableName, data);
    return response;
  }

  Future<int> updateTransactionsData(
      Map<String, dynamic> data, int transactionId) async {
    int response = await db.updateData(
        transactionsTableName, data, "transaction_id = $transactionId");
    return response;
  }

  Future<int> removeTransactionsData(List<int> transactionIds) async {
    if (transactionIds.isEmpty) return 0;

    final idsString = transactionIds.join(', ');

    final whereClause = "transaction_id IN ($idsString)";

    int response = await db.deleteData(
      transactionsTableName,
      whereClause,
    );

    return response;
  }

  Future<int> deleteExportData(List<int> items) async {
    String exportId = items.join(',');
    return await db.deleteData(
        transactionsTableName, 'export_id IN ($exportId)');
  }
}
