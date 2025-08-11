import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/responsive/screen_builder.dart';
import 'package:cashier_system/view/transactions/receipt/mobile/transaction_receipt_mobile_screen.dart';
import 'package:cashier_system/view/transactions/receipt/windows/transaction_receipt_windows_screen.dart';
import 'package:flutter/material.dart';

class TransactionReceiptScreen extends StatelessWidget {
  const TransactionReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: primaryColor,
        body: ScreenBuilder(
            windows: TransactionReceiptWindowsScreen(),
            mobile: TransactionReceiptMobileScreen()));
  }
}
