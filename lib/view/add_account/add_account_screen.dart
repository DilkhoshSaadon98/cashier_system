import 'package:cashier_system/controller/add_account_controller.dart';
import 'package:cashier_system/core/responsive/screen_builder.dart';
import 'package:cashier_system/view/add_account/mobile/add_account_screen_mobile.dart';
import 'package:cashier_system/view/add_account/windows/add_account_screen_windows.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAccountScreen extends StatelessWidget {
  const AddAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AddAccountController());
    return const Scaffold(
      body: ScreenBuilder(
        mobile: AddAccountScreenMobile(),
        windows: AddAccountScreenWindows(),
      ),
    );
  }
}
