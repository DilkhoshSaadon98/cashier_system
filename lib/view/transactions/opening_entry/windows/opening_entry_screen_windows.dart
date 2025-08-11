import 'package:cashier_system/core/responsive/divide_screen_widget.dart';
import 'package:cashier_system/view/transactions/opening_entry/widgets/opening_entry_action_widget.dart';
import 'package:cashier_system/view/transactions/opening_entry/widgets/opening_entry_table_widget.dart';
import 'package:flutter/material.dart';

class OpeningEntryScreenWindows extends StatelessWidget {
  const OpeningEntryScreenWindows({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DivideScreenWidget(
          //! Left Side Import:
          showWidget: OpeningEntryTableWidget(),
          //! Right Side Import:
          actionWidget: OpeningEntryActionWidget(
            isMobile: false,
          )),
    );
  }
}
