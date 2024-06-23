import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/constant/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  bool isFullScreen = false;
  FocusNode focusNode = FocusNode();

  List<String> homeTitles = [
    "Cashier",
    "Imp/Exp",
    "Inventory",
    "Buying",
    "Catagories",
    "Items",
  ];
  List<String> homeIcons = [
    AppImageAsset.cashierIcons,
    AppImageAsset.importIcons,
    AppImageAsset.inventoryIcons,
    AppImageAsset.buyingIcons,
    AppImageAsset.itemsIcons,
    AppImageAsset.itemsIcons,
    AppImageAsset.settingIcons,
  ];
  Map<LogicalKeyboardKey, int> keyToIndexMap = {
    LogicalKeyboardKey.keyC: 0,
    LogicalKeyboardKey.keyE: 1,
    LogicalKeyboardKey.keyI: 2,
    LogicalKeyboardKey.keyB: 3,
    LogicalKeyboardKey.keyV: 4,
    LogicalKeyboardKey.keyP: 5,
    LogicalKeyboardKey.keyS: 6,
  };
  List<void Function()> homeTab = [
    () {
      Get.toNamed(AppRoute.cashierScreen);
    },
    () {
      Get.toNamed(AppRoute.importExportScreen);
    },
    () {
      Get.toNamed(AppRoute.inventoryScreen);
    },
    () {
      Get.toNamed(AppRoute.buingScreen);
    },
    () {
      Get.toNamed(AppRoute.catagoriesScreen);
    },
    () {
      Get.toNamed(AppRoute.itemsScreen);
    },
    () {
      Get.toNamed(AppRoute.settingScreen);
    },
  ];
  fullScreen() {
    isFullScreen = !isFullScreen;
    update();
  }

  logout() {
    myServices.sharedPreferences.setString("step", "1");
  }

  @override
  void onInit() {
    focusNode.requestFocus();

    super.onInit();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }
}
