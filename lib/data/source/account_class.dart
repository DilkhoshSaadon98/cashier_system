import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/class/sqldb.dart';

class AccountClass {
  SqlDb sqlDb = SqlDb();
  String tableCustomerName = "tbl_users";
  String tableSupplierName = "tbl_supplier";
  String tableExpensesName = "tbl_expenses";
  String tableAccountName = "tbl_accounts";
  String viewAccountName = "view_accounts";
  String tableTransactionsName = "tbl_transactions";

  Future<dynamic> getAccountsData({String? accountParentId}) async {
    String sql;

    if (accountParentId != null) {
      sql = "account_parent_id = $accountParentId";
    } else {
      sql = "1 == 1 ORDER BY account_parent_id ASC";
    }
    var response = await sqlDb.getAllData(viewAccountName, where: sql);
    return response;
  }

  Future<int> addAccount(Map<String, dynamic> data) async {
    int response = await sqlDb.insertData(
      tableAccountName,
      data,
    );
    return response;
  }

  Future<int> updateAccount(Map<String, dynamic> data, accountId) async {
    int response = await sqlDb.updateData(
        tableAccountName, data, "account_id = $accountId");
    return response;
  }

  Future<Map<String, dynamic>> deleteAccount(int accountId) async {
    try {
      final children = await sqlDb.getAllData(
        tableAccountName,
        where: "account_parent_id = $accountId AND is_deleted = 0",
      );

      if (children.isNotEmpty) {
        return {
          "status": TextRoutes.error,
          "message": TextRoutes.cannotDeleteThisAccountBecauseItHasSubAccounts,
        };
      }

      final transactions = await sqlDb.getAllData(
        tableTransactionsName,
        where:
            "source_account_id = $accountId OR target_account_id = $accountId",
      );

      if (transactions.isNotEmpty) {
        return {
          "status": TextRoutes.error,
          "message": TextRoutes.cannotDeleteThisAccountBecauseItHasTransactions,
        };
      }

      int result = await sqlDb.updateData(
        tableAccountName,
        {"is_deleted": 1},
        "account_id = $accountId",
      );

      if (result > 0) {
        return {
          "status": TextRoutes.success,
          "message": TextRoutes.accountDeletedSuccessfully,
        };
      } else {
        return {
          "status": TextRoutes.error,
          "message": TextRoutes.failedToDeleteAccount,
        };
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          message: TextRoutes.errorWhileDeletingAccount);
      return {
        "status": TextRoutes.error,
        "message": TextRoutes.errorWhileDeletingAccount,
      };
    }
  }
}
