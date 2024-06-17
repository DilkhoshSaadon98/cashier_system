import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class MyServices extends GetxService {
  late SharedPreferences sharedPreferences;
  late SharedPreferences systemSharedPreferences;
  SqlDb? sql;

  Future<MyServices> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    systemSharedPreferences = await SharedPreferences.getInstance();
    if (GetPlatform.isDesktop) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    // Initialize the database
    sql = SqlDb();
    await sql!.initialDb();
    return this;
  }
}

Future<void> initialServices() async {
  await Get.putAsync(() => MyServices().init());
}
