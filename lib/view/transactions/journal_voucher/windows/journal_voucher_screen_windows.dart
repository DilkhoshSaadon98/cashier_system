
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/responsive/divide_screen_widget.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/view/transactions/journal_voucher/widgets/journal_voucher_action_widget.dart';
import 'package:cashier_system/view/transactions/journal_voucher/widgets/journal_voucher_table_data.dart';
import 'package:flutter/material.dart';

class JournalVoucherScreenWindows extends StatelessWidget {
  const JournalVoucherScreenWindows({super.key});

  @override
  Widget build(BuildContext context) {
    return DivideScreenWidget(
      showWidget: Scaffold(
        appBar: customAppBarTitle(TextRoutes.journalVoucher),
        body: const JournalVoucherTableData(),
      ),
      actionWidget: JournalVoucherActionWidget(isMobile: false,)
    );
  }
}
