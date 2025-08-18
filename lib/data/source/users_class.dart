import 'package:cashier_system/core/class/sqldb.dart';

class UsersClass {
  SqlDb db = SqlDb();
  String tableName = "tbl_users";

  Future<dynamic> getUserData({String? userId}) async {
    String sql = "";
    if (userId != null) {
      sql = "users_id = $userId";
    } else {
      sql = "1 == 1";
    }
    var response = await db.getAllData(tableName, where: sql);

    return {'status': "success", 'data': response};
  }

  Future<int> addUser(Map<String, dynamic> data) async {
    int response = await db.insertData(
      tableName,
      data,
    );
    return response;
  }

  Future<int> editUser(Map<String, dynamic> data, userId) async {
    int response = await db.updateData(tableName, data, "users_id = $userId");
    return response;
  }

  Future<int> deleteUser(userId) async {
    int response = await db.deleteData(tableName, "users_id = $userId");
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
