import 'package:cashier_system/controller/setting/security_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/view/settings/components/security_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SecurityController());
    return GetBuilder<SecurityController>(builder: (controller) {
      return Scaffold(
        appBar: customAppBarTitle("Security"),
        backgroundColor: white,
        body: Container(
          width: Get.width,
          height: Get.height,
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: const SizedBox(width: 500, child: SecurityWidget()),
        ),
      );
    });
  }
}
