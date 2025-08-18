
import 'package:cashier_system/core/class/sqldb.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';

class MyServices extends GetxService {
  late SharedPreferences sharedPreferences;
  late SharedPreferences systemSharedPreferences;
  SqlDb? sql;

  Future<MyServices> init() async {
    // Initialize SharedPreferences
    sharedPreferences = await SharedPreferences.getInstance();
    systemSharedPreferences = await SharedPreferences.getInstance();

    if (GetPlatform.isDesktop) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      await windowManager.ensureInitialized();

      // WindowOptions windowOptions = const WindowOptions(
      //     size: Size(1200, 800),
      //     center: true,
      //     backgroundColor: primaryColor,

      //     skipTaskbar: false,
      //     titleBarStyle: TitleBarStyle.normal,
      //     windowButtonVisibility: true,
      //     fullScreen: false);
      // windowManager.waitUntilReadyToShow(windowOptions, () async {
      //   await windowManager.show();
      //   await windowManager.focus();
      // });
    }

    sql = SqlDb();
    await sql!.initialDb();
    
    // Auto-setup for development
    await _setupDevelopmentMode();

    return this; 
  }
  
  Future<void> _setupDevelopmentMode() async {
    // Skip login/register for development
    if (!sharedPreferences.containsKey("step")) {
      sharedPreferences.setString("step", "dashboard");
      sharedPreferences.setString("admins_id", "1");
      sharedPreferences.setString("admins_username", "admin");
      sharedPreferences.setString("admins_role", "Full Access");
      sharedPreferences.setString("admins_password", "admin123");
      sharedPreferences.setString("admins_name", "System Admin");
      systemSharedPreferences.setString("cart_number", "1");
      systemSharedPreferences.setBool("start_new_cart", true);
    }
  }
}

Future<void> initialServices() async {
  await Get.putAsync(() => MyServices().init());
}
