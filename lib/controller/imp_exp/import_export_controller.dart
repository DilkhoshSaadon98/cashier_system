import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/data/model/export_model.dart';
import 'package:cashier_system/data/model/import_model.dart';
import 'package:cashier_system/data/model/users_model.dart';
import 'package:cashier_system/data/sql/data/imp_exp/export_class.dart';
import 'package:cashier_system/data/sql/data/imp_exp/import_class.dart';
import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ImportExportController extends GetxController {
  //? All Field Controller :
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController accountControllerName = TextEditingController();
  TextEditingController accountControllerId = TextEditingController();
  TextEditingController userControllerName = TextEditingController();
  TextEditingController userControllerId = TextEditingController();
  TextEditingController noFromController = TextEditingController();
  TextEditingController noToController = TextEditingController();
  TextEditingController dateToController = TextEditingController();
  TextEditingController dateFromController = TextEditingController();
  //?
  SqlDb sqlDb = SqlDb();
  //? Define Sql Classes
  ExportClass exportClass = ExportClass();
  ImportClass importClass = ImportClass();
  //? Var to store ballances:
  int totalImportBallance = 0;
  int totalExportBallance = 0;
  //?Define Data Models:
  List<ImportModel> importData = [];
  List<ExportModel> exportData = [];
  List<UsersModel> listdataSearchUsers = [];
  List<SelectedListItem> dropDownListUsers = [];
  //? Selecting var:
  String selectedScreenTitle = "Search";
  int seslectedIndex = 0;
  List<String> selectedRowsImports = [];
  List<String> selectedRowsExports = [];
  bool checkValue = false;
  //? Time Var:
  DateTime selectedDate = DateTime.now();
  changeSelectedScreenTitle(title) {
    selectedScreenTitle = title;
    update();
  }

  changeSelectedIndex(int index) {
    seslectedIndex = index;
    update();
  }

  //? Get current date Data for date picker
  Future<void> selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      barrierColor: primaryColor.withOpacity(.3),
      initialDate: selectedDate,
      firstDate: DateTime(2024, 1),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) selectedDate = picked;
    controller.text = DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDate);
    update();
  }

  //? Select All Rows:
  selectAllRows() {
    if (selectedRowsImports.length == importData.length) {
      selectedRowsImports.clear();
    } else {
      for (int i = 0; i <= importData.length - 1; i++) {
        selectedRowsImports.add(importData[i].importId.toString());
      }
    }
    update();
  }

  void checkSelectedRowsImports(bool value, int index) {
    if (value == true) {
      selectedRowsImports.add(importData[index].importId.toString());
    } else {
      selectedRowsImports.removeWhere(
          (element) => element == importData[index].importId.toString());
    }
    update();
  }

  //? Select All Rows:
  selectAllRowsExports() {
    if (selectedRowsExports.length == exportData.length) {
      selectedRowsExports.clear();
    } else {
      for (int i = 0; i <= exportData.length - 1; i++) {
        selectedRowsExports.add(exportData[i].exportId.toString());
      }
    }
    update();
  }

  void checkSelectedRowsExports(bool value, int index) {
    if (value == true) {
      selectedRowsExports.add(exportData[index].exportId.toString());
    } else {
      selectedRowsExports.removeWhere(
          (element) => element == exportData[index].exportId.toString());
    }
    update();
  }

  void checkValueFunction() {
    checkValue = !checkValue;
    update();
  }

//? Get Users Data;
  getUsers() async {
    var response = await sqlDb.getAllData("tbl_users");
    if (response['status'] == "success") {
      dropDownListUsers.clear();
      listdataSearchUsers.clear();
      List responsedata = response['data'];
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

//? Clear All Fields
  clearFileds() {
    userControllerId.clear();
    userControllerName.clear();
    accountControllerId.clear();
    accountControllerName.clear();
    noteController.clear();
    amountController.clear();
    dateController.clear();
    noFromController.clear();
    noToController.clear();
    dateFromController.clear();
    dateToController.clear();
  }

  @override
  void onInit() {
    getUsers();
    super.onInit();
  }
}
