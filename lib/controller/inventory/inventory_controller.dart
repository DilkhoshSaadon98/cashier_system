import 'package:cashier_system/controller/inventory/inventory_definitions_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/data/model/box_model.dart';
import 'package:cashier_system/data/model/debtors_model.dart';
import 'package:cashier_system/data/model/export_model.dart';
import 'package:cashier_system/data/model/import_model.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/data/model/invoice_model.dart';
import 'package:cashier_system/data/model/total_profit_model.dart';
import 'package:cashier_system/data/sql/data/inventory_data/creditor_deptor_class.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InventoryController extends InventoryDefinitionsController {
  int currentIndex = 0;
  updateIndex(int index) {
    currentIndex = index;
    update();
  }

  //? Pick Date for fileds
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

  selectAllRows(var data, String id, List selectedRow) {
    if (selectedRow.length == data.length) {
      selectedRow.clear();
    } else {
      for (int i = 0; i <= data.length - 1; i++) {
        selectedRow.add(data[i].id.toString());
      }
    }
    update();
  }

  void checkValueFunction() {
    checkValue = !checkValue;
    update();
  }

  void changeIndex(String title) {
    print(title);
    if (title == "Box") {
      myServices.sharedPreferences.setString("inventory_title", "Box");
      myServices.sharedPreferences.setInt("inventory_index", 0);
      getBoxData();
      getImportData();
      getExportData();
      selectedRows.clear();
    }
    if (title == "Profits") {
      myServices.sharedPreferences.setString("inventory_title", "Profits");
      myServices.sharedPreferences.setInt("inventory_index", 1);
      getProfitData();
      selectedRows.clear();
    }

    if (title == "Expenses") {
      myServices.sharedPreferences.setString("inventory_title", "Expenses");
      myServices.sharedPreferences.setInt("inventory_index", 2);
      getExpenseData();
      exportSelectedRows.clear();
    }
    if (title == "Imports") {
      myServices.sharedPreferences.setString("inventory_title", "Imports");
      myServices.sharedPreferences.setInt("inventory_index", 3);
      getImportData();
    }
    if (title == "Exports") {
      myServices.sharedPreferences.setString("inventory_title", "Exports");
      myServices.sharedPreferences.setInt("inventory_index", 4);
      getExportData();
    }
    if (title == "Total Profit / Invertory") {
      myServices.sharedPreferences
          .setString("inventory_title", "Total Profit / Invertory");
      myServices.sharedPreferences.setInt("inventory_index", 5);
      getExpenseData();
      getTotalProfitInventoryData();
      getProfitData();
      selectedRows.clear();
    }
    if (title == "Debtor") {
      myServices.sharedPreferences.setString("inventory_title", "Debtor");
      myServices.sharedPreferences.setInt("inventory_index", 6);
      getDebtorData();
    }
    if (title == "Creditor") {
      myServices.sharedPreferences.setString("inventory_title", "Debtor");
      myServices.sharedPreferences.setInt("inventory_index", 7);
    }
    update();
  }

  void checkSelectedRows(bool value, String id, List selectedRow) {
    if (value == true) {
      selectedRow.add(id);
    } else {
      selectedRow.removeWhere((element) => element == id);
    }
    update();
  }

  searchButton(int index) {
    if (index == 0) {
      if (currentIndex == 0) {
        getBoxData();
      } else if (currentIndex == 1) {
        getBoxData();
      } else if (currentIndex == 2) {
        getImportData();
      } else if (currentIndex == 3) {
        getExportData();
      }
    }
    if (index == 1) {
      getProfitData();
    }

    if (index == 2) {
      getExpenseData();
    }
    if (index == 3) {
      getImportData();
    }
    if (index == 4) {
      getExportData();
    }
    if (index == 5) {
      getTotalProfitInventoryData();
    }
  }

  //! ////////////////// Get Box Data ///////////////////////
  getBoxData() async {
    String? startNo;
    String? endNo;
    String? startTime;
    String? endTime;
    var response = {};
    if (fromDateController.text.isNotEmpty &&
        toDateController.text.isNotEmpty) {
      startTime = fromDateController.text;
      endTime = toDateController.text;
    }
    if (fromNOController.text.isNotEmpty && toNOController.text.isNotEmpty) {
      startNo = fromNOController.text;
      endNo = toNOController.text;
    }
    response = await boxClass.getBoxData(
        startNo: startNo, endNo: endNo, startTime: startTime, endTime: endTime);
    if (response['status'] == "success") {
      boxData.clear();
      boxDataAll.clear();
      clearFields();
      List responsedata = response['data']['data'] ?? [];
      List allResponsedata = response['all_data']['data'] ?? [];
      boxData.addAll(responsedata.map((e) => InvoiceModel.fromJson(e)));
      boxDataAll.addAll(allResponsedata.map((e) => BoxModel.fromJson(e)));
      totalInvoicePrice = response['total_box_price'];
      totalInvoiceCost = response['total_box_cost'];
      totalImportPrice = response['total_import_price'];
      totalExportPrice = response['total_export_price'];
      totalInventoryPrice =
          totalInvoicePrice + totalImportPrice - totalExportPrice;
    }
    update();
  }

  //! ////////////////// Get Profit Data ////////////////////
  getProfitData() async {
    String? startNo;
    String? endNo;
    String? startTime;
    String? endTime;
    var response = {};
    if (fromDateController.text.isNotEmpty &&
        toDateController.text.isNotEmpty) {
      startTime = fromDateController.text;
      endTime = toDateController.text;
    }
    if (fromNOController.text.isNotEmpty && toNOController.text.isNotEmpty) {
      startNo = fromNOController.text;
      endNo = toNOController.text;
    }
    response = await profitClass.getProfitData(
        startNo: startNo, endNo: endNo, startTime: startTime, endTime: endTime);
    if (response['status'] == "success") {
      clearFields();
      profitData.clear();
      totalInvoicePrice = 0;
      totalInvoiceCost = 0;
      totalInventoryPrice = 0;
      List responsedata = response['data']['data'] ?? [];
      profitData.addAll(responsedata.map((e) => InvoiceModel.fromJson(e)));
      totalInvoicePrice = response['total_Invoice_price'];
      totalInvoiceCost = response['total_invoice_cost'];
      totalInventoryPrice = totalInvoicePrice - totalInvoiceCost;
    }
    update();
  }

  //! ////////////////// Get Expenses Data ///////////////////
  getExpenseData() async {
    String? startNo;
    String? endNo;
    String? startTime;
    String? endTime;
    var response = {};
    if (fromDateController.text.isNotEmpty &&
        toDateController.text.isNotEmpty) {
      startTime = fromDateController.text;
      endTime = toDateController.text;
    }
    if (fromNOController.text.isNotEmpty && toNOController.text.isNotEmpty) {
      startNo = fromNOController.text;
      endNo = toNOController.text;
    }
    response = await expensesClass.getExpensesData(
        startNo: startNo, endNo: endNo, startTime: startTime, endTime: endTime);
    if (response['status'] == "success") {
      expensesData.clear();
      clearFields();
      List responsedata = response['data']['data'] ?? [];
      expensesData.addAll(responsedata.map((e) => ExportModel.fromJson(e)));
      totalExpensesPrice = response['total_expenses_price'];
      totalInventoryPrice = response['total_expenses_price'];
    }
    update();
  }

  //! ////////////////// Get Import Data //////////////////
  getImportData() async {
    String? startNo;
    String? endNo;
    String? startTime;
    String? endTime;
    var response = {};
    if (fromDateController.text.isNotEmpty &&
        toDateController.text.isNotEmpty) {
      startTime = fromDateController.text;
      endTime = toDateController.text;
    }
    if (fromNOController.text.isNotEmpty && toNOController.text.isNotEmpty) {
      startNo = fromNOController.text;
      endNo = toNOController.text;
    }
    response = await importExportClass.getImportData(
        startNo: startNo, endNo: endNo, startTime: startTime, endTime: endTime);
    if (response["status"] == 'success') {
      totalInventoryPrice = 0;
      importData.clear();
      clearFields();
      List listData = response['data']['data'] ?? [];
      importData.addAll(listData.map((e) => ImportModel.fromJson(e)));
      totalInventoryPrice = response["total_ballance"];
    }
    update();
  }

  //! ////////////////// Get Export Data //////////////////
  getExportData() async {
    String? startNo;
    String? endNo;
    String? startTime;
    String? endTime;
    var response = {};
    if (fromDateController.text.isNotEmpty &&
        toDateController.text.isNotEmpty) {
      startTime = fromDateController.text;
      endTime = toDateController.text;
    }
    if (fromNOController.text.isNotEmpty && toNOController.text.isNotEmpty) {
      startNo = fromNOController.text;
      endNo = toNOController.text;
    }
    response = await importExportClass.getExportData(
        startNo: startNo, endNo: endNo, startTime: startTime, endTime: endTime);
    if (response["status"] == 'success') {
      exportData.clear();
      clearFields();
      List listData = response['data']['data'] ?? [];
      totalInventoryPrice = response["total_ballance"];
      exportData.addAll(listData.map((e) => ExportModel.fromJson(e)));
    }
    update();
  }

  //! /////// Get Total Profit / Inventory Data //////////
  getTotalProfitInventoryData() async {
    String? startNo;
    String? endNo;
    String? startTime;
    String? endTime;
    var response = {};
    if (fromDateController.text.isNotEmpty &&
        toDateController.text.isNotEmpty) {
      startTime = fromDateController.text;
      endTime = toDateController.text;
    }
    if (fromNOController.text.isNotEmpty && toNOController.text.isNotEmpty) {
      startNo = fromNOController.text;
      endNo = toNOController.text;
    }
    response = await totalProfitClass.getProfitData(
        startNo: startNo, endNo: endNo, startTime: startTime, endTime: endTime);
    if (response['status'] == "success") {
      clearFields();
      profitData.clear();
      totalInvoicePrice = 0;
      totalInvoiceCost = 0;
      totalProfitPrice = 0;
      totalInventoryPrice = 0;
      totalExpensesProfitPrice = 0;
      totalProfitModel.clear();
      profitData.clear();
      List responsedata = response['data']['data'] ?? [];
      List profitResponsedata = response['profit_data']['data'] ?? [];
      totalProfitModel
          .addAll(responsedata.map((e) => TotalProfitModel.fromJson(e)));
      profitData
          .addAll(profitResponsedata.map((e) => InvoiceModel.fromJson(e)));
      totalInvoicePrice = response['total_Invoice_price'];
      totalInvoiceCost = response['total_invoice_cost'];
      totalExpensesProfitPrice = response['total_expenses_price'];
      totalInventoryPrice = totalInvoicePrice - totalExpensesProfitPrice;
    }
    update();
  }

  CreditorDebtorClass creditorDebtorClass = CreditorDebtorClass();
  //! /////// Get Deptor  Data //////////
  getDebtorData() async {
    String? startNo;
    String? endNo;
    String? startTime;
    String? endTime;
    var response = {};
    if (fromDateController.text.isNotEmpty &&
        toDateController.text.isNotEmpty) {
      startTime = fromDateController.text;
      endTime = toDateController.text;
    }
    if (fromNOController.text.isNotEmpty && toNOController.text.isNotEmpty) {
      startNo = fromNOController.text;
      endNo = toNOController.text;
    }
    response = await creditorDebtorClass.getDebtorData(
        startNo: startNo, endNo: endNo, startTime: startTime, endTime: endTime);
    if (response['status'] == "success") {
      clearFields();
      List responsedata = response['data']['data'] ?? [];
      print(responsedata);
      debtorsData.clear();
      debtorsData.addAll(responsedata.map((e) => DebtorsModel.fromJson(e)));
    }
    update();
  }

  deleteTableRow(String table, String sql) async {
    int response = await sqlDb.deleteData(table, sql);
    if (response > 0) {
      getBoxData();
      if (table == "tbl_invoice") {
        getProfitData();
      }
      if (table == "tbl_import") {
        getImportData();
      }
      if (table == "tbl_export") {
        getExportData();
      }
    }
  }

  getInitialData() async {
    if (myServices.sharedPreferences.getString("inventory_title") == null) {
      myServices.sharedPreferences.setString("inventory_title", "Box");
      myServices.sharedPreferences.setInt("inventory_index", 0);
    } else {
      if (myServices.sharedPreferences.getString("inventory_title") == "Box" ||
          myServices.sharedPreferences.getString("inventory_title")!.isEmpty) {
        getBoxData();
        getImportData();
        getExportData();
      } else if (myServices.sharedPreferences.getString("inventory_title") ==
          "Profits") {
        getProfitData();
      } else if (myServices.sharedPreferences.getString("inventory_title") ==
          "Imports") {
        getImportData();
      } else if (myServices.sharedPreferences.getString("inventory_title") ==
          "Exports") {
        getExportData();
      } else if (myServices.sharedPreferences.getString("inventory_title") ==
          "Expenses") {
        getExpenseData();
      } else if (myServices.sharedPreferences.getString("inventory_title") ==
          "Total Profit / Invertory") {
        getTotalProfitInventoryData();
        getExpenseData();
      } else if (myServices.sharedPreferences.getString("inventory_title") ==
          "Debtor") {
        getDebtorData();
      }
    }
  }

  @override
  void onInit() {
    getInitialData();
    catID = TextEditingController();
    catName = TextEditingController();
    super.onInit();
  }
}
