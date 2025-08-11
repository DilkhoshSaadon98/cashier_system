import 'package:cashier_system/controller/setting/back_up_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/view/settings/components/back_up_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BackupScreen extends StatelessWidget {
  const BackupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BackUpController controller = Get.put(BackUpController());
    return Scaffold(
        appBar: customAppBarTitle("Back Up"),
        backgroundColor: white,
        body: Container(
            height: Get.height,
            width: Get.width,
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 500.w,
              child: BackUpWidget(controller: controller),
            )));
  }
}
