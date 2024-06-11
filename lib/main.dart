
import 'package:cashier_system/bindings/intialbindings.dart';
import 'package:cashier_system/core/functions/custom_scroll.dart';
import 'package:cashier_system/core/localization/translation.dart';
import 'package:cashier_system/core/services/services.dart';
import 'package:cashier_system/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'core/localization/changelocal.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialServices();
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    LocaleController controller = Get.put(LocaleController());
    return ScreenUtilInit(
        designSize: Size(context.width, context.height),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return GetMaterialApp(
            navigatorKey: navigatorKey,
            translations: MyTranslation(),
            scrollBehavior: CustomScrollBehavior(),
            debugShowCheckedModeBanner: false,
            title: "Cashier System",
            locale: controller.language,
            initialBinding: InitialBindings(),
            getPages: routes,
          );
        });
  }
}
