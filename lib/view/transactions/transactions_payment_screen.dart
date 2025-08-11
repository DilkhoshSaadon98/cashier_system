import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/responsive/screen_builder.dart';
import 'package:cashier_system/view/transactions/payment/mobile/transaction_payments_screen_mobile.dart';
import 'package:cashier_system/view/transactions/payment/windows/transaction_payment_windows_screen.dart';
import 'package:flutter/material.dart';

class TransactionsPaymentScreen extends StatelessWidget {
  const TransactionsPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: primaryColor,
        body: ScreenBuilder(
            windows: TransactionPaymentWindowsScreen(),
            mobile: TransactionPaymentsScreenMobile()));
  }
}
