import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ClientsData {
  SqlDb db = SqlDb();
  String tableNameCustomer = "tbl_users";
  String tableNameSupplier = "tbl_supplier";

  String viewCustomerTable = "view_customers_details";
  String viewSupplierTable = "view_suppliers_details";
  //? Get Customers Data:
  Future<Map<String, dynamic>> getCustomersData({
    String? sortBy,
    bool? isAsc,
    String? customerName,
    String? customerAddress,
    String? customerPhone,
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
            "( date BETWEEN '${formatter.format(startDate)}' AND '${formatter.format(endDate)}' )");
      } else {
        DateTime startDate = formatter.parse(startTime.trim());
        conditions
            .add("( date = '${formatter.format(startDate)}' )");
      }
    }

    // Handle transaction ID range
    if (startNo != null && endNo != null && startNo.isNum && endNo.isNum) {
      conditions.add("( users_id BETWEEN $startNo AND $endNo )");
    } else if (startNo != null && startNo.isNum) {
      conditions.add("( id = $startNo )");
    }

    if (customerName != null) {
      conditions.add("( name LIKE '%$customerName%' )");
    }
    if (customerAddress != null) {
      conditions.add("( address LIKE '%$customerAddress%' )");
    }
    if (customerPhone != null) {
      conditions.add(
          "(phone LIKE '%$customerPhone%' OR phone2 LIKE '%$customerPhone%')");
    }
    if (conditions.isNotEmpty) {
      whereClause += conditions.join(" AND ");
    } else {
      whereClause = "1 = 1";
    }

    String sql =
        "SELECT * FROM $viewCustomerTable WHERE $whereClause ORDER BY $sortBy ${isAsc! ? "ASC" : "DESC"} LIMIT $limit OFFSET $offset";
 
    var responseData = await db.getData(sql);
    return {'status': 'success', 'data': responseData};
  }
  //? Get Supplier Data:
  Future<Map<String, dynamic>> getSuppliersData({
    String? sortBy,
    bool? isAsc,
    String? customerName,
    String? customerAddress,
    String? customerPhone,
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
            "( date BETWEEN '${formatter.format(startDate)}' AND '${formatter.format(endDate)}' )");
      } else {
        DateTime startDate = formatter.parse(startTime.trim());
        conditions
            .add("( date = '${formatter.format(startDate)}' )");
      }
    }

    // Handle transaction ID range
    if (startNo != null && endNo != null && startNo.isNum && endNo.isNum) {
      conditions.add("( id BETWEEN $startNo AND $endNo )");
    } else if (startNo != null && startNo.isNum) {
      conditions.add("( id = $startNo )");
    }

    if (customerName != null) {
      conditions.add("( name LIKE '%$customerName%' )");
    }
    if (customerAddress != null) {
      conditions.add("( address LIKE '%$customerAddress%' )");
    }
    if (customerPhone != null) {
      conditions.add(
          "(phone LIKE '%$customerPhone%' OR phone2 LIKE '%$customerPhone%')");
    }
    if (conditions.isNotEmpty) {
      whereClause += conditions.join(" AND ");
    } else {
      whereClause = "1 = 1";
    }

    String sql =
        "SELECT * FROM $viewSupplierTable WHERE $whereClause ORDER BY $sortBy ${isAsc! ? "ASC" : "DESC"} LIMIT $limit OFFSET $offset";
    print(sql);
    var responseData = await db.getData(sql);
    return {'status': 'success', 'data': responseData};
  }

  Future<int> addCustomer(Map<String, dynamic> data) async {
    int response = await db.insertData(
      tableNameCustomer,
      data,
    );
    return response;
  }
  Future<int> addSupplier(Map<String, dynamic> data) async {
    int response = await db.insertData(
      tableNameSupplier,
      data,
    );
    return response;
  }
  //? Edit Customer
  Future<int> editCustomer(Map<String, dynamic> data, int userID) async {
    int response = await db.updateData(tableNameCustomer, data, 'users_id = $userID');
    return response;
  }
  //? Edit Supplier
  Future<int> editSupplier(Map<String, dynamic> data, int userID) async {
    int response = await db.updateData(tableNameSupplier, data, 'supplier_id = $userID');
    return response;
  }


  Future<int> deleteUser(userId) async {
    int response = await db.deleteData(tableNameCustomer, "users_id = $userId");
    return response;
  }

  validateUserAccount(
    String username,
    String password,
  ) async {
    var response = await db.getData(
        "SELECT * FROM tbl_admins WHERE admin_username = '$username' AND admin_password = '$password'");

    return response.length;
  }

  Future<int> changeUsernamePassword(
    String username,
    String password,
    String newUsername,
    String newPassword,
  ) async {
    Map<String, dynamic> data = {
      "admin_username": newUsername,
      "admin_password": newPassword,
    };
    int updateResponse = 0;
    updateResponse = await db.updateData("tbl_admins", data,
        "admin_username = '$username' AND admin_password = '$password'");

    return updateResponse;
  }
}
