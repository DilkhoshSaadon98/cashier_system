import 'package:cashier_system/controller/home/home_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/screen_routes.dart';
import 'package:cashier_system/core/functions/change_direction.dart';
import 'package:cashier_system/core/responsive/screen_builder.dart';
import 'package:cashier_system/view/home/desktop/home_screen_windows.dart';
import 'package:cashier_system/view/home/drawer/custom_home_drawer.dart';
import 'package:cashier_system/view/home/mobile/home_screen_mobile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController());
    return Directionality(
      textDirection: screenDirection(),
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
          iconTheme: const IconThemeData(color: white),
        ),
        drawer: customDrawer(context, () {
          controller.logout();
          Get.offAllNamed(AppRoute.loginScreen);
        }),
        body: const ScreenBuilder(
          windows: HomeScreenWindows(),
          mobile: HomeScreenMobile(),
        ),
      ),
    );
  }
}
