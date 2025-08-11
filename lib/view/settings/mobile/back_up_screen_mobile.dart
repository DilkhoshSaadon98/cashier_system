import 'package:cashier_system/controller/setting/back_up_controller.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/view/settings/components/back_up_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackUpScreenMobile extends StatelessWidget {
  const BackUpScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    BackUpController controller = Get.put(BackUpController());
    return Scaffold(
      appBar: customAppBarTitle("Back Up", true),
      body: Container(
          height: Get.height,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: BackUpWidget(controller: controller)),
    );
  }
}
