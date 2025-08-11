import 'package:cashier_system/core/responsive/screen_builder.dart';
import 'package:cashier_system/view/invoices/mobile/invoice_screen_mobile.dart';
import 'package:cashier_system/view/invoices/windows/invoices_screen_windows.dart';
import 'package:flutter/material.dart';

class InvoicesScreen extends StatelessWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenBuilder(
      mobile: InvoiceScreenMobile(),
      windows: InvoicesScreenWindows(),
    );
  }
}
