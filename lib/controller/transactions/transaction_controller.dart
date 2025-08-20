import 'package:cashier_system/controller/printer/invoice_controller.dart';
import 'package:cashier_system/controller/printer/sunmi_printer_controller.dart';
import 'package:cashier_system/core/class/statusrequest.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/core/functions/date_picker.dart';
import 'package:cashier_system/core/functions/show_popup_menu.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/data/model/account_model.dart';
import 'package:cashier_system/data/model/journal_voucher_model.dart';
import 'package:cashier_system/data/model/transaction_model.dart';
import 'package:cashier_system/data/source/transaction_class.dart';
import 'package:cashier_system/core/class/sqldb.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionController extends GetxController {
  final CustomShowPopupMenu customShowPopupMenu = CustomShowPopupMenu();
  ScrollController? scrollControllers;
  final int pageSize = 20;
  bool hasMoreData = true;
  int currentPage = 0;
  int itemsPerPage = 50;
  int itemsOffset = 0;
  bool isLoading = false;
  bool showBackToTopButton = false;

  //? Check if an item is selected
  List<int> selectedRows = [];
  bool isSelected(int transactionId) {
    return selectedRows.contains(transactionId);
  }

  //? Select or deselect an item
  void selectData(int transactionId, bool? selected) {
    if (selected == true) {
      selectedRows.add(transactionId);
    } else {
      selectedRows.remove(transactionId);
    }
    update();
  }

