import 'package:cashier_system/core/responsive/screen_builder.dart';
import 'package:cashier_system/view/items/mobile/items_edit_screen_mobile.dart';
import 'package:cashier_system/view/items/windows/items_update_screen_windows.dart';
import 'package:flutter/material.dart';

class ItemsEditScreen extends StatelessWidget {
  const ItemsEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ScreenBuilder(
          windows: ItemsUpdateScreenWindows(), mobile: ItemsEditScreenMobile()),
    );
  }
}
