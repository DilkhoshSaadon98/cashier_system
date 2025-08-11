import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/constant/screen_routes.dart';
import 'package:cashier_system/core/dialogs/auth_dialog.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  bool isFullScreen = false;
  FocusNode focusNode = FocusNode();
  late TextEditingController username;
  late TextEditingController password;
  List<Map<String, dynamic>> data = [
    {
      'title': TextRoutes.cashier,
      'icon': AppImageAsset.cashierIcons,
      'shortcut': {
        LogicalKeyboardKey.keyC: 0,
      },
      'on_tap': () {
        Get.toNamed(AppRoute.cashierScreen);
      }
    },
    {
      'title': TextRoutes.receiptAndPayments,
      'icon': AppImageAsset.transactionIcons,
      'shortcut': {
        LogicalKeyboardKey.keyE: 1,
      },
      'on_tap': () {
        Get.toNamed(AppRoute.transactionScreen);
      }
    },
    {
      'title': TextRoutes.reports,
      'icon': AppImageAsset.reportsIcons,
      'shortcut': {
        LogicalKeyboardKey.keyR: 1,
      },
      'on_tap': () {
        Get.toNamed(AppRoute.reportsScreen);
      }
    },
    {
      'title': TextRoutes.purchaes,
      'icon': AppImageAsset.buyingIcons,
      'shortcut': {
        LogicalKeyboardKey.keyB: 3,
      },
      'on_tap': () {
        Get.toNamed(AppRoute.buyingScreen);
      }
    },
    {
      'title': TextRoutes.items,
      'icon': AppImageAsset.itemsIcons,
      'shortcut': {
        LogicalKeyboardKey.keyP: 4,
      },
      'on_tap': () {
        Get.toNamed(AppRoute.itemsScreen);
      }
    },
    {
      'title': TextRoutes.settings,
      'icon': AppImageAsset.settingIcons,
      'shortcut': {
        LogicalKeyboardKey.keyS: 5,
      },
      'on_tap': () {
        Get.toNamed(AppRoute.settingScreen);
      }
    },
    {
      'title': TextRoutes.accountingAccounts,
      'icon': AppImageAsset.accountingSvg,
      'shortcut': {
        LogicalKeyboardKey.keyA: 6,
      },
      'on_tap': () {
        Get.toNamed(AppRoute.addAccountScreen);
      }
    },
    {
      'title': TextRoutes.clientsAccounts,
      'icon': AppImageAsset.addAccount,
      'shortcut': {
        LogicalKeyboardKey.keyA: 6,
      },
      'on_tap': () {
        Get.toNamed(AppRoute.clientScreen);
      }
    },
    {
      'title': TextRoutes.invoices,
      'icon': AppImageAsset.invoicesSvg,
      'shortcut': {
        LogicalKeyboardKey.keyA: 6,
      },
      'on_tap': () {
        Get.toNamed(AppRoute.invoiceScreen);
      }
    },
  ];
  List<String> homeTitles = [
    TextRoutes.cashier,
    TextRoutes.impExp,
    TextRoutes.inventory,
    TextRoutes.buying,
    TextRoutes.settings,
    TextRoutes.items,
    TextRoutes.add
  ];

  List<String> homeIcons = [
    AppImageAsset.cashierIcons,
    AppImageAsset.transactionIcons,
    AppImageAsset.inventoryIcons,
    AppImageAsset.buyingIcons,
    AppImageAsset.settingIcons,
    AppImageAsset.itemsIcons,
    AppImageAsset.addItems,
  ];

  Map<LogicalKeyboardKey, int> keyToIndexMap = {
    LogicalKeyboardKey.keyC: 0,
    LogicalKeyboardKey.keyE: 1,
    LogicalKeyboardKey.keyI: 2,
    LogicalKeyboardKey.keyB: 3,
    LogicalKeyboardKey.keyS: 4,
    LogicalKeyboardKey.keyP: 5,
    LogicalKeyboardKey.keyA: 6,
  };

  List<void Function()> homeTab = [];

  HomeController() {
    // Initialize homeTab after object creation
    homeTab = [
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
        Get.toNamed(AppRoute.buyingScreen);
      },
      () {
        Get.toNamed(AppRoute.settingScreen);
      },
      () {
        Get.toNamed(AppRoute.itemsScreen);
      },
      () {
        Get.toNamed(AppRoute.itemsScreen);
      },
    ];
  }

  void handleSettingsTab() {
    if (myServices.sharedPreferences.getBool("settings") == null) {
      myServices.sharedPreferences.setBool("settings", false);
    }
    if (myServices.sharedPreferences.getString('admins_role') ==
        "Full Access") {
      if (myServices.sharedPreferences.getString('admins_role') ==
          "Full Access") {
        if (myServices.sharedPreferences.getBool("settings")! == false) {
          Get.back();
          Get.toNamed(AppRoute.settingScreen);
        } else {
          showAuthenticationDialog(navigatorKey.currentContext!,
              AppRoute.settingScreen, username, password);
        }
      }
    } else if (myServices.sharedPreferences.getString('admins_role') ==
        "Limit Access") {
      if (myServices.sharedPreferences.getBool("settings")! == false) {
        Get.back();
        Get.toNamed(AppRoute.settingScreen);
      } else {
        showErrorDialog("",
            title: "Fail", message: "You do not have access to this fields");
      }
    } else {
      Get.back();
      Get.toNamed(AppRoute.settingScreen);
    }
  }

  void fullScreen() {
    isFullScreen = !isFullScreen;
    update();
  }

  void logout() {
    myServices.sharedPreferences.setString("step", "login");
  }

  @override
  void onInit() {
    // Initialize controllers during onInit
    username = TextEditingController();
    password = TextEditingController();
    focusNode.requestFocus();

    precacheImage(
      const AssetImage(AppImageAsset.mainLogo),
      navigatorKey.currentContext!,
    );

    super.onInit();
  }

  @override
  void dispose() {
    focusNode.dispose();
    username.dispose();
    password.dispose();
    super.dispose();
  }
}
