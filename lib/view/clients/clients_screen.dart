import 'package:cashier_system/core/responsive/screen_builder.dart';
import 'package:cashier_system/view/clients/mobile/client_screen_mobile.dart';
import 'package:cashier_system/view/clients/windows/client_screen_windows.dart';
import 'package:flutter/material.dart';

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ScreenBuilder(
          windows: ClientScreenWindows(), mobile: ClientScreenMobile()),
    );
  }
}
