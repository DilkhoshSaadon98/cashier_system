import 'package:cashier_system/controller/transactions/transaction_controller.dart';
import 'package:cashier_system/core/class/statusrequest.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/core/dialogs/snackbar_helper.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/functions/handing_data_controller.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/data/model/account_model.dart';
import 'package:cashier_system/data/model/journal_voucher_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class JournalVoucherController extends TransactionController {
  final TextEditingController journalNumberController = TextEditingController();
  final TextEditingController generalNoteController = TextEditingController();

  bool allRowInserted = true;
  //? Clear Fields:
  clearSearchFields() {
    noToController.clear();
    noFromController.clear();
    dateFromController.clear();
    dateToController.clear();
    transactionNumber.clear();
    fetchVoucherData(isInitialSearch: true);
  }

  final formKey = GlobalKey<FormState>();
  List<JournalRow> journalRows = [JournalRow()];
  addJournalRows() {
    journalRows.add(JournalRow());
    update();
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
    fetchVoucherData(isInitialSearch: true);
    update();
  }

  //? Toggle Sorting Ascending/Descending:
  Future<void> toggleSortOrder() async {
    sortAscending = !sortAscending;
    fetchVoucherData(isInitialSearch: true);

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
  Future<String> generateVoucherNumber() async {
    final currentYear = DateTime.now().year.toString();
    Database? myDb = await sqlDb.db;
    final result = await myDb!.rawQuery('''
    SELECT voucher_number FROM tbl_vouchers
    WHERE voucher_number LIKE 'JV-$currentYear-%'
    ORDER BY voucher_id DESC LIMIT 1
  ''');

    int nextNumber = 1;

    if (result.isNotEmpty) {
      final lastVoucherNumber = result[0]['voucher_number'] as String;
      final lastNumberStr = lastVoucherNumber.split('-').last;
      final lastNumber = int.tryParse(lastNumberStr) ?? 0;
      nextNumber = lastNumber + 1;
    }

    final formattedNumber = nextNumber.toString().padLeft(4, '0');

    return 'JV-$currentYear-$formattedNumber';
  }

  //? Get Voucher Data:
  bool showSnackBar = true;
  fetchVoucherData({
    bool isInitialSearch = false,
  }) async {
    if (isLoading) return;

    try {
      if (isInitialSearch) {
        update();

        transactionPaymentData.clear();
        itemsOffset = 0;
        itemsPerPage = 50;
        showSnackBar = true;
        journalVoucherData.clear();
      }

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
      String? voucherNUmber = voucherNumber.text.trim().isNotEmpty
          ? voucherNumber.text.trim()
          : null;
      final response = await transactionClass.getVoucherData(
        startNo: startNo,
        endNo: endNo,
        startTime: startTime,
        endTime: endTime,
        limit: itemsPerPage,
        offset: itemsOffset,
        voucherNumber: voucherNUmber,
      );
      statusRequest = handlingData(response);
      if (statusRequest == StatusRequest.success) {
        final List responsedata = response['data'] ?? [];

        if (responsedata.isNotEmpty) {
          journalVoucherData
              .addAll(responsedata.map((e) => JournalVoucherModel.fromJson(e)));
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

  //? ADd Vouchers Data
  addVoucherData(BuildContext context) async {
    try {
      if (!formKey.currentState!.validate()) {
        showErrorSnackBar(TextRoutes.formValidationFailed);
        return;
      }
      for (var row in journalRows) {
        if (row.account == null || row.account?.accountId == null) {
          showErrorSnackBar(TextRoutes.formValidationFailed);
          return;
        }
      }
      double totalDebit = 0.0;
      double totalCredit = 0.0;

      for (var row in journalRows) {
        final debit = double.tryParse(row.debitController.text) ?? 0.0;
        final credit = double.tryParse(row.creditController.text) ?? 0.0;
        totalDebit += debit;
        totalCredit += credit;
      }

      if (totalDebit != totalCredit) {
        showErrorDialog(
          "Total debit ($totalDebit) and credit ($totalCredit) must be equal.",
          message: "Please correct the entries before saving.",
        );
        return;
      }
      if (totalDebit == 0 || totalCredit == 0) {
        showErrorSnackBar("credit or debit value is zero");
        return;
      }

      String voucherNumber = await generateVoucherNumber();
      int voucherId = await sqlDb.insertData('tbl_vouchers', {
        'voucher_date':
            dateController.text.isEmpty ? currentTime : dateController.text,
        'voucher_number': voucherNumber,
        'voucher_note': generalNoteController.text,
      });

      List<Map<String, dynamic>> debitLines = [];
      List<Map<String, dynamic>> creditLines = [];

      for (var row in journalRows) {
        final accountId = row.account?.accountId;
        final debit = double.tryParse(row.debitController.text) ?? 0.0;
        final credit = double.tryParse(row.creditController.text) ?? 0.0;
        final note = row.noteController.text;

        await sqlDb.insertData('tbl_voucher_lines', {
          'voucher_id': voucherId,
          'account_id': accountId,
          'debit': debit,
          'credit': credit,
          'note': note,
        });

        if (debit > 0) {
          debitLines.add({
            'account_id': accountId,
            'amount': debit,
            'note': note,
          });
        } else if (credit > 0) {
          creditLines.add({
            'account_id': accountId,
            'amount': credit,
            'note': note,
          });
        }
      }

      bool allRowInserted = true;
      try {
        for (var creditLine in creditLines) {
          for (var debitLine in debitLines) {
            await sqlDb.insertData('tbl_transactions', {
              'transaction_type': 'adjustment',
              'transaction_date': dateController.text,
              'transaction_amount': debitLine['amount'],
              'transaction_note': debitLine['note'] ?? creditLine['note'],
              'transaction_discount': 0.0,
              "transaction_number": voucherNumber,
              'source_account_id': creditLine['account_id'],
              'target_account_id': debitLine['account_id'],
            });
          }
        }
      } catch (e) {
        allRowInserted = false;
        showErrorDialog(e.toString(), message: TextRoutes.anErrorOccurred);
      }

      if (allRowInserted) {
        showSuccessSnackBar(TextRoutes.dataAddedSuccess);
        clearFields();
        fetchVoucherData(isInitialSearch: true);
        Navigator.pop(context);
      } else {
        showErrorSnackBar(TextRoutes.failAddData);
      }
    } catch (e) {
      showErrorDialog(e.toString(), message: TextRoutes.anErrorOccurred);
    } finally {
      update();
    }
  }

  Future<void> viewVoucherLines(int voucherId) async {
    try {
      var response = await sqlDb.getData(
        "SELECT * FROM view_voucher_lines_details WHERE voucher_id = $voucherId",
      );
      if (response.isEmpty) {
        showErrorSnackBar(TextRoutes.failDuringFetchData);
        return;
      }

      var lines =
          response.map((e) => VoucherLineDetailsModel.fromMap(e)).toList();

      Get.defaultDialog(
        title: "${TextRoutes.details.tr} ${TextRoutes.invoice.tr} $voucherId",
        content: SizedBox(
          width: Get.width * 0.9,
          height: Get.height * 0.5,
          child: ListView.builder(
            itemCount: lines.length,
            itemBuilder: (context, index) {
              final line = lines[index];
              return Card(
                child: ListTile(
                  title: Text(
                    "${line.accountType.toString().tr} - ${line.accountName}",
                    style: titleStyle,
                  ),
                  subtitle: Text(
                    "${TextRoutes.debit.tr}: ${formattingNumbers(line.debit)} | ${TextRoutes.credit.tr}: ${formattingNumbers(line.credit)}",
                    style: bodyStyle,
                  ),
                  trailing: line.lineNote != null
                      ? Text(
                          "${TextRoutes.note.tr}: ${line.lineNote}",
                          style: bodyStyle,
                        )
                      : null,
                ),
              );
            },
          ),
        ),
      );
    } catch (e) {
      showErrorDialog(e.toString(), message: TextRoutes.anErrorOccurred);
    }
  }

  void clearFields() {
    dateController.clear();
    journalNumberController.clear();
    generalNoteController.clear();

    for (var row in journalRows) {
      row.debitController.clear();
      row.creditController.clear();
      row.noteController.clear();
      row.account = null;
    }

    journalRows = [JournalRow()];
  }

  @override
  void onInit() {
    fetchVoucherData();
    super.onInit();
  }
}

class JournalRow {
  AccountModel? account;
  TextEditingController debitController = TextEditingController();
  TextEditingController creditController = TextEditingController();
  TextEditingController noteController = TextEditingController();
}
