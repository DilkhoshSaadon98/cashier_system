import 'package:cashier_system/controller/setting/setting_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/responsive/screen_builder.dart';
import 'package:cashier_system/view/settings/mobile/setting_screen_mobile.dart';
import 'package:cashier_system/view/settings/windows/setting_screen_windows.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SettingController());
    return const Scaffold(
        backgroundColor: white,
        body: ScreenBuilder(
          windows: SettingScreenWindows(),
          mobile: SettingScreenMobile(),
        ));
  }
}
