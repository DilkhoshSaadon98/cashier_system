import 'package:cashier_system/core/class/statusrequest.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/core/dialogs/snackbar_helper.dart';
import 'package:cashier_system/core/functions/handing_data_controller.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/data/model/reports/invoices_salary_model.dart';
import 'package:cashier_system/data/source/reports/billing_profits_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BillingProfitsController extends GetxController {
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
    fetchInvoicesReportData(isRefresh: true);
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
          fetchInvoicesReportData(isRefresh: false);
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

    fetchInvoicesReportData(isRefresh: true);
    update();
  }

  Future<void> toggleSortOrder() async {
    sortAscending = !sortAscending;

    fetchInvoicesReportData(isRefresh: true);

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
  BillingProfitsData billingProfitsData = BillingProfitsData();

  Future<void> fetchInvoicesReportData({
    required bool isRefresh,
  }) async {
    try {
      String? accountName = accountNameController.text.isEmpty
          ? null
          : accountNameController.text;
      String? startNo =
          fromNoController.text.isEmpty ? null : fromNoController.text;
      String? endNo = toNoController.text.isEmpty ? null : toNoController.text;
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

      final response = await billingProfitsData.getInventorySummaryData(
          ascSort: sortAscending,
          sortBy: invoiceSortFileds,
          accountName: accountName,
          startTime: startDate,
          endTime: endDate,
          startNo: startNo,
          endNo: endNo,
          limit: itemsPerPage,
          offset: itemsOffset);
      statusRequest = handlingData(response);

      if (statusRequest == StatusRequest.success) {
        final dataMap = response['data'];
        if (dataMap.isNotEmpty) {
          billingInvoicesData.addAll(
            (dataMap as List)
                .map((e) =>
                    InvoicesSalaryModel.fromJson(e as Map<String, dynamic>))
                .toList(),
          );
          itemsOffset += itemsPerPage;
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

  @override
  void onInit() {
    initScrolls();
    fetchInvoicesReportData(isRefresh: true);
    super.onInit();
  }
}
