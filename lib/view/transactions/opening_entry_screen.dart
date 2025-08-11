import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/responsive/screen_builder.dart';
import 'package:cashier_system/view/transactions/opening_entry/windows/opening_entry_screen_windows.dart';
import 'package:flutter/material.dart';

class OpeningEntryScreen extends StatelessWidget {
  const OpeningEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: primaryColor,
        body: ScreenBuilder(
            windows: OpeningEntryScreenWindows(),
            mobile: OpeningEntryScreenWindows()));
  }
}
