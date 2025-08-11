import 'package:cashier_system/core/class/statusrequest.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/core/dialogs/snackbar_helper.dart';
import 'package:cashier_system/core/functions/handing_data_controller.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/data/model/reports/invoices_salary_model.dart';
import 'package:cashier_system/data/source/reports/billing_profits_data.dart';
import 'package:cashier_system/data/source/reports/financial_reports_data.dart';
import 'package:cashier_system/view/reports/daily_reports/general_ledger/general_ledger_table.dart';
import 'package:cashier_system/view/reports/daily_reports/trial_balance/trial_balance_table.dart';
import 'package:cashier_system/view/reports/financial_reports/balance_sheet/balance_sheet_widget.dart';
import 'package:cashier_system/view/reports/financial_reports/income_statemnent/income_statement_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FinancialReportsController extends GetxController {
  //! --------------------------------------------------------
  //? Toggle transaction Section Tables:
  String selectedSection =
      myServices.sharedPreferences.getString("financial_reports_header") ??
          TextRoutes.incomeStatement;

  changeSection(value, FinancialReportsController controller) {
    itemsOffset = 0;
    selectedSection = value;
    onSearchData(true)();
    changeTableWidget(controller);
    myServices.sharedPreferences.setString('financial_reports_header', value);
    update();
  }

  List<InvoicesSalaryModel> billingInvoicesData = [];
  List<int> selectedBillingInvoicesData = [];
  //! --------------------------------------------------------
  //? Search Controller:
  TextEditingController fromNoController = TextEditingController();
  TextEditingController toNoController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController accountNameController = TextEditingController();
  TextEditingController itemsNameController = TextEditingController();
  TextEditingController itemsQtyController = TextEditingController();
  clearAllData() {
    fromDateController.clear();
    toDateController.clear();
    fromNoController.clear();
    toNoController.clear();
    accountNameController.clear();
    onSearchData(true)();
  }

  //! --------------------------------------------------------
  //? Scrolling Constants
  ScrollController scrollControllers = ScrollController();
  bool hasMoreData = true;
  int itemsPerPage = 50;
  int itemsOffset = 0;
  bool isLoading = false;
  bool showBackToTopButton = false;
  void initScrolls() {
    scrollControllers.addListener(() {
      bool shouldShow = scrollControllers.offset > 20;
      if (showBackToTopButton != shouldShow) {
        showBackToTopButton = shouldShow;
        update();
      }
    });
    scrollControllers.addListener(() {
      if (scrollControllers.position.pixels >=
          scrollControllers.position.maxScrollExtent) {
        if (!isLoading) {
          onSearchData(false)();
        }
      }
    });
  }

  //! ------------------------------------------------------
  //? Selecting Table Rows:
  void selectAllRows(
      List<int> selectedDataList, List<dynamic> selectedPassedData) {
    if (selectedDataList.length == selectedPassedData.length) {
      selectedDataList.clear();
    } else {
      selectedDataList.clear();
      selectedDataList
          .addAll(selectedPassedData.map((data) => data.invoiceId ?? 0));
    }
    update();
  }

  //? Check if an item is selected
  bool isSelected(List<dynamic> passedList, int rowId) {
    return passedList.contains(rowId);
  }

  //? Select or deselect an item
  void selectItem(List<dynamic> passedList, int rowId, bool? selected) {
    if (selected == true) {
      passedList.add(rowId);
    } else {
      passedList.remove(rowId);
    }
    update();
  }

  //? Sorting Data
  bool sortAscending = true;
  void setAccountFields(bool value) {
    isAccountFields = value;
    update();
  }

  void changeInvoicesSortField(String field) {
    invoiceSortFileds = field;

    onSearchData(true)();
    update();
  }

  Future<void> toggleSortOrder() async {
    sortAscending = !sortAscending;

    onSearchData(true)();

    update();
  }

  bool isAccountFields = false;
  String invoiceSortFileds = "invoice_createdate";
  List<Map<String, dynamic>> get invoiceSortFields => [
        {
          "title": TextRoutes.invoiceNumber,
          "value": "invoice_id",
          "icon": Icons.numbers,
        },
        {
          "title": TextRoutes.date,
          "value": "invoice_createdate",
          "icon": Icons.date_range,
        },
        {
          "title": TextRoutes.customerName,
          "value": "account_name",
          "icon": Icons.person,
        },
        {
          "title": TextRoutes.invoiceCost,
          "value": "invoice_cost",
          "icon": Icons.money,
        },
        {
          "title": TextRoutes.discount,
          "value": "invoice_discount",
          "icon": Icons.discount,
        },
        {
          "title": TextRoutes.tax,
          "value": "invoice_tax",
          "icon": Icons.money,
        },
        {
          "title": TextRoutes.invoiceAmount,
          "value": "invoice_price",
          "icon": Icons.money,
        },
        {
          "title": TextRoutes.invoiceProfit,
          "value": "invoice_profit",
          "icon": Icons.money,
        },
      ];

  //! --------------------------------------------------------

  //? Status Request:
  StatusRequest statusRequest = StatusRequest.none;
  FinancialReportsData financialReportsData = FinancialReportsData();
  //! --------------------------------------------------------
  //? Link each function with fetched table:
  Future<void> Function() onSearchData(bool showRefresh) {
    switch (selectedSection) {
      case TextRoutes.incomeStatement:
        return () => fetchIncomeStatementReportData(isRefresh: showRefresh);
      case TextRoutes.ballanceSheet:
        setAccountFields(true);
        return () => fetchBalanceSheetReportData(isRefresh: showRefresh);

      default:
        return () => fetchIncomeStatementReportData(isRefresh: showRefresh);
    }
  }

  //! --------------------------------------------------------
  //? Change Table Widget Screen
  Widget changeTableWidget(FinancialReportsController controller) {
    switch (selectedSection) {
      case TextRoutes.incomeStatement:
        return IncomeStatementTable(
          controller: controller,
        );
      case TextRoutes.ballanceSheet:
        return BalanceSheetView(
          rootAccounts: rootAccounts,
        );
    }
    //update();
    return Container();
  }

  double totalRevenues = 0.0;
  double totalExpenses = 0.0;
  double totalProfits = 0.0;
  Future<void> fetchIncomeStatementReportData({
    required bool isRefresh,
  }) async {
    try {
      String? startDate =
          fromDateController.text.isEmpty ? null : fromDateController.text;
      String? endDate =
          toDateController.text.isEmpty ? null : toDateController.text;
      if (isRefresh) {
        statusRequest = StatusRequest.loading;
        update();
        itemsOffset = 0;
        billingInvoicesData.clear();
      }

      final response = await financialReportsData.getIncomeStatementData(
        startTime: startDate,
        endTime: endDate,
      );
      statusRequest = handlingData(response);

      if (statusRequest == StatusRequest.success) {
        final dataMap = response['data'];
        if (dataMap.isNotEmpty) {
          totalExpenses = dataMap[0]['total_expenses'];
          totalRevenues = dataMap[0]['total_revenues'];
          totalProfits = dataMap[0]['net_profit'];
        } else {
          if (isRefresh || billingInvoicesData.isEmpty) {
            statusRequest = StatusRequest.noData;
          }
          showSuccessSnackBar(TextRoutes.allDataLoaded);
        }
      } else {
        showErrorSnackBar(TextRoutes.failDuringFetchData);
        statusRequest = StatusRequest.failure;
      }
    } catch (e) {
      statusRequest = StatusRequest.serverException;
      showErrorDialog(e.toString(), message: TextRoutes.anErrorOccurred);
    } finally {
      update();
    }
  }

  Future<void> fetchBalanceSheetReportData({
    required bool isRefresh,
  }) async {
    try {
      String? startDate =
          fromDateController.text.isEmpty ? null : fromDateController.text;
      String? endDate =
          toDateController.text.isEmpty ? null : toDateController.text;
      if (isRefresh) {
        statusRequest = StatusRequest.loading;
        update();
        itemsOffset = 0;
        billingInvoicesData.clear();
      }

      final response = await financialReportsData.getBalanceSheetData(
        startTime: startDate,
        endTime: endDate,
      );

      statusRequest = handlingData(response);

      if (statusRequest == StatusRequest.success && response['data'] != null) {
        List<dynamic> dataMap = response['data'];
        if (dataMap.isNotEmpty) {
          rootAccounts = parseAccounts(dataMap);
        } else {
          statusRequest = StatusRequest.noData;
        }
      } else {
        statusRequest = StatusRequest.failure;
      }
    } catch (e) {
      statusRequest = StatusRequest.serverException;
      showErrorDialog(e.toString(), message: TextRoutes.anErrorOccurred);
    } finally {
      update();
    }
  }
