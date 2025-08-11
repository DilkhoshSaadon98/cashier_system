
import 'package:cashier_system/data/model/locale/custom_selected_list_users.dart';
import 'package:cashier_system/data/model/users_model.dart';
import 'package:cashier_system/data/source/users_class.dart';
import 'package:cashier_system/view/settings/mobile/back_up_screen_mobile.dart';
import 'package:cashier_system/view/settings/mobile/language_screen_mobile.dart';
import 'package:cashier_system/view/settings/mobile/security_screen_mobile.dart';
import 'package:cashier_system/view/settings/mobile/system_update_mobile.dart';
import 'package:cashier_system/view/settings/windows/tabs/currency_windows.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  UsersClass usersClass = UsersClass();
  //* users list:
  List<CustomSelectedListUsers> dropDownListUsers = [];
  List<UsersModel> listDataSearchUsers = [];
  //?
  int currentIndex = 0;
  List<bool> isHovering = [];
  checkHover(bool value, int index) {
    isHovering[index] = value;
    update();
  }

  //?
  TextEditingController userIdController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPhone1Controller = TextEditingController();
  TextEditingController userPhone2Controller = TextEditingController();
  TextEditingController userAddressController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userNoteController = TextEditingController();
  TextEditingController userRoleController = TextEditingController();
  TextEditingController userRoleIdController = TextEditingController();
  List<String> settingTabName = [
    "Security",
    "Back Up",
    "System Update",
    "System Language",
    "System Currency",
  ];
  List<void Function()?> settingTabFunction = [
    () {
      Get.to(
        () => const SecurityScreenMobile(),
      );
    },
    () {
      Get.to(
        () => const BackUpScreenMobile(),
      );
    },
    () {
      Get.to(
        () => const SystemUpdateMobile(),
      );
    },
    () {
      Get.to(
        () => const LanguageScreenMobile(),
      );
    },
    () {
      Get.to(
        () => const CurrencyWindows(),
      );
    },
  ];

  int currentTab = 0;

  changeIndex(int index) {
    currentIndex = index;
    update();
  }

 



  clearFileds() {
    userIdController.clear();
    userNameController.clear();
    userPhone1Controller.clear();
    userPhone2Controller.clear();
    userAddressController.clear();
    userEmailController.clear();
    userNoteController.clear();
    userRoleController.clear();
    userRoleIdController.clear();
  }

  @override
  void onInit() {
    isHovering = List<bool>.filled(settingTabName.length, false);
    super.onInit();
  }
}
