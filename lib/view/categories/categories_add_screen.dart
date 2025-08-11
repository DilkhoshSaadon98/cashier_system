import 'package:cashier_system/controller/catagories/catagories_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/responsive/screen_builder.dart';
import 'package:cashier_system/view/categories/mobile/categories_screen_mobile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesAddScreen extends StatelessWidget {
  const CategoriesAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CatagoriesController());
    return const Scaffold(
        backgroundColor: white,
        body: ScreenBuilder(
            windows: CategoriesScreenMobile(),
            mobile: CategoriesScreenMobile()));
  }
}
