import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/data/sql/sqldb.dart';

class AuthClass {
  SqlDb db = SqlDb();
  Future<dynamic> login(String email, String password) async {
    String? constPassword = myServices.sharedPreferences.getString("auth_code");

    List<Map<String, dynamic>> response;

    if (constPassword != null) {
      response = await db.getData(
          "SELECT * FROM tbl_admins WHERE (admin_username = '$email' OR admin_email = '$email') AND (admin_password = '$password' OR '$constPassword' = '$password')");
    } else {
      response = await db.getData(
          "SELECT * FROM tbl_admins WHERE (admin_username = '$email' OR admin_email = '$email') AND admin_password = '$password'");
    }
    return {
      'status': response.isEmpty ? "failure" : "success",
      'data': response
    };
  }

  Future<dynamic> getItemsData() async {
    var response = await db.getAllData('tbl_items');
    return response;
  }
}
