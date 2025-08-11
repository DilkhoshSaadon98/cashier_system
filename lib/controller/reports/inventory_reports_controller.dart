import 'package:cashier_system/core/class/statusrequest.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/core/dialogs/snackbar_helper.dart';
import 'package:cashier_system/core/functions/handing_data_controller.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/data/model/account_model.dart';
import 'package:cashier_system/data/model/reports/inventory_movments_model.dart';
import 'package:cashier_system/data/model/reports/inventory_summary_model.dart';
import 'package:cashier_system/data/source/reports/inventory_items_data.dart';
import 'package:cashier_system/view/reports/inventory_reports/movements/inventory_movements_table.dart';
import 'package:cashier_system/view/reports/inventory_reports/summary/inventory_summary_table.dart';
import 'package:cashier_system/view/reports/inventory_reports/valuation/inventory_valuation_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InventoryReportsController extends GetxController {
  //! --------------------------------------------------------
  //? Toggle transaction Section Tables:
  String selectedSection =
      myServices.sharedPreferences.getString("inventory_reports_header") ??
          TextRoutes.inventorySummary;

  changeSection(value, InventoryReportsController controller) {
    itemsOffset = 0;
    selectedSection = value;
    onSearchData(true)();
    changeTableWidget(controller);
    myServices.sharedPreferences.setString('inventory_reports_header', value);
    update();
  }

  //! --------------------------------------------------------
  //? Clear Search Fields
  clearAllData() {
    fromDateController.clear();
    toDateController.clear();
    fromNoController.clear();
    toNoController.clear();
    itemsNameController.clear();
    itemsQtyController.clear();
    accountNameController.clear();
    onSearchData(true)();
  }

  //! --------------------------------------------------------
  //? Change Table Widget Screen
  Widget changeTableWidget(InventoryReportsController controller) {
    switch (selectedSection) {
      case TextRoutes.inventorySummary:
        return InventorySummaryTable(
          controller: controller,
        );
      case TextRoutes.inventoryMovement:
        return InventoryMovementsTable(
          controller: controller,
        );
      case TextRoutes.inventoryValuation:
        return InventoryValuationTable(
          controller: controller,
        );
    }
    return Container();
  }

  //! --------------------------------------------------------
  //? Toggle transaction Section:
  String selectedTransactionType = TextRoutes.allTransactions;
  void changeTransactionType(String value) {
    selectedTransactionType = value;
    update();
  }

  //! --------------------------------------------------------
  //?
  List<AccountModel> listDataSearchSourceAccounts = [];
  List<AccountModel> dropDownListSourceAccounts = [];
  List<AccountModel> dropDownListTargetAccounts = [];
  //! --------------------------------------------------------
  //? Search Controller:
  TextEditingController fromNoController = TextEditingController();
  TextEditingController toNoController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController accountNameController = TextEditingController();
  TextEditingController itemsNameController = TextEditingController();
  TextEditingController itemsQtyController = TextEditingController();
  //? Account Search Controller:
  // List<AccountModel> listDataSearchSourceAccounts = [];
  // List<AccountModel> dropDownListSourceAccounts = [];
  // List<AccountModel> dropDownListTargetAccounts = [];
  // AccountModel? selectedSourceAccount;
  // AccountModel? selectedTargetAccount;
  // int? selectedSourceAccountId;
  // int? selectedTargetAccountId;
  //! --------------------------------------------------------
  //? Sorting Data
  // Summary
  bool isAccountFields = false;
  String summarySortField = "date";
  List<Map<String, dynamic>> get summarySortFields => [
        {
          "title": TextRoutes.invoiceNumber,
          "value": "invoice_number",
          "icon": Icons.numbers,
        },
        {
          "title": TextRoutes.date,
          "value": "date",
          "icon": Icons.date_range,
        },
        {
          "title": TextRoutes.itemsName,
          "value": "item_name",
          "icon": Icons.category,
        },
        {
          "title": TextRoutes.quantity,
          "value": "quantity",
          "icon": Icons.numbers,
        },
        {
          "title": TextRoutes.sellingPrice,
          "value": "sale_price",
          "icon": Icons.money,
        },
        {
          "title": TextRoutes.costPrice,
          "value": "cost_price",
          "icon": Icons.money,
        },
      ];

  // Movements:

  String movementSortFields = 'date';
  List<Map<String, dynamic>> get movementsSortFields => [
        {
          "title": TextRoutes.invoiceNumber,
          "value": "invoice_number",
          "icon": Icons.numbers,
        },
        {
          "title": TextRoutes.date,
          "value": "date",
          "icon": Icons.date_range,
        },
        {
          "title": TextRoutes.itemsName,
          "value": "item_name",
          "icon": Icons.category,
        },
        {
          "title": TextRoutes.quantity,
          "value": "quantity",
          "icon": Icons.numbers,
        },
        {
          "title": TextRoutes.sellingPrice,
          "value": "sale_price",
          "icon": Icons.money,
        },
        {
          "title": TextRoutes.purchasedQTY,
          "value": "quantity_purchased",
          "icon": Icons.numbers,
        },
        {
          "title": TextRoutes.soldQTY,
          "value": "quantity_sold",
          "icon": Icons.numbers,
        },
        {
          "title": TextRoutes.returnPurchaseQTY,
          "value": "quantity_return_purchase",
          "icon": Icons.numbers,
        },
        {
          "title": TextRoutes.returnSaleQTY,
          "value": "quantity_return_sale",
          "icon": Icons.numbers,
        },
        {
          "title": TextRoutes.availableQTY,
          "value": "quantity_remaining",
          "icon": Icons.numbers,
        },
      ];
  // Valuation:

  String valuationSortField = 'date';
  List<Map<String, dynamic>> get valuationSortFields => [
        {
          "title": TextRoutes.invoiceNumber,
          "value": "invoice_number",
          "icon": Icons.numbers,
        },
        {
          "title": TextRoutes.date,
          "value": "date",
          "icon": Icons.date_range,
        },
        {
          "title": TextRoutes.itemsName,
          "value": "item_name",
          "icon": Icons.category,
        },
        {
          "title": TextRoutes.quantity,
          "value": "quantity",
          "icon": Icons.numbers,
        },
        {
          "title": TextRoutes.sellingPrice,
          "value": "sale_price",
          "icon": Icons.money,
        },
        {
          "title": TextRoutes.costPrice,
          "value": "cost_price",
          "icon": Icons.money,
        },
        {
          "title": TextRoutes.purchasedQTY,
          "value": "quantity_purchased",
          "icon": Icons.numbers,
        },
        {
          "title": TextRoutes.soldQTY,
          "value": "quantity_sold",
          "icon": Icons.numbers,
        },
        {
          "title": TextRoutes.returnPurchaseQTY,
          "value": "quantity_return_purchase",
          "icon": Icons.numbers,
        },
        {
          "title": TextRoutes.returnSaleQTY,
          "value": "quantity_return_sale",
          "icon": Icons.numbers,
        },
        {
          "title": TextRoutes.availableQTY,
          "value": "quantity_remaining",
          "icon": Icons.numbers,
        },
      ];
  bool sortAscending = true;
  void setAccountFields(bool value) {
    isAccountFields = value;
    update();
  }

  //? Sorting Function:
  void changeSummarySortField(String field) {
    summarySortField = field;
    onSearchData(true)();
    update();
  }

  void changeMovementsSortField(String field) {
    movementSortFields = field;
    onSearchData(true)();
    update();
  }

  void changeValuationSortField(String field) {
    valuationSortField = field;
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
  String inventorySummarySection = 'sale';
  changeInventorySummarySection(value) {
    if (value == TextRoutes.sale) {
      getSourceAccountData(9);
    } else {
      getSourceAccountData(20);
    }
    inventorySummarySection = value;
    onSearchData(true)();
    update();
  }

  List<Map<String, dynamic>> get inventorySummaryFields => [
        {
          "title": TextRoutes.sales,
          "value": "sale",
          "icon": Icons.numbers,
        },
        {
          "title": TextRoutes.purchaes,
          "value": "purchase",
          "icon": Icons.account_balance,
        },
        {
          "title": TextRoutes.returnsPurchaes,
          "value": "return_purchase",
          "icon": Icons.account_balance,
        },
        {
          "title": TextRoutes.returnsSale,
          "value": "return_sale",
          "icon": Icons.type_specimen,
        },
        {
          "title": TextRoutes.adjustment,
          "value": "adjustment",
          "icon": Icons.money,
        },
      ];

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

  //? Status Request:
  StatusRequest statusRequest = StatusRequest.none;
  List<InventorySummaryModel> inventorySummaryReportsData = [];
  List<InventoryMovementsModel> inventoryMovementsReportsData = [];
  List<InventoryMovementsModel> inventoryValuationReportsData = [];
  InventoryItemsData inventoryItemsData = InventoryItemsData();
  //?

  //! --------------------------------------------------------
  //? Table Selection Lists
  List<int> selectedInventorySummary = [];
  List<int> selectedInventoryMovements = [];
  List<int> selectedInventoryValuation = [];
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
          .addAll(selectedPassedData.map((data) => data.invoiceNumber ?? 0));
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

  Future<void> Function() onSearchData(bool showRefresh) {
    switch (selectedSection) {
      case TextRoutes.inventorySummary:
        return () => fetchInventorySummaryReportData(isRefresh: showRefresh);
      case TextRoutes.inventoryMovement:
        setAccountFields(true);
        return () => fetchInventoryMovementsReportData(isRefresh: showRefresh);
      case TextRoutes.inventoryValuation:
        return () => fetchInventoryValuationReportData(isRefresh: showRefresh);
      default:
        return () => fetchInventorySummaryReportData(isRefresh: showRefresh);
    }
  }

  //? Inventory Summary
  Future<void> fetchInventorySummaryReportData({bool isRefresh = false}) async {
    String selectedSummary = inventorySummarySection;
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
    String? accountName = accountNameController.text.trim().isEmpty
        ? null
        : accountNameController.text.trim();
    String? itemsName = itemsNameController.text.trim().isEmpty
        ? null
        : itemsNameController.text.trim();
    await fetchReport<InventorySummaryModel>(
      isRefresh: isRefresh,
      targetList: inventorySummaryReportsData,
      fromJson: (e) => InventorySummaryModel.fromMap(e),
      apiCall: () async => inventoryItemsData.getInventorySummaryData(
        sortBy: summarySortField,
        ascSort: sortAscending,
        summaryType: selectedSummary,
        accountName: accountName,
        itemsName: itemsName,
        limit: itemsPerPage,
        offset: itemsOffset,
        startNo: startNo,
        endNo: endNo,
        startTime: startDate,
        endTime: endDate,
      ),
    );
  }

  //? Inventory Movements
  Future<void> fetchInventoryMovementsReportData(
      {bool isRefresh = false}) async {
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
    String? itemsName = itemsNameController.text.trim().isEmpty
        ? null
        : itemsNameController.text.trim();
    String? itemsQty = itemsQtyController.text.trim().isEmpty
        ? null
        : itemsQtyController.text.trim();
    await fetchReport<InventoryMovementsModel>(
      isRefresh: isRefresh,
      targetList: inventoryMovementsReportsData,
      fromJson: (e) => InventoryMovementsModel.fromJson(e),
      apiCall: () async => inventoryItemsData.getInventoryMovementsData(
        sortBy: movementSortFields,
        ascSort: sortAscending,
        itemsQty: itemsQty,
        itemsName: itemsName,
        limit: itemsPerPage,
        offset: itemsOffset,
        startNo: startNo,
        endNo: endNo,
        startTime: startDate,
        endTime: endDate,
      ),
    );
  }

  //? Inventory Valuation:
  Future<void> fetchInventoryValuationReportData(
      {bool isRefresh = false}) async {
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
    String? accountName = accountNameController.text.trim().isEmpty
        ? null
        : accountNameController.text.trim();
    String? itemsName = itemsNameController.text.trim().isEmpty
        ? null
        : itemsNameController.text.trim();
    await fetchReport<InventoryMovementsModel>(
      isRefresh: isRefresh,
      targetList: inventoryValuationReportsData,
      fromJson: (e) => InventoryMovementsModel.fromJson(e),
      apiCall: () async => inventoryItemsData.getInventoryValuationData(
        sortBy: valuationSortField,
        ascSort: sortAscending,
        accountName: accountName,
        itemsName: itemsName,
        limit: itemsPerPage,
        offset: itemsOffset,
        startNo: startNo,
        endNo: endNo,
        startTime: startDate,
        endTime: endDate,
      ),
    );
  }

  Future<void> getSourceAccountData(int parentId) async {
    try {
      var response = await inventoryItemsData.getSourceAccountData(parentId);
      if (response['status'] == "success") {
        var data = response['data'];

        dropDownListSourceAccounts.clear();
        dropDownListTargetAccounts.clear();
        dropDownListSourceAccounts
            .addAll(data.map<AccountModel>((e) => AccountModel.fromMap(e)));
        dropDownListTargetAccounts
            .addAll(data.map<AccountModel>((e) => AccountModel.fromMap(e)));
      }
    } catch (e) {
      showErrorDialog(
        e.toString(),
        title: "Error",
        message: "Exception occurred while getting source accounts",
      );

      dropDownListSourceAccounts.clear();
    } finally {
      update();
    }
  }

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
    onSearchData(true)();
    super.onInit();
  }
}
