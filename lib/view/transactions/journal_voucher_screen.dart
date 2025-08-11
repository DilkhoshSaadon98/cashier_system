import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/responsive/screen_builder.dart';
import 'package:cashier_system/view/transactions/journal_voucher/mobile/journal_voucher_screen_mobile.dart';
import 'package:cashier_system/view/transactions/journal_voucher/windows/journal_voucher_screen_windows.dart';
import 'package:flutter/material.dart';

class JournalVoucherScreen extends StatelessWidget {
  const JournalVoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: primaryColor,
        body: ScreenBuilder(
            windows: JournalVoucherScreenWindows(),
            mobile: JournalVoucherScreenMobile()));
  }
}
