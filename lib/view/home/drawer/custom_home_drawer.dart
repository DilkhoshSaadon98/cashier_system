import 'dart:io';

import 'package:cashier_system/controller/home/home_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/screen_routes.dart';
import 'package:cashier_system/core/dialogs/auth_dialog.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

Widget customDrawer(BuildContext context, void Function()? onTap) {
  HomeController controller = Get.put(HomeController());
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text(
            myServices.sharedPreferences
                .getString("admins_username")
                .toString(),
            style: titleStyle.copyWith(color: white, fontSize: 20),
          ),
          accountEmail: Text(
            myServices.sharedPreferences.getString("admins_email") ?? "Admin",
            style: bodyStyle.copyWith(color: white, fontSize: 16),
          ),
          currentAccountPicture: const CircleAvatar(
            backgroundColor: white,
            radius: 40,
            child: Icon(
              Icons.person,
              size: 30,
            ),
          ),
          decoration: const BoxDecoration(
            color: primaryColor,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.person_pin_outlined),
          title: Text(
            'Account'.tr,
            style: titleStyle.copyWith(fontSize: 18),
          ),
          onTap: () {
            if (myServices.sharedPreferences.getBool("settings") == null) {
              myServices.sharedPreferences.setBool("settings", false);
            }
            if (myServices.sharedPreferences.getString('admins_role') ==
                "Full Access") {
              if (myServices.sharedPreferences.getBool("settings")! == false) {
                Get.back();
                Get.toNamed(AppRoute.accountScreen);
              } else {
                showAuthenticationDialog(context, AppRoute.accountScreen,
                    controller.username, controller.password);
              }
            } else if (myServices.sharedPreferences.getString('admins_role') ==
                "Limit Access") {
              if (myServices.sharedPreferences.getBool("settings")! == false) {
                Get.back();
                Get.toNamed(AppRoute.accountScreen);
              } else {
                showErrorDialog("",
                    title: "Fail",
                    message: "You do not have access to this fields");
              }
            } else {
              Get.back();
              Get.toNamed(AppRoute.accountScreen);
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.person_add_outlined),
          title: Text(
            'Add Admin'.tr,
            style: titleStyle.copyWith(fontSize: 18),
          ),
          onTap: () {
            if (myServices.sharedPreferences.getBool("settings") == null) {
              myServices.sharedPreferences.setBool("settings", false);
            }
            if (myServices.sharedPreferences.getString('admins_role') ==
                "Full Access") {
              if (myServices.sharedPreferences.getBool("settings")! == false) {
                Get.back();
                Get.toNamed(AppRoute.addAdminScreen);
              } else {
                showAuthenticationDialog(context, AppRoute.addAdminScreen,
                    controller.username, controller.password);
              }
            } else if (myServices.sharedPreferences.getString('admins_role') ==
                "Limit Access") {
              if (myServices.sharedPreferences.getBool("settings")! == false) {
                Get.back();
                Get.toNamed(AppRoute.addAdminScreen);
              } else {
                showErrorDialog("",
                    title: "Fail",
                    message: "You do not have access to this fields");
              }
            } else {
              Get.back();
              Get.toNamed(AppRoute.addAdminScreen);
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings_outlined),
          title: Text(
            'Settings'.tr,
            style: titleStyle.copyWith(fontSize: 18),
          ),
          onTap: () {
            if (myServices.sharedPreferences.getBool("settings") == null) {
              myServices.sharedPreferences.setBool("settings", false);
            }
            if (myServices.sharedPreferences.getString('admins_role') ==
                "Full Access") {
              if (myServices.sharedPreferences.getBool("settings")! == false) {
                Get.back();
                Get.toNamed(AppRoute.settingScreen);
              } else {
                showAuthenticationDialog(context, AppRoute.settingScreen,
                    controller.username, controller.password);
              }
            } else if (myServices.sharedPreferences.getString('admins_role') ==
                "Limit Access") {
              if (myServices.sharedPreferences.getBool("settings")! == false) {
                Get.back();
                Get.toNamed(AppRoute.settingScreen);
              } else {
                showErrorDialog("",
                    title: "Fail",
                    message: "You do not have access to this fields");
              }
            } else {
              Get.back();
              Get.toNamed(AppRoute.settingScreen);
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.fullscreen),
          title:
              Text('Full Screen'.tr, style: titleStyle.copyWith(fontSize: 18)),
          onTap: () {
            controller.fullScreen();
            windowManager.setFullScreen(controller.isFullScreen);
          },
        ),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: Text('Exit'.tr, style: titleStyle.copyWith(fontSize: 18)),
          onTap: () {
            exit(0);
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: Text('Logout'.tr, style: titleStyle.copyWith(fontSize: 18)),
          onTap: onTap,
        ),
      ],
    ),
  );
}
