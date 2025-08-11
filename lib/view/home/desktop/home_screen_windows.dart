import 'package:cashier_system/controller/home/home_controller.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/view/home/desktop/home_logo.dart';
import 'package:cashier_system/view/home/desktop/home_widget_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeScreenWindows extends StatelessWidget {
  const HomeScreenWindows({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 200, child: buildLogoDesktop()),
          verticalGap(),
          Expanded(
            flex: 5,
            child: Container(
              alignment: Alignment.center,
              child: buildGridViewDesktop(),
            ),
          ),
        ],
      ),
    );
  }
}
