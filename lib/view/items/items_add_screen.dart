import 'package:cashier_system/core/responsive/screen_builder.dart';
import 'package:cashier_system/view/items/mobile/items_add_screen_mobile.dart';
import 'package:cashier_system/view/items/windows/items_add_screen_windows.dart';
import 'package:flutter/material.dart';

class ItemsAddScreen extends StatelessWidget {
  const ItemsAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ScreenBuilder(
          windows: ItemsAddScreenWindows(), mobile: AddItemsScreenMobile()),
    );
  }
}
