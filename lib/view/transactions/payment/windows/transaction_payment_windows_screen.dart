
import 'package:cashier_system/core/responsive/divide_screen_widget.dart';
import 'package:cashier_system/view/transactions/payment/widgets/transaction_payment_action_widget.dart';
import 'package:cashier_system/view/transactions/payment/widgets/transaction_payment_table_widget.dart';
import 'package:flutter/material.dart';

class TransactionPaymentWindowsScreen extends StatelessWidget {
  const TransactionPaymentWindowsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DivideScreenWidget(
            //! Left Side Import:
            showWidget: TransactionPaymentTableWidget(),
            //! Right Side Import:
            actionWidget: TransactionPaymentActionWidget(isMobile: false,))
    );
  }
}
