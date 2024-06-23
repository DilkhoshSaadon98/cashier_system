import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/routes.dart';
import 'package:cashier_system/core/shared/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget customDrawer(BuildContext context, void Function()? onTap) {
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
          decoration: BoxDecoration(
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
            Get.toNamed(AppRoute.accountScreen);
          },
        ),
        ListTile(
          leading: const Icon(Icons.person_add_outlined),
          title: Text(
            'Add Admin'.tr,
            style: titleStyle.copyWith(fontSize: 18),
          ),
          onTap: () {
            Get.toNamed(AppRoute.addAdminScreen);
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings_outlined),
          title: Text(
            'Settings'.tr,
            style: titleStyle.copyWith(fontSize: 18),
          ),
          onTap: () {
            if (myServices.sharedPreferences.getBool("settings") == false ||
                myServices.sharedPreferences.getBool("settings") == null) {
              Get.toNamed(AppRoute.settingScreen);
            } else {
              customSnackBar(
                  "Fail", "Admin Password Reqired to Access Settings");
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text('About us'.tr, style: titleStyle.copyWith(fontSize: 18)),
          onTap: () {
            // Handle the About tap
            Navigator.pop(context);
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
