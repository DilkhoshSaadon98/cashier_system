
import 'package:cashier_system/core/responsive/divide_screen_widget.dart';
import 'package:cashier_system/view/clients/widgets/client_action_widget.dart';
import 'package:cashier_system/view/clients/widgets/client_customers_table_widget.dart';
import 'package:flutter/material.dart';

class ClientScreenWindows extends StatelessWidget {
  const ClientScreenWindows({super.key});

  @override
  Widget build(BuildContext context) {
    return const DivideScreenWidget(
        showWidget: CustomerClientTableWidget(),
        actionWidget: ClientActionWidget(
          isMobile: false,
        ));
  }
}
