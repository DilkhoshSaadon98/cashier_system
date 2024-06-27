import 'package:cashier_system/data/model/box_model.dart';
import 'package:cashier_system/data/model/debtors_model.dart';
import 'package:cashier_system/data/model/export_model.dart';
import 'package:cashier_system/data/model/import_model.dart';
import 'package:cashier_system/data/model/invoice_model.dart';
import 'package:cashier_system/data/model/total_profit_model.dart';
import 'package:cashier_system/data/sql/data/inventory_data/imp_exp_class.dart';
import 'package:cashier_system/data/sql/data/inventory_data/box_class.dart';
import 'package:cashier_system/data/sql/data/inventory_data/expenses_class.dart';
import 'package:cashier_system/data/sql/data/inventory_data/invoice_class.dart';
import 'package:cashier_system/data/sql/data/inventory_data/profit_inventory_class.dart';
import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:cashier_system/view/inventory/components/deptor/debtor_table_rows.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InventoryDefinitionsController extends GetxController {
  //? Inventory Controller Define:
  TextEditingController? catName = TextEditingController();
  TextEditingController? catID = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController toNOController = TextEditingController();
  TextEditingController fromNOController = TextEditingController();
  //? Time
  DateTime selectedDate = DateTime.now();
  //? Selecting :
  List selectedRows = [];
  List invoiceSelectedRows = [];
  List importSelectedRows = [];
  List exportSelectedRows = [];
  bool checkValue = false;
  //? SQL Classes :
  ProfitClass profitClass = ProfitClass();
  ImportExportClass importExportClass = ImportExportClass();
  ExpensesClass expensesClass = ExpensesClass();
  TotalProfitClass totalProfitClass = TotalProfitClass();
  BoxClass boxClass = BoxClass();
  SqlDb sqlDb = SqlDb();
  //? Define Data Model List:
  List<InvoiceModel> profitData = [];
  List<InvoiceModel> boxData = [];
  List<BoxModel> boxDataAll = [];
  List<DebtorsModel> debtorsData = [];
  List<TotalProfitModel> totalProfitModel = [];
  List<ExportModel> expensesData = [];
  List<ImportModel> importData = [];
  List<ExportModel> exportData = [];
  //! Var for storing values:
  //?total Inventory Price
  int totalInventoryPrice = 0;
  //? Profits :
  int totalInvoicePrice = 0;
  int totalInvoiceCost = 0;
  int totalProfitPrice = 0;
  //? Box :
  int totalBoxPrice = 0;
  int totalBoxCost = 0;
  int totalBoxProfitPrice = 0;
  int totalImportPrice = 0;
  int totalExportPrice = 0;
  //? Import:
  int totalImportBallance = 0;
  //? Export :
  int totalExportBallance = 0;
  //? Expenses :
  int totalExpensesProfitPrice = 0;
  int totalExpensesPrice = 0;
  //? Clear all TextEditing Controller:
  clearFields() {
    fromDateController.clear();
    toDateController.clear();
    fromNOController.clear();
    toNOController.clear();
  }
}
