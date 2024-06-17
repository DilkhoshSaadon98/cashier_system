import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/routes.dart';
import 'package:cashier_system/core/shared/custom_snack_bar.dart';
import 'package:cashier_system/data/model/users_model.dart';
import 'package:cashier_system/data/sql/data/users_class.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  UsersClass usersClass = UsersClass();
  //* users list:
  List<SelectedListItem> dropDownListUsers = [];
  List<UsersModel> listdataSearchUsers = [];
  //?
  int currentIndex = 0;
  //? Securit Controller:

  TextEditingController? oldUsername;
  TextEditingController? newUsername;
  TextEditingController? oldPassword;
  TextEditingController? newPassword;
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
    "Customers Details",
    "System Language",
    "Invoice",
  ];
  List<String> securitySwitchTitle = [
    "Show Data",
    "Login",
    "Settings",
  ];
  List<bool> securitySwitchState = [
    true,
    true,
    true,
  ];

  int currentTab = 0;

  changeIndex(int index) {
    currentIndex = index;
    update();
  }

  //! Get Users For Cart Owner;
  getUsers() async {
    var response = await usersClass.getUserData();
    if (response['status'] == 'success') {
      listdataSearchUsers.clear();
      dropDownListUsers.clear();
      List responsedata = response['data']['data'] ?? [];
      listdataSearchUsers
          .addAll(responsedata.map((e) => UsersModel.fromJson(e)));

      for (int i = 0; i < listdataSearchUsers.length; i++) {
        dropDownListUsers.add(SelectedListItem(
            name: listdataSearchUsers[i].usersName!,
            value: listdataSearchUsers[i].usersId!.toString()));
      }
      update();
    }
  }

  searchUsers(String userId) async {
    var response = await usersClass.getUserData(userId: userId);
    if (response['status'] == 'success') {
      listdataSearchUsers.clear();
      dropDownListUsers.clear();
      List responsedata = response['data']['data'];
      listdataSearchUsers
          .addAll(responsedata.map((e) => UsersModel.fromJson(e)));
      userNameController.text = listdataSearchUsers[0].usersName!;
      userPhone1Controller.text = listdataSearchUsers[0].usersPhone!;
      userPhone2Controller.text = listdataSearchUsers[0].usersPhone2 ?? "";
      userEmailController.text = listdataSearchUsers[0].usersEmail ?? "";
      userAddressController.text = listdataSearchUsers[0].usersAddress ?? "";
      userNoteController.text = listdataSearchUsers[0].usersNote ?? "";
      userRoleController.text = listdataSearchUsers[0].usersRole!;
      update();
    }
  }

  addUsers() async {
    Map<String, dynamic> data = {
      "users_name": userNameController.text,
      "users_email": userEmailController.text,
      "users_phone": userPhone1Controller.text,
      "users_phone2": userPhone2Controller.text,
      "users_note": userNoteController.text,
      "users_address": userAddressController.text,
      "users_role": userRoleController.text,
      "users_createdate": currentTime
    };
    if (userIdController.text.isEmpty) {
      int response = await usersClass.addUser(data);
      if (response > 0) {
        customSnackBar("Success", "users added success");
        getUsers();
        clearFileds();
      }
    } else {}
  }

  editUsers() async {
    Map<String, dynamic> data = {
      "users_name": userNameController.text,
      "users_email": userEmailController.text,
      "users_phone": userPhone1Controller.text,
      "users_phone2": userPhone2Controller.text,
      "users_note": userNoteController.text,
      "users_address": userAddressController.text,
      "users_role": userRoleController.text,
    };
    if (userNameController.text.isNotEmpty) {
      int response = await usersClass.editUser(data, userIdController.text);
      if (response > 0) {
        customSnackBar("Success", "user details updated success");
        getUsers();
        clearFileds();
      }
    } else {
      customSnackBar("Error", "Username Can not be Empty");
    }
  }

  deleteUser() async {
    int response = await usersClass.deleteUser(userIdController.text);
    if (response > 0) {
      customSnackBar("Success", "User deleted success");
      getUsers();
      clearFileds();
    }
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
    getUsers();
    super.onInit();
  }
}