//? Selecting Table Rows:
  void selectAllRows() {
    if (selectedRows.length == transactionData.length) {
      selectedRows.clear();
    } else {
      selectedRows = transactionData
          .map((transaction) => transaction.transactionId)
          .toList();
    }
    update();
  }

  void setDefaultAccountsForType(String transactionType) {
    selectedSourceAccount = null;
    selectedTargetAccount = null;
    selectedSourceAccountId = null;
    selectedTargetAccountId = null;

    switch (transactionType) {
      case 'receipt':
        final cashAccount = listDataSearchSourceAccounts.firstWhere(
          (a) => a.accountId == 7, // Box/Cash account ID
          orElse: () => AccountModel.empty(),
        );
        selectedTargetAccount = cashAccount;
        selectedTargetAccountId = cashAccount.accountId;
        break;

      case 'payment':
        final cashAccount = listDataSearchSourceAccounts.firstWhere(
          (a) => a.accountId == 7,
          orElse: () => AccountModel.empty(),
        );
        selectedSourceAccount = cashAccount;
        selectedSourceAccountId = cashAccount.accountId;
        break;

      case 'opening_entry':
        final openingAccount = listDataSearchSourceAccounts.firstWhere(
          (a) => a.accountId == 94, // Opening balance account ID
          orElse: () => AccountModel.empty(),
        );
        selectedSourceAccount = openingAccount;
        selectedSourceAccountId = openingAccount.accountId;
        break;

      default:
        break;
    }
  }

  GlobalKey<FormState>? formState = GlobalKey<FormState>();
  AccountModel? selectedSourceAccount;
  AccountModel? searchSelectedSourceAccount;
  AccountModel? selectedTargetAccount;
  AccountModel? searchSelectedTargetAccount;
  int? selectedSourceAccountId;
  int? searchSelectedSourceAccountId;
  int? selectedTargetAccountId;
  int? searchSelectedTargetAccountId;
  //?
  List<AccountModel> listDataSearchSourceAccounts = [];
  List<AccountModel> dropDownListSourceAccounts = [];
  List<AccountModel> dropDownListTargetAccounts = [];
  List<TransactionModel> transactionData = [];
  List<TransactionModel> transactionReceiptData = [];
  List<TransactionModel> transactionPaymentData = [];
  List<TransactionModel> transactionOpeningEntryData = [];
  List<JournalVoucherModel> journalVoucherData = [];
  //? All Field Controller :
  int? idController;
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController accountControllerName = TextEditingController();
  TextEditingController accountControllerId = TextEditingController();
  TextEditingController userControllerName = TextEditingController();
  TextEditingController userControllerId = TextEditingController();
  TextEditingController noFromController = TextEditingController();
  TextEditingController transactionNumber = TextEditingController();
  TextEditingController voucherNumber = TextEditingController();
  TextEditingController noToController = TextEditingController();
  TextEditingController dateToController = TextEditingController();
  TextEditingController dateFromController = TextEditingController();
  //?
  SqlDb sqlDb = SqlDb();
  TransactionClass transactionClass = TransactionClass();
  StatusRequest statusRequest = StatusRequest.none;
  //? Var:
  // String selectedTransactionType = "receipt";

  void clearTransactionFields(String type) {
    amountController.clear();
    dateController.clear();
    noteController.clear();
    discountController.clear();
    selectedSourceAccountId = null;
    selectedTargetAccount = null;
    selectedSourceAccount = null;
    selectedTargetAccount = null;
    voucherNumber.clear();
    setDefaultAccountsForType(type);
  }

  //? Field Data:
  List<Map<String, dynamic>> get addTransactionDataFields => [
        {
          "title": TextRoutes.sourceAccount,
          "icon": Icons.source,
          "controller": selectedSourceAccount,
          "valid": "",
          'source': true,
          'required': true
        },
        {
          "title": TextRoutes.targetAccount,
          "icon": Icons.account_tree_rounded,
          "controller": selectedTargetAccount,
          "valid": "",
          'source': false,
          'required': true
        },
        {
          "title": TextRoutes.date,
          "icon": Icons.date_range,
          "controller": dateController,
          "valid": "",
          'required': false,
          'on_tap': (BuildContext context, value) {
            selectDate(context, value);
          }
        },
        {
          "title": TextRoutes.amount,
          "icon": Icons.attach_money_outlined,
          "controller": amountController,
          "valid": "realNumber",
          'required': true
        },
        {
          "title": TextRoutes.discount,
          "icon": Icons.discount,
          "controller": discountController,
          "valid": "realNumber",
          'required': false
        },
        {
          "title": TextRoutes.note,
          "icon": Icons.note,
          "controller": noteController,
          "valid": "",
          'required': false
        },
      ];
  TextEditingController debitController = TextEditingController();
  TextEditingController creditController = TextEditingController();

  Future<void> getSourceAccountData(String type) async {
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

        setDefaultAccountsForType(type);
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

  String selectedPrinter =
      myServices.sharedPreferences.getString("selected_printer") ??
          TextRoutes.a4Printer;
  printData(
      List<TransactionModel> passedData, List<int> selectedPassedData) async {
    InvoiceController invoiceController = Get.put(InvoiceController());
    List<TransactionModel> selectedItems = passedData
        .where((transaction) => isSelected(transaction.transactionId))
        .toList();
    print(selectedItems.first.transactionNumber);
    if (selectedItems.isNotEmpty) {
      // invoiceController.loadPreferences();
      // invoiceController.update();
      Map<String, List<String>> result = {
        "#": [],
        TextRoutes.transactionNumber: [],
        TextRoutes.accountName: [],
        TextRoutes.ballance: [],
        TextRoutes.date: [],
        TextRoutes.note: [],
      };

      for (var i = 0; i < selectedItems.length; i++) {
        var transaction = selectedItems[i];

        // Add data to result map
        result["#"]!.add((i + 1).toString());
        result[TextRoutes.transactionNumber]!
            .add(transaction.transactionNumber);
        result[TextRoutes.accountName]!.add(transaction.targetAccountName);
        result[TextRoutes.ballance]!
            .add(transaction.transactionAmount.toString());
        result[TextRoutes.date]!.add(transaction.transactionDate);
        result[TextRoutes.note]!.add(transaction.transactionNote ?? "");
      }
      print(result);
      // Prepare the invoice data
      Map<String, dynamic> invoiceData = {};

      try {
        if (myServices.sharedPreferences.getString("selected_printer") ==
            null) {
          myServices.sharedPreferences
              .setString('selected_printer', TextRoutes.a4Printer);
        }
        if (selectedPrinter == "A4 Printer") {
          invoiceController.exportInvoicePdf(invoiceData, result, "bills");
        } else if (selectedPrinter == TextRoutes.a4Printer) {
          invoiceController.printInvoice(invoiceData, result, "bills");
        } else if (selectedPrinter == "SUNMI Printer") {
          PrinterController printerController = Get.put(PrinterController());
          printerController.printTable(
            invoiceController.selectedHeaders,
            invoiceController.selectedColumns,
            invoiceData,
            result,
          );
        } else if (selectedPrinter == "Mini Printer") {
          PrinterController printerController = Get.put(PrinterController());
          printerController.printTable(
            invoiceController.selectedHeaders,
            invoiceController.selectedColumns,
            invoiceData,
            result,
          );
        }
      } catch (e) {
        showErrorDialog(e.toString(),
            title: "Error", message: "Failed to update the invoice");
      }
    }
  }

  @override
  void onInit() {
    scrollControllers = ScrollController();
    super.onInit();
  }
}
