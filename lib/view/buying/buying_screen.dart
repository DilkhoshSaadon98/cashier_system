import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/responsive/screen_builder.dart';
import 'package:cashier_system/view/buying/mobile/buying_screen_mobile.dart';
import 'package:cashier_system/view/buying/windows/buying_screen_windows.dart';
import 'package:flutter/material.dart';

class BuyingScreen extends StatelessWidget {
  const BuyingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: white,
      body: ScreenBuilder(
          windows: BuyingScreenWindows(), mobile: BuyingScreenMobile()),
    );
  }
}
