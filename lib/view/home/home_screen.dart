import 'package:cashier_system/controller/home/home_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/routes.dart';
import 'package:cashier_system/view/home/components/custom_home_drawer.dart';
import 'package:cashier_system/view/home/components/home_logo.dart';
import 'package:cashier_system/view/home/components/home_widget_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController());
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundColor: Colors.teal,
              child: IconButton(
                  onPressed: () async {
                    controller.fullScreen();
                    await windowManager.setFullScreen(controller.isFullScreen);
                  },
                  icon: Icon(
                    controller.isFullScreen == true
                        ? Icons.fullscreen_exit
                        : Icons.fullscreen,
                    color: white,
                  )),
            ),
          ),
        ],
      ),
      drawer: customDrawer(context, () {
        controller.logout();
        Get.offAllNamed(AppRoute.loginScreen);
      }),
      body: Container(
        width: Get.width,
        color: primaryColor,
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildLogo(),
                buildGridView(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
