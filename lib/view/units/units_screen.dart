import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/responsive/screen_builder.dart';
import 'package:cashier_system/view/units/mobile/units_screen_mobile.dart';
import 'package:cashier_system/view/units/windows/units_screen_windows.dart';
import 'package:flutter/material.dart';

class UnitsScreen extends StatelessWidget {
  const UnitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get.put(ItemsViewController());
    return const Scaffold(
      backgroundColor: white,
      body: ScreenBuilder(
          windows: UnitsScreenWindows(), mobile: UnitsScreenMobile()),
    );
  }
}
