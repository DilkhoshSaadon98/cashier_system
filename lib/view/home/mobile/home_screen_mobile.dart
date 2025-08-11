import 'package:cashier_system/controller/home/home_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/view/home/mobile/home_logo_mobile.dart';
import 'package:cashier_system/view/home/mobile/how_widget_list_mobile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreenMobile extends StatelessWidget {
  const HomeScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildLogoMobile(),
                verticalGap(),
                buildGridViewMobile(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
