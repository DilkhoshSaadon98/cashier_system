import 'package:cashier_system/core/class/statusrequest.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/core/dialogs/snackbar_helper.dart';
import 'package:cashier_system/core/functions/handing_data_controller.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/data/model/account_model.dart';
import 'package:cashier_system/data/model/reports/account_statement_model.dart';
import 'package:cashier_system/data/model/reports/box_transaction_model.dart';
import 'package:cashier_system/data/model/reports/customer_ledger_model.dart';
import 'package:cashier_system/data/model/reports/general_ledger_model.dart';
import 'package:cashier_system/data/model/reports/retained_earnings_model.dart';
import 'package:cashier_system/data/model/reports/supplier_ledger_model.dart';
import 'package:cashier_system/data/model/reports/trial_balance_model.dart';
import 'package:cashier_system/data/model/reports/withdraw_model.dart';
import 'package:cashier_system/data/source/reports/reports_data.dart';
import 'package:cashier_system/data/source/transaction_class.dart';
import 'package:cashier_system/view/reports/daily_reports/account_statement/account_statement_table.dart';
import 'package:cashier_system/view/reports/daily_reports/bank/bank_action_widget.dart';
import 'package:cashier_system/view/reports/daily_reports/bank/bank_table.dart';
import 'package:cashier_system/view/reports/daily_reports/box/box_action_widget.dart';
import 'package:cashier_system/view/reports/daily_reports/box/box_table.dart';
import 'package:cashier_system/view/reports/daily_reports/customer/customer_action_widget.dart';
import 'package:cashier_system/view/reports/daily_reports/customer/customer_table.dart';
import 'package:cashier_system/view/reports/daily_reports/general_ledger/general_ledger_action_widget.dart';
import 'package:cashier_system/view/reports/daily_reports/general_ledger/general_ledger_table.dart';
import 'package:cashier_system/view/reports/daily_reports/retained_earnings/retained_earnings_table.dart';
import 'package:cashier_system/view/reports/daily_reports/supplier/supplier_table.dart';
import 'package:cashier_system/view/reports/daily_reports/trial_balance/trial_balance_action_widget.dart';
import 'package:cashier_system/view/reports/daily_reports/trial_balance/trial_balance_table.dart';
import 'package:cashier_system/view/reports/daily_reports/withdraw/withdraw_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DailyReportsController extends GetxController {
  TransactionClass transactionClass = TransactionClass();
  Future<void> getSourceAccountData() async {
    try {
      var response = await transactionClass.getSourceAccountData();
      if (response['status'] == "success") {
        var data = response['data'];

        dropDownListSourceAccounts.clear();
        dropDownListTargetAccounts.clear();
        listDataSearchSourceAccounts.clear();

        List<AccountModel> accounts =
            data.map<AccountModel>((e) => AccountModel.fromMap(e)).toList();

        listDataSearchSourceAccounts.addAll(accounts);
        dropDownListSourceAccounts.addAll(accounts);
        dropDownListTargetAccounts.addAll(accounts);
      }
    } catch (e) {
      showErrorDialog(
        e.toString(),
        title: "Error",
        message: "Exception occurred while getting source accounts",
      );
    } finally {
      update();
    }
  }

  //! --------------------------------------------------------
  //? Toggle transaction Section Tables:
  String selectedSection =
      myServices.sharedPreferences.getString("daily_reports_header") ??
          TextRoutes.generalLedger;

  changeSection(value, DailyReportsController controller) {
    itemsOffset = 0;
    selectedSection = value;
    onSearchData(true)();
    changeTableWidget(controller);
    myServices.sharedPreferences.setString('daily_reports_header', value);
    update();
  }

  //! --------------------------------------------------------
  //? Toggle transaction Section:
  String selectedTransactionType = TextRoutes.allTransactions;
  void changeTransactionType(String value) {
    selectedTransactionType = value;
    update();
  }

  //! --------------------------------------------------------
  //? Search Controller:
  TextEditingController fromNoController = TextEditingController();
  TextEditingController toNoController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  //? Account Search Controller:
  List<AccountModel> listDataSearchSourceAccounts = [];
  List<AccountModel> dropDownListSourceAccounts = [];
  List<AccountModel> dropDownListTargetAccounts = [];
  AccountModel? selectedSourceAccount;
  AccountModel? selectedTargetAccount;
  int? selectedSourceAccountId;
  int? selectedTargetAccountId;
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

  //! --------------------------------------------------------
  //? Table Selection Lists
  List<int> selectedGeneralLedger = [];
  List<int> selectedTrialBalance = [];
  List<int> selectedCashReports = [];
  List<int> selectedBankReports = [];
  List<int> selectedCustomerReports = [];
  List<int> selectedSupplierReports = [];
  List<int> selectedWithdrawReports = [];
  List<int> selectedRetainedEarningsReports = [];
  List<int> selectedAccountStatementReports = [];
  //? Selecting Table Rows:
  void selectAllRows(
      List<int> selectedDataList, List<dynamic> selectedPassedData) {
    if (selectedDataList.length == selectedPassedData.length) {
      selectedDataList.clear();
    } else {
      selectedDataList.clear();
      selectedDataList
          .addAll(selectedPassedData.map((data) => data.voucherNo ?? 0));
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

  //! --------------------------------------------------------
  //? Sorting Data
  bool isAccountFields = false;
  String selectedSortField = "voucher_no";
  bool sortAscending = true;
  void setAccountFields(bool value) {
    isAccountFields = value;
    update();
  }

  //? Sorting Function:
  void changeSortField(String field) {
    selectedSortField = field;
    onSearchData(true)();
    update();
  }

  //? Toggle Sorting Ascending/Descending:
  Future<void> toggleSortOrder() async {
    sortAscending = !sortAscending;
    await onSearchData(true)();

    update();
  }

  //? Sorting Fields:
  List<Map<String, dynamic>> get sortGeneralLedgerFields => [
        {
          "title": TextRoutes.voucherNo,
          "value": "voucher_no",
          "icon": Icons.numbers,
        },
        {
          "title": TextRoutes.sourceAccount,
          "value": "source_account_name",
          "icon": Icons.account_balance,
        },
        {
          "title": TextRoutes.targetAccount,
          "value": "target_account_name",
          "icon": Icons.account_balance,
        },
        {
          "title": TextRoutes.transactionType,
          "value": "transaction_type",
          "icon": Icons.type_specimen,
        },
        {
          "title": TextRoutes.ballance,
          "value": "amount",
          "icon": Icons.money,
        },
        {
          "title": TextRoutes.createDate,
          "value": "transaction_date",
          "icon": Icons.calendar_today,
        },
      ];
  List<Map<String, dynamic>> get sortTrialBalanceFields => [
        {
          "title": TextRoutes.voucherNo,
          "value": "voucher_no",
          "icon": Icons.numbers,
        },
        {
          "title": TextRoutes.sourceAccount,
          "value": "source_account_name",
          "icon": Icons.account_balance,
        },
        {
          "title": TextRoutes.debit,
          "value": "total_debit",
          "icon": Icons.type_specimen,
        },
        {
          "title": TextRoutes.credit,
          "value": "total_credit",
          "icon": Icons.money,
        },
        {
          "title": TextRoutes.ballance,
          "value": "balance",
          "icon": Icons.balance,
        },
      ];
  List<Map<String, dynamic>> get sortBoxFields => [
        {
          "title": TextRoutes.voucherNo,
          "value": "voucher_no",
          "icon": Icons.numbers,
        },
        {
          "title": TextRoutes.sourceAccount,
          "value": "account_name",
          "icon": Icons.account_balance,
        },
        {
          "title": TextRoutes.transactionType,
          "value": "transaction_type",
          "icon": Icons.type_specimen,
        },
        {
          "title": TextRoutes.ballance,
          "value": "transaction_amount",
          "icon": Icons.money,
        },
        {
          "title": TextRoutes.createDate,
          "value": "transaction_date",
          "icon": Icons.calendar_today,
        },
      ];
  List<Map<String, dynamic>> get accountSortFields => [
        {
          "title": TextRoutes.voucherNo,
          "value": "voucher_no",
          "icon": Icons.numbers,
        },
        {
          "title": TextRoutes.sourceAccount,
          "value": "source_account_name",
          "icon": Icons.account_balance,
        },
        {
          "title": TextRoutes.targetAccount,
          "value": "target_account_name",
          "icon": Icons.account_balance,
        },
        {
          "title": TextRoutes.transactionType,
          "value": "transaction_type",
          "icon": Icons.type_specimen,
        },
        {
          "title": TextRoutes.ballance,
          "value": "amount",
          "icon": Icons.money,
        },
        {
          "title": TextRoutes.createDate,
          "value": "transaction_date",
          "icon": Icons.calendar_today,
        },
      ];
  //! --------------------------------------------------------
  //? Change Table Widget Screen
  Widget changeTableWidget(DailyReportsController controller) {
    switch (selectedSection) {
      case TextRoutes.generalLedger:
        return GeneralLedgerTable(
          controller: controller,
        );
      case TextRoutes.trialBalance:
        return TrialBalanceTable(
          controller: controller,
        );
      case TextRoutes.boxReport:
        return BoxTable(
          controller: controller,
        );
      case TextRoutes.bankReport:
        return BankTable(
          controller: controller,
        );
      case TextRoutes.customerReport:
        return CustomerTable(
          controller: controller,
        );
      case TextRoutes.supplierReport:
        return SupplierTable(
          controller: controller,
        );
      case TextRoutes.withdrawalReport:
        return WithdrawTable(
          controller: controller,
        );
      case TextRoutes.retainedEarningsReport:
        return RetainedEarningsTable(
          controller: controller,
        );
      case TextRoutes.accountStatement:
        return AccountStatementTable(
          controller: controller,
        );
    }
    return Container();
  }

  //? Change Table Widget Screen
  Widget changeActionWidgetWidget(DailyReportsController controller) {
    switch (selectedSection) {
      case TextRoutes.generalLedger:
        return GeneralLedgerActionWidget(
          controller: controller,
        );
      case TextRoutes.trialBalance:
        return TrialBalanceActionWidget(
          controller: controller,
        );
      case TextRoutes.boxReport:
        return BoxActionWidget(
          controller: controller,
        );
      case TextRoutes.bankReport:
        return BankActionWidget(
          controller: controller,
        );
      case TextRoutes.customerReport:
        return CustomerActionWidget(
          controller: controller,
        );
      case TextRoutes.supplierReport:
        return CustomerActionWidget(
          controller: controller,
        );
      case TextRoutes.withdrawalReport:
        return CustomerActionWidget(
          controller: controller,
        );
      case TextRoutes.retainedEarningsReport:
        return CustomerActionWidget(
          controller: controller,
        );
      case TextRoutes.accountStatement:
        return CustomerActionWidget(
          controller: controller,
        );
    }
    return Container();
  }

  //! --------------------------------------------------------
  //? List For Data Store:
  List<GeneralLedgerModel> generalLedger = [];
  List<TrialBalanceModel> trialBalance = [];
  List<CashReportModel> boxData = [];
  List<CustomerLedgerModel> customerData = [];
  List<SupplierLedgerModel> supplierData = [];
  List<WithdrawModel> withdrawData = [];
  List<CashReportModel> bankData = [];
  List<RetainedEarningsModel> retainedEarningsData = [];
  List<AccountStatementModel> accountStatementData = [];
  //! --------------------------------------------------------
  //? Class to connect with database:
  ReportsData reportsData = ReportsData();
  //? Status Request:
  StatusRequest statusRequest = StatusRequest.none;
  //! --------------------------------------------------------
  //? Link each function with fetched table:
  Future<void> Function() onSearchData(bool showRefresh) {
    switch (selectedSection) {
      case TextRoutes.generalLedger:
        return () => fetchGeneralLedger(isRefresh: showRefresh);
      case TextRoutes.trialBalance:
        setAccountFields(true);
        return () => fetchTrialBalance(isRefresh: showRefresh);
      case TextRoutes.boxReport:
        return () => fetchBoxData(isRefresh: showRefresh);
      case TextRoutes.bankReport:
        return () => fetchBankReports(isRefresh: showRefresh);
      case TextRoutes.customerReport:
        return () => fetchCustomerData(isRefresh: showRefresh);
      case TextRoutes.supplierReport:
        return () => fetchSupplierData(isRefresh: showRefresh);
      case TextRoutes.withdrawalReport:
        return () => fetchWithdrawData(isRefresh: showRefresh);
      case TextRoutes.retainedEarningsReport:
        return () => fetchRetainedEarningsData(isRefresh: showRefresh);
      case TextRoutes.accountStatement:
        return () => fetchAccountStatementData(isRefresh: showRefresh);
      default:
        return () => fetchGeneralLedger(isRefresh: showRefresh);
    }
  }

  //! --------------------------------------------------------
  //? Clear Search Fields
  clearAllData() {
    fromDateController.clear();
    toDateController.clear();
    fromNoController.clear();
    toNoController.clear();
    selectedSourceAccountId = null;
    selectedSourceAccount = null;
    selectedTransactionType = TextRoutes.allTransactions;
    onSearchData(true)();
  }

//! --------------------------------------------------------
  //? Fetch General Ledger:
  Future<void> fetchGeneralLedger({bool isRefresh = false}) async {
    String? startNo = fromNoController.text.trim().isEmpty
        ? null
        : fromNoController.text.trim();
    String? endNo =
        toNoController.text.trim().isEmpty ? null : toNoController.text.trim();
    String? startDate = fromDateController.text.trim().isEmpty
        ? null
        : fromDateController.text.trim();
    String? endDate = toDateController.text.trim().isEmpty
        ? null
        : toDateController.text.trim();
    int? source = selectedSourceAccount?.accountId;
    await fetchReport<GeneralLedgerModel>(
      isRefresh: isRefresh,
      targetList: generalLedger,
      fromJson: (e) => GeneralLedgerModel.fromJson(e),
      apiCall: () async => reportsData.getGeneralLedgerData(
        sortBy: selectedSortField,
        ascSort: sortAscending,
        sourceAccount: source,
        transactionType: selectedTransactionType,
        limit: itemsPerPage,
        offset: itemsOffset,
        startNo: startNo,
        endNo: endNo,
        startTime: startDate,
        endTime: endDate,
      ),
    );
  }

//! --------------------------------------------------------
  //? Fetch Bank Reports:
  Future<void> fetchBankReports({bool isRefresh = false}) async {
    String? startNo = fromNoController.text.trim().isEmpty
        ? null
        : fromNoController.text.trim();
    String? endNo =
        toNoController.text.trim().isEmpty ? null : toNoController.text.trim();
    String? startDate = fromDateController.text.trim().isEmpty
        ? null
        : fromDateController.text.trim();
    String? endDate = toDateController.text.trim().isEmpty
        ? null
        : toDateController.text.trim();

    await fetchReport<CashReportModel>(
      isRefresh: isRefresh,
      targetList: bankData,
      fromJson: (e) => CashReportModel.fromJson(e),
      apiCall: () async {
        final response = await reportsData.getBankData(
          sortBy: selectedSortField,
          ascSort: sortAscending,
          sourceAccount: selectedSourceAccountId,
          limit: itemsPerPage,
          offset: itemsOffset,
          startNo: startNo,
          endNo: endNo,
          startTime: startDate,
          endTime: endDate,
        );
        return response;
      },
    );
  }

//! --------------------------------------------------------
//? Fetch General Ledger Data:
  Future<void> fetchTrialBalance({bool isRefresh = false}) async {
    isAccountFields = true;

    String? startNo = fromNoController.text.trim().isEmpty
        ? null
        : fromNoController.text.trim();
    String? endNo =
        toNoController.text.trim().isEmpty ? null : toNoController.text.trim();

    await fetchReport<TrialBalanceModel>(
      isRefresh: isRefresh,
      targetList: trialBalance,
      fromJson: (e) => TrialBalanceModel.fromJson(e),
      apiCall: () async {
        final response = await reportsData.getTrialBalanceData(
          ascSort: sortAscending,
          sortBy: selectedSortField,
          limit: itemsPerPage,
          offset: itemsOffset,
          startNo: startNo,
          endNo: endNo,
        );
        return response;
      },
    );
  }

//! --------------------------------------------------------
//? Fetch Box Data:
  Future<void> fetchBoxData({bool isRefresh = false}) async {
    String? startNo = fromNoController.text.trim().isEmpty
        ? null
        : fromNoController.text.trim();
    String? endNo =
        toNoController.text.trim().isEmpty ? null : toNoController.text.trim();
    String? startDate = fromDateController.text.trim().isEmpty
        ? null
        : fromDateController.text.trim();
    String? endDate = toDateController.text.trim().isEmpty
        ? null
        : toDateController.text.trim();

    await fetchReport<CashReportModel>(
      isRefresh: isRefresh,
      targetList: boxData,
      fromJson: (e) => CashReportModel.fromJson(e),
      apiCall: () async {
        final response = await reportsData.getBoxData(
          ascSort: sortAscending,
          sortBy: selectedSortField,
          sourceAccount: selectedSourceAccountId,
          limit: itemsPerPage,
          offset: itemsOffset,
          startNo: startNo,
          endNo: endNo,
          startTime: startDate,
          endTime: endDate,
        );
        return response;
      },
    );
  }

//! --------------------------------------------------------
//? Fetch Customer Data:
  Future<void> fetchCustomerData({bool isRefresh = false}) async {
    String? startNo = fromNoController.text.trim().isEmpty
        ? null
        : fromNoController.text.trim();
    String? endNo =
        toNoController.text.trim().isEmpty ? null : toNoController.text.trim();
    String? startDate = fromDateController.text.trim().isEmpty
        ? null
        : fromDateController.text.trim();
    String? endDate = toDateController.text.trim().isEmpty
        ? null
        : toDateController.text.trim();

    await fetchReport<CustomerLedgerModel>(
      isRefresh: isRefresh,
      targetList: customerData,
      fromJson: (e) => CustomerLedgerModel.fromJson(e),
      apiCall: () async {
        final response = await reportsData.getCustomerData(
          ascSort: sortAscending,
          sortBy: selectedSortField,
          transactionType: selectedTransactionType,
          sourceAccount: selectedSourceAccountId,
          limit: itemsPerPage,
          offset: itemsOffset,
          startNo: startNo,
          endNo: endNo,
          startTime: startDate,
          endTime: endDate,
        );
        return response;
      },
    );
  }

//! --------------------------------------------------------
//? Fetch Supplier Data:
  Future<void> fetchSupplierData({bool isRefresh = false}) async {
    String? startNo = fromNoController.text.trim().isEmpty
        ? null
        : fromNoController.text.trim();
    String? endNo =
        toNoController.text.trim().isEmpty ? null : toNoController.text.trim();
    String? startDate = fromDateController.text.trim().isEmpty
        ? null
        : fromDateController.text.trim();
    String? endDate = toDateController.text.trim().isEmpty
        ? null
        : toDateController.text.trim();

    await fetchReport<SupplierLedgerModel>(
      isRefresh: isRefresh,
      targetList: supplierData,
      fromJson: (e) => SupplierLedgerModel.fromJson(e),
      apiCall: () async {
        final response = await reportsData.getSupplierData(
          ascSort: sortAscending,
          sortBy: selectedSortField,
          transactionType: selectedTransactionType,
          sourceAccount: selectedSourceAccountId,
          limit: itemsPerPage,
          offset: itemsOffset,
          startNo: startNo,
          endNo: endNo,
          startTime: startDate,
          endTime: endDate,
        );
        return response;
      },
    );
  }

//! --------------------------------------------------------
//? Fetch Withdrawal Data:

  Future<void> fetchWithdrawData({bool isRefresh = false}) async {
    String? startNo = fromNoController.text.trim().isEmpty
        ? null
        : fromNoController.text.trim();
    String? endNo =
        toNoController.text.trim().isEmpty ? null : toNoController.text.trim();
    String? startDate = fromDateController.text.trim().isEmpty
        ? null
        : fromDateController.text.trim();
    String? endDate = toDateController.text.trim().isEmpty
        ? null
        : toDateController.text.trim();

    await fetchReport<WithdrawModel>(
      isRefresh: isRefresh,
      targetList: withdrawData,
      fromJson: (e) => WithdrawModel.fromJson(e),
      apiCall: () async {
        final response = await reportsData.getWithdrawData(
          ascSort: sortAscending,
          sortBy: selectedSortField,
          sourceAccount: selectedSourceAccountId,
          transactionType: selectedTransactionType,
          limit: itemsPerPage,
          offset: itemsOffset,
          startNo: startNo,
          endNo: endNo,
          startTime: startDate,
          endTime: endDate,
        );
        return response;
      },
    );
  }

//! --------------------------------------------------------
//? Fetch Retained Earnings Data:
  Future<void> fetchRetainedEarningsData({bool isRefresh = false}) async {
    String? startNo = fromNoController.text.trim().isEmpty
        ? null
        : fromNoController.text.trim();
    String? endNo =
        toNoController.text.trim().isEmpty ? null : toNoController.text.trim();
    String? startDate = fromDateController.text.trim().isEmpty
        ? null
        : fromDateController.text.trim();
    String? endDate = toDateController.text.trim().isEmpty
        ? null
        : toDateController.text.trim();

    await fetchReport<RetainedEarningsModel>(
      isRefresh: isRefresh,
      targetList: retainedEarningsData,
      fromJson: (e) => RetainedEarningsModel.fromJson(e),
      apiCall: () async {
        final response = await reportsData.getRetainedEarningsData(
          ascSort: sortAscending,
          sortBy: selectedSortField,
          sourceAccount: selectedSourceAccountId,
          targetAccount: selectedTargetAccountId,
          transactionType: selectedTransactionType,
          limit: itemsPerPage,
          offset: itemsOffset,
          startNo: startNo,
          endNo: endNo,
          startTime: startDate,
          endTime: endDate,
        );
        return response;
      },
    );
  }

//! --------------------------------------------------------
  //? Fetch Account Statement Data:
  Future<void> fetchAccountStatementData({bool isRefresh = false}) async {
    String? startNo = fromNoController.text.trim().isEmpty
        ? null
        : fromNoController.text.trim();
    String? endNo =
        toNoController.text.trim().isEmpty ? null : toNoController.text.trim();
    String? startDate = fromDateController.text.trim().isEmpty
        ? null
        : fromDateController.text.trim();
    String? endDate = toDateController.text.trim().isEmpty
        ? null
        : toDateController.text.trim();

    await fetchReport<AccountStatementModel>(
      isRefresh: isRefresh,
      targetList: accountStatementData,
      fromJson: (e) => AccountStatementModel.fromJson(e),
      apiCall: () async {
        final response = await reportsData.getAccountStatementData(
          ascSort: sortAscending,
          sortBy: selectedSortField,
          sourceAccount: selectedSourceAccountId,
          targetAccount: selectedTargetAccountId,
          transactionType: selectedTransactionType,
          limit: itemsPerPage,
          offset: itemsOffset,
          startNo: startNo,
          endNo: endNo,
          startTime: startDate,
          endTime: endDate,
        );
        return response;
      },
    );
  }

//! --------------------------------------------------------
//? General Fetch Reports Function
  Future<void> fetchReport<T>({
    required Future<Map<String, dynamic>> Function() apiCall,
    required List<T> targetList,
    required T Function(Map<String, dynamic>) fromJson,
    required bool isRefresh,
  }) async {
    try {
      if (isRefresh) {
        statusRequest = StatusRequest.loading;
        update();
        itemsOffset = 0;
        targetList.clear();
      }

      final response = await apiCall();
      statusRequest = handlingData(response);

      if (statusRequest == StatusRequest.success) {
        final dataMap = response['data'];
        if (dataMap.isNotEmpty) {
          targetList.addAll(dataMap.map<T>((e) => fromJson(e)).toList());
          itemsOffset += itemsPerPage;
        } else {
          if (isRefresh || targetList.isEmpty) {
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

  @override
  void onInit() {
    initScrolls();
    getSourceAccountData();
    onSearchData(true)();
    super.onInit();
  }
}