double getTotalBalance(List<AccountMenuModel> accounts) {
  return accounts.fold(0.0, (sum, acc) => sum + acc.balance);
}
  List<AccountMenuModel> parseAccounts(List<dynamic> rawData) {
    List<AccountMenuModel> assetsChildren = [];
    List<AccountMenuModel> liabilitiesChildren = [];
    List<AccountMenuModel> equityChildren = [];

    double assetsTotal = 0;
    double liabilitiesTotal = 0;
    double equityTotal = 0;

    for (var item in rawData) {
      String category = item['category'];
      String name = item['account_name'];
      double balance = (item['balance'] as num).toDouble();

      if (name.startsWith('total_')) {
        if (category == 'assets')
          assetsTotal = balance;
        else if (category == 'liabilities')
          liabilitiesTotal = balance;
        else if (category == 'equity') equityTotal = balance;
        continue;
      }

      AccountMenuModel account = AccountMenuModel(
        name: name,
        balance: balance,
        children: [],
      );

      if (category == 'assets') {
        assetsChildren.add(account);
      } else if (category == 'liabilities') {
        liabilitiesChildren.add(account);
      } else if (category == 'equity') {
        equityChildren.add(account);
      }
    }

    return [
      AccountMenuModel(
          name: 'الأصول', balance: assetsTotal, children: assetsChildren),
      AccountMenuModel(
          name: 'الخصوم',
          balance: liabilitiesTotal,
          children: liabilitiesChildren),
      AccountMenuModel(
          name: 'حقوق الملكية', balance: equityTotal, children: equityChildren),
    ];
  }

  List<AccountMenuModel> rootAccounts = [];

  @override
  void onInit() {
    initScrolls();
    onSearchData(true)();
    super.onInit();
  }
}
