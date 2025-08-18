import 'dart:io';

import 'package:cashier_system/controller/printer/invoice_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/functions/change_direction.dart';
import 'package:cashier_system/core/functions/custom_scroll.dart';
import 'package:cashier_system/core/localization/translation.dart';
import 'package:cashier_system/core/constant/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'core/localization/changelocal.dart';
import 'core/services/services.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialServices();
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;
          final Size designSize = isMobile || width < 600
              ? const Size(375, 812)
              : const Size(1200, 700);
          return ScreenUtilInit(
            designSize: designSize,
            minTextAdapt: true,
            splitScreenMode: true,
            child: _buildApp(),
          );
        },
      ),
    );
  }

  Widget _buildApp() {
    LocaleController controller = Get.put(LocaleController());
    if (myServices.sharedPreferences.getString("printer_url") != null) {
      Get.put(InvoiceController());
    }
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      translations: MyTranslation(),
      scrollBehavior: CustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: "MR.ROBOT",
      locale: controller.language,
      getPages: routes,
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return Directionality(
          textDirection: screenDirection(),
          child: child!,
        );
      },
    );
  }
}
