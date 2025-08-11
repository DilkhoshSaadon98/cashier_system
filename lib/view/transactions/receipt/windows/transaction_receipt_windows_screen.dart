import 'package:cashier_system/core/responsive/divide_screen_widget.dart';
import 'package:cashier_system/view/transactions/receipt/widgets/transaction_receipt_action_widget.dart';
import 'package:cashier_system/view/transactions/receipt/widgets/transaction_receipt_table_widget.dart';
import 'package:flutter/material.dart';

class TransactionReceiptWindowsScreen extends StatelessWidget {
  const TransactionReceiptWindowsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DivideScreenWidget(
          //! Left Side Import:
          showWidget: TransactionReceiptTableWidget(),
          //! Right Side Import:
          actionWidget: TransactionReceiptActionWidget(
            isMobile: false,
          )),
    );
  }
}
