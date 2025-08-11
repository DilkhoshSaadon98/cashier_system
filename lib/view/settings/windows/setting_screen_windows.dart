import 'package:cashier_system/controller/setting/setting_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/responsive/divide_screen_widget.dart';
import 'package:cashier_system/view/settings/windows/right_side_widget.dart';
import 'package:cashier_system/view/settings/windows/tabs/backup_screen_windows.dart';
import 'package:cashier_system/view/settings/windows/tabs/currency_windows.dart';
import 'package:cashier_system/view/settings/windows/tabs/language_screen_windows.dart';
import 'package:cashier_system/view/settings/windows/tabs/security_screen_windows.dart';
import 'package:cashier_system/view/settings/windows/tabs/system_update_screen_windows.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingScreenWindows extends StatelessWidget {
  const SettingScreenWindows({super.key});

  @override
  Widget build(BuildContext context) {
    SettingController controller = Get.put(SettingController());
    return Scaffold(
      backgroundColor: white,
      body: DivideScreenWidget(
        showWidget: GetBuilder<SettingController>(builder: (context) {
          return IndexedStack(
            index: controller.currentIndex,
            children: [
              const SecurityScreen(),
              const BackupScreen(),
              const UpdateSystemScreen(),
              const LanguageScreen(),
              const CurrencyWindows(),
              Container()
            ],
          );
        }),
        actionWidget: const RightSideWidget(),
      ),
    );
  }
}
