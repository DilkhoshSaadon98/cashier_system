import 'package:cashier_system/controller/items/items_controller.dart';
import 'package:cashier_system/core/responsive/screen_builder.dart';
import 'package:cashier_system/view/items/mobile/items_view_screen_mobile.dart';
import 'package:cashier_system/view/items/windows/items_view_screen_windows.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemsViewScreen extends StatelessWidget {
  const ItemsViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ItemsViewController());
    return const Scaffold(
      body: ScreenBuilder(
          windows: ItemsViewScreenWindows(), mobile: ItemsViewScreenMobile()),
    );
  }
}
