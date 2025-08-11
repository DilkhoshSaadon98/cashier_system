import 'package:cashier_system/controller/transactions/transaction_controller.dart';
import 'package:cashier_system/core/class/statusrequest.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/core/dialogs/snackbar_helper.dart';
import 'package:cashier_system/core/functions/handing_data_controller.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/data/model/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class TransactionReceiptController extends TransactionController {
  clearSearchFileds() {
    noteController.clear();
    amountController.clear();
    noFromController.clear();
    noToController.clear();
    dateFromController.clear();
    dateToController.clear();
    searchSelectedSourceAccount = null;
    searchSelectedSourceAccountId = null;
    searchSelectedTargetAccountId = null;
    searchSelectedTargetAccount = null;
    transactionNumber.clear();

    getReceiptTransactionData(isInitialSearch: true);
  }

  //! --------------------------------------------------------
  //? Sorting Data
  bool isAccountFields = false;
  String selectedSortField = "transaction_date";
  bool sortAscending = true;
  void setAccountFields(bool value) {
    isAccountFields = value;
    update();
  }

  //? Sorting Function:
  void changeSortField(String field) {
    selectedSortField = field;
    getReceiptTransactionData(isInitialSearch: true);
    update();
  }

  //? Toggle Sorting Ascending/Descending:
  Future<void> toggleSortOrder() async {
    sortAscending = !sortAscending;
    getReceiptTransactionData(isInitialSearch: true);

    update();
  }

  //? Sorting Fields:
  List<Map<String, dynamic>> get sortFields => [
        {
          "title": TextRoutes.code,
          "value": "transaction_id",
          "icon": Icons.numbers,
        },
        {
          "title": TextRoutes.transactionNumber,
          "value": "transaction_number",
          "icon": Icons.numbers,
        },
        {
          "title": TextRoutes.date,
          "value": "transaction_date",
          "icon": Icons.calendar_today,
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
          "value": "transaction_amount",
          "icon": Icons.money,
        },
      ];
  bool showSnackBar = true;
  Future<void> getReceiptTransactionData({
    bool isInitialSearch = false,
  }) async {
    if (isLoading) return;

    try {
      if (isInitialSearch) {
        update();
        statusRequest = StatusRequest.loading;
        update();
        transactionReceiptData.clear();
        itemsOffset = 0;
        itemsPerPage = 50;
        showSnackBar = true;
      }

      // Prepare input filters
      String? startNo = noFromController.text.trim().isNotEmpty
          ? noFromController.text.trim()
          : null;
      String? endNo = noToController.text.trim().isNotEmpty
          ? noToController.text.trim()
          : null;
      String? startTime = dateFromController.text.trim().isNotEmpty
          ? dateFromController.text.trim()
          : null;
      String? endTime = dateToController.text.trim().isNotEmpty
          ? dateToController.text.trim()
          : null;
      String? trNumber = transactionNumber.text.trim().isNotEmpty
          ? transactionNumber.text.trim()
          : null;
      String? source = searchSelectedSourceAccount?.accountId.toString();
      String? target = searchSelectedTargetAccount?.accountId.toString();

      final response = await transactionClass.getTransactionsReceiptData(
          startNo: startNo,
          endNo: endNo,
          transactionNumber: trNumber,
          startTime: startTime,
          endTime: endTime,
          limit: itemsPerPage,
          offset: itemsOffset,
          sourceAccount: source,
          targetAccount: target,
          isAsc: sortAscending,
          sortBy: selectedSortField);
      statusRequest = handlingData(response);
      if (statusRequest == StatusRequest.success) {
        final List responsedata = response['data'] ?? [];

        if (responsedata.isNotEmpty) {
          transactionReceiptData
              .addAll(responsedata.map((e) => TransactionModel.fromMap(e)));
          itemsOffset += itemsPerPage;
        } else {
          if (isInitialSearch || transactionReceiptData.isEmpty) {
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
      showErrorDialog(e.toString(), message: TextRoutes.errorFetchingItemsData);
    } finally {
      isLoading = false;
      update();
    }
  }

//? Add TransactionData:
  addReceiptTransactionDatas() async {
    try {
      if (!formState!.currentState!.validate()) {
        showErrorSnackBar(TextRoutes.formValidationFailed);
        return;
      }
      if (selectedSourceAccountId == null || selectedTargetAccountId == null) {
        showErrorSnackBar("Please select both source and target accounts");
        return;
      }
      String transactionNumber = await generateVoucherNumber();
      Map<String, dynamic> data = {
        "transaction_type": 'receipt',
        "source_account_id": selectedSourceAccountId,
        "target_account_id": selectedTargetAccountId,
        "transaction_amount": double.tryParse(amountController.text),
        "transaction_discount": double.tryParse(discountController.text),
        "transaction_note": noteController.text,
        "transaction_number": transactionNumber,
        "transaction_date":
            dateController.text.isEmpty ? currentTime : dateController.text,
      };
      int response = await transactionClass.addTransactionsData(data);
      if (response > 0) {
        showSuccessSnackBar(TextRoutes.dataAddedSuccess);
        clearTransactionFields("receipt");
        getReceiptTransactionData(isInitialSearch: true);
      } else {
        showErrorSnackBar(TextRoutes.failAddData);
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          message: "Error occurred while adding transaction");
    } finally {
      update();
    }
  }

//? Update TransactionData:
  updateReceiptTransactionDatas() async {
    try {
      if (!formState!.currentState!.validate()) {
        showErrorSnackBar(TextRoutes.formValidationFailed);
        return;
      }
      if (selectedSourceAccount == null || selectedTargetAccountId == null) {
        showErrorSnackBar("Please select both source and target accounts");
        return;
      }
      Map<String, dynamic> data = {
        "transaction_type": 'receipt',
        "source_account_id": selectedSourceAccountId,
        "target_account_id": selectedTargetAccountId,
        "transaction_amount": double.tryParse(amountController.text),
        "transaction_discount": double.tryParse(discountController.text),
        "transaction_note": noteController.text,
        "transaction_date":
            dateController.text.isEmpty ? currentTime : dateController.text,
      };
      int response =
          await transactionClass.updateTransactionsData(data, idController!);
      if (response > 0) {
        showSuccessSnackBar(TextRoutes.dataUpdatedSuccess);
        clearTransactionFields("receipt");
        getReceiptTransactionData(isInitialSearch: true);
      } else {
        showErrorSnackBar(TextRoutes.dataUpdatedSuccess);
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          message: "Error occurred while adding transaction");
    } finally {
      update();
    }
  }

//? Delete transaction Data:
  removeReceiptTransactionDatas(List<int> transactionIds) async {
    try {
      int response =
          await transactionClass.removeTransactionsData(transactionIds);
      if (response > 0) {
        showSuccessSnackBar(TextRoutes.dataDeletedSuccess);
        getReceiptTransactionData(isInitialSearch: true);
      } else {
        showErrorSnackBar(TextRoutes.failDeleteData);
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          message: "Error occurred while deleting transaction(s)");
    } finally {
      update();
    }
  }

  Future<String> generateVoucherNumber() async {
    final currentYear = DateTime.now().year.toString();
    Database? myDb = await sqlDb.db;
    final result = await myDb!.rawQuery('''
    SELECT transaction_number FROM tbl_transactions
    WHERE transaction_number LIKE 'TR-$currentYear-%'
    ORDER BY transaction_id DESC LIMIT 1
  ''');

    int nextNumber = 1;

    if (result.isNotEmpty) {
      final lastVoucherNumber = result[0]['transaction_number'] as String;
      final lastNumberStr = lastVoucherNumber.split('-').last;
      final lastNumber = int.tryParse(lastNumberStr) ?? 0;
      nextNumber = lastNumber + 1;
    }

    final formattedNumber = nextNumber.toString().padLeft(4, '0');

    return 'TR-$currentYear-$formattedNumber';
  }

  @override
  void onInit() {
    getSourceAccountData("receipt");
    getReceiptTransactionData();
    super.onInit();
  }
}
