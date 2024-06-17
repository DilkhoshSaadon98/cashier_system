import 'package:cashier_system/controller/setting/setting_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/view/Settings/right_side_widget.dart';
import 'package:cashier_system/view/Settings/tabs/language_screen.dart';
import 'package:cashier_system/view/Settings/tabs/backup_screen.dart';
import 'package:cashier_system/view/Settings/tabs/customers_details.dart';
import 'package:cashier_system/view/Settings/tabs/invoices_screen.dart';
import 'package:cashier_system/view/Settings/tabs/security_screen.dart';
import 'package:cashier_system/view/Settings/tabs/system_update_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SettingController controller = Get.put(SettingController());
    return Scaffold(
      backgroundColor: white,
      body: Row(
        children: [
          GetBuilder<SettingController>(builder: (context) {
            return Expanded(
              flex: 6,
              child: IndexedStack(
                index: controller.currentIndex,
                children: [
                  const SecurityScreen(),
                  const BackupScreen(),
                  const UpdateSystemScreen(),
                  const CustomersDetails(),
                  const LanguageScreen(),
                  Container()
                ],
              ),
            );
          }),
          const RightSideWidget(),
        ],
      ),
    );
  }
}
