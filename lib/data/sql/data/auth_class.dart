import 'package:cashier_system/data/sql/sqldb.dart';

class AuthClass {
  SqlDb db = SqlDb();
  String tableName = "tbl_admins";

  Future<dynamic> login(String email, String password) async {
    var response = await db.getData(
        "SELECT * FROM $tableName WHERE (admin_username = '$email' OR admin_email = '$email') AND admin_password ='$password'");

    return {'status': "success", 'data': response};
  }

  Future<dynamic> getItemsData() async {
    var response = await db.getAllData('tbl_items');
    return response;
  }
}
