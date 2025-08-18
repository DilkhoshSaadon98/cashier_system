import 'package:cashier_system/controller/buying/buying_controller.dart';
import 'package:cashier_system/controller/printer/invoice_controller.dart';
import 'package:cashier_system/controller/printer/sunmi_printer_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/core/functions/show_popup_menu.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/data/model/items_model.dart';
import 'package:cashier_system/data/model/locale/custom_selected_list_items.dart';
import 'package:cashier_system/data/model/locale/custom_selected_list_users.dart';
import 'package:cashier_system/data/model/purchaes_model.dart';
import 'package:cashier_system/data/model/supplier_model.dart';
import 'package:cashier_system/data/model/units_model.dart';
import 'package:cashier_system/data/model/users_model.dart';
import 'package:cashier_system/data/source/buying_class.dart';
import 'package:cashier_system/data/source/items_class.dart';
import 'package:cashier_system/core/class/sqldb.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DefinitionBuyingController extends GetxController {
  //! Data Model
  List<ItemsModel> itemsNameData = [];
  List<ItemsModel> itemsCodesData = [];
  List<UsersModel> usersData = [];
  List<PurchaseModel> purchaseData = [];
  //! Data
  List<PurchaseModel> purchaseDetailsData = [];
  //! Database Classes
  final BuyingClass buyingClass = BuyingClass();
  final ItemsClass itemsClass = ItemsClass();
  final SqlDb sqlDb = SqlDb();

  //! Store drop-down data items
  List<CustomSelectedListItems> dropDownList = [];
  List<CustomSelectedListUsers> dropDownListUsers = [];
  List<SupplierModel> listDataSearchUsers = [];

  //! Search Side Titles:
  final List<String> itemsTitle = [
    TextRoutes.purchaes,
    "Total Price",
    "Purchase Date",
    "Supplier Name",
    "Payment"
  ];

  //! Update Screen Index:
  int currentIndex = 0;

  String selectedSection = TextRoutes.view;

  changeSection(value) {
    selectedSection = value;
    update();
  }

  String selectedSearchPaymentMethod = TextRoutes.all;

  changeSearchPaymentMethod(value) {
    selectedSearchPaymentMethod = value;
    update();
  }

  //! Text Controllers
  late TextEditingController itemsNameController = TextEditingController();
  late TextEditingController transactionNumberController =
      TextEditingController();
  late TextEditingController itemsSellingPriceController;
  late TextEditingController itemsBuyingPriceController;
  late TextEditingController purchaseDateController;
  late TextEditingController itemsIdController;
  late TextEditingController groupByIdController;
  late TextEditingController groupByNameController;
  late TextEditingController purchaseIdController;
  late TextEditingController purchaseTotalPriceController;
  late TextEditingController purchaseSupplierNameController;
  late TextEditingController purchasePaymentMethodController;

  //! Buy Items
  late TextEditingController itemCodeController;
  late TextEditingController buyingPriceController;
  late TextEditingController quantityController;

  late TextEditingController sellingPriceController;
  late TextEditingController itemNameController;
  late TextEditingController supplierNameController;
  late TextEditingController supplierIdController;
  late TextEditingController paymentMethodNameController;
  late TextEditingController paymentMethodIdController;
  late TextEditingController purchaseDiscountController;
  late TextEditingController dateController;
  late TextEditingController purchaseFeesController;
  late TextEditingController totalPriceController;

  GlobalKey<FormState> detailsFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> itemsFormKey = GlobalKey<FormState>();

  String paymentMethod = TextRoutes.cash;
  changePaymentMethod(String value) {
    paymentMethod = value;
    update();
  }

  List<Map<String, dynamic>> get searchFields => [
        {
          "title": TextRoutes.transactionNumber,
          "icon": Icons.numbers,
          "controller": transactionNumberController,
          "valid": "",
          'read_only': false
        },
        {
          "title": TextRoutes.supplierName,
          "icon": Icons.person,
          "controller": supplierNameController,
          "valid": "",
          'read_only': false
        },
        {
          "title": TextRoutes.date,
          "icon": Icons.date_range,
          "controller": dateController,
          "valid": "",
          'read_only': true
        },
        {
          "title": TextRoutes.paymentString,
          "icon": Icons.payment,
          "controller": itemsSellingPriceController,
          "valid": "",
          'read_only': false
        },
      ];
  final CustomShowPopupMenu customShowPopupMenu = CustomShowPopupMenu();
  //? Lazy Loading Variables:
  final int pageSize = 20;
  bool hasMoreData = true;
  int currentPage = 0;
  int itemsPerPage = 100;
  bool isLoading = false;
  bool rowAdded = false;
  ScrollController purchaseScrollControllers = ScrollController();
  bool showBackToTopButton = false;
  //?
  int totalInvoicePrice = 0;
  int rowIndexCounter = 0;
  List<String> selectedRows = [];
  //? Unit data store
  final List<UnitModel> unitsData = [];
  final List<String> dropdownItems = [];

  //? Fetch unit data for an item
  Future<void> getUnitsData(int itemId) async {
    try {
      var response =
          await sqlDb.getAllData("unitsView", where: "unit_item_id = $itemId");
      unitsData.clear();
      dropdownItems.clear();
      if (response['status'] == 'success') {
        List responsedata = response['data'] ?? [];
        unitsData.addAll(responsedata.map((e) => UnitModel.fromJson(e)));
        dropdownItems.addAll(unitsData.map((unit) => unit.unitBaseName));
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error fetching unit data:");
    } finally {
      update();
    }
  }

  //! Functions
//? Check if an item is selected
  bool isSelected(int itemsId, List selectedItems) {
    return selectedItems.contains(itemsId);
  }

  //? Select or deselect an item
  void selectItem(int itemsId, bool? selected, List selectedItems) {
    if (selected == true) {
      selectedItems.add(itemsId);
    } else {
      selectedItems.remove(itemsId);
    }
    update();
  }

  //! Get Supplier Names
  Future<void> getUsers() async {
    try {
      var response = await sqlDb.getAllData("tbl_supplier");
      if (response['status'] == "success") {
        listDataSearchUsers.clear();
        dropDownListUsers.clear();
        List responsedata = response['data'];
        listDataSearchUsers
            .addAll(responsedata.map((e) => SupplierModel.fromJson(e)));
        for (int i = 0; i < listDataSearchUsers.length; i++) {
          dropDownListUsers.add(CustomSelectedListUsers(
            name: listDataSearchUsers[i].supplierName,
            address: listDataSearchUsers[i].supplierAddress,
            phone: listDataSearchUsers[i].supplierPhone,
            id: listDataSearchUsers[i].supplierId!.toString(),
          ));
        }
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Exception occurred while getting users");
      listDataSearchUsers.clear();
      dropDownListUsers.clear();
    } finally {
      update();
    }
  }

  List<PurchaseRowModel> purchaseRow = [];

  List<ItemsModel> itemsData = [];
  //? Get Items For Search
  Future<void> getItems() async {
    try {
      var response = await sqlDb.getAllData("view_items");
      if (response['status'] == "success") {
        itemsData.clear();
        List responsedata = response['data'];
        itemsData.addAll(responsedata.map((e) => ItemsModel.fromMap(e)));
        for (var row in purchaseRow) {
          if (itemsData.isNotEmpty) {
            row.itemsModel ??= itemsData.first;
          }
        }
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error fetching items");
    } finally {
      update();
    }
  }

  //? Print Data:
  String selectedPrinter =
      myServices.sharedPreferences.getString("selected_printer") ??
          "A4 Printer";
  printingData(List<dynamic> passedData) {
    InvoiceController invoiceController = Get.put(InvoiceController());
    if (passedData.isNotEmpty) {
      Map<String, List<String>> result = {
        "#": [],
        "Code": [],
        "Name": [],
        "Date": [],
        "Ballance": [],
        "Fees": [],
        "Discount": [],
        "Payment": [],
      };

      for (var i = 0; i < passedData.length; i++) {
        var data = passedData[i];
        result["#"]!.add((i + 1).toString());
        result["Code"]!.add(data.purchaseNumber.toString());
        result["Name"]!.add(data.userName ?? "UNKNOWN");
        result["Ballance"]!.add(data.purchaseTotalPrice.toString());
        result["Date"]!.add(data.purchaseDate.toString());
        result["Fees"]!.add(data.purchaseFees.toString());
        result["Discount"]!.add(data.purchaseDiscount.toString());
        result["Payment"]!.add(data.purchasePayment.toString());
      }
      String customerName = passedData[0].userName ?? " ";
      String customerAddress = passedData[0].usersAddress ?? " ";
      String customerPhone = passedData[0].usersPhone ?? " ";
      bool allSame = true;
      double totalPrice = result["Ballance"]!
          .map((value) =>
              double.tryParse(value) ?? 0.0) // Convert each value to double
          .reduce((a, b) => a + b);
      for (int i = 1; i < passedData.length; i++) {
        if (passedData[i].userName != customerName) {
          allSame = false;
          break;
        }
      }

      if (allSame) {
        customerName = passedData[0].userName ?? "Unknown";
        customerAddress = passedData[0].usersAddress ?? "Empty";
        customerPhone = passedData[0].usersPhone ?? "Empty";
      } else {
        customerName = " ";
        customerAddress = " ";
        customerPhone = " ";
      }
      // Prepare the invoice data
      Map<String, dynamic> invoiceData = {
        "Customer Name": customerName,
        "Customer Phone": customerPhone,
        "Customer Address": customerAddress,
        "Organizer Name":
            myServices.sharedPreferences.getString("admins_username") ??
                "Admin",
        "Date": currentTime,
        "Total Price": totalPrice.toString()
      };
      try {
        if (myServices.sharedPreferences.getString("selected_printer") ==
            null) {
          myServices.sharedPreferences
              .setString('selected_printer', "A4 Printer");
        }
        if (selectedPrinter == "A4 Printer") {
          invoiceController
              .printInvoice(invoiceData, result, "buying", passedHeaders: [
            "Code",
            "Supplier Name",
            "Ballance",
            "Payment",
            "Fees",
            "Discount",
            "Date",
          ]);
        } else if (selectedPrinter == "A5 Printer") {
          invoiceController
              .printInvoice(invoiceData, result, "buying", passedHeaders: [
            "Code",
            "Supplier Name",
            "Ballance",
            "Payment",
            "Fees",
            "Discount",
            "Date",
          ]);
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

  //! Generate Unique Purchase Number
  Future<String> generateVoucherNumber() async {
    final currentYear = DateTime.now().year.toString();
    Database? myDb = await sqlDb.db;
    final result = await myDb!.rawQuery('''
    SELECT transaction_number FROM tbl_transactions
    WHERE transaction_number LIKE 'PI-$currentYear-%'
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

    return 'PI-$currentYear-$formattedNumber';
  }

  Future<int> generateUniquePurchaseNumber() async {
    int result = 0;
    try {
      var response = await sqlDb.getData(
        "SELECT MAX(purchase_number) AS purchase_number FROM tbl_purchase",
      );
      if (response[0]['purchase_number'] != null) {
        result = response[0]['purchase_number'];
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error generating unique purchase number");
    }
    return result;
  }

  Future<void> getPurchaseDetailsData(String purchaseNumber) async {
    try {
      final response = await buyingClass.searchPurchaseDetailsData(
        purchaseNumber,
        itemsNo:
            itemsIdController.text.isNotEmpty ? itemsIdController.text : null,
        itemsName: itemsNameController.text.isNotEmpty
            ? itemsNameController.text
            : null,
        itemsSelling: itemsSellingPriceController.text.isNotEmpty
            ? itemsSellingPriceController.text
            : null,
        itemsBuying: itemsBuyingPriceController.text.isNotEmpty
            ? itemsBuyingPriceController.text
            : null,
        itemsDate: purchaseDateController.text.isNotEmpty
            ? purchaseDateController.text
            : null,
        groupBy: groupByNameController.text.isNotEmpty
            ? groupByNameController.text
            : null,
      );

      if (response['status'] == "success") {
        purchaseDetailsData.clear();
        List responsedata = response['data'] ?? [];
        purchaseDetailsData
            .addAll(responsedata.map((e) => PurchaseModel.fromJson(e)));
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error fetching purchase details");
    } finally {
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    //! Initialize Controllers
    itemsNameController = TextEditingController();
    itemsSellingPriceController = TextEditingController();
    itemsBuyingPriceController = TextEditingController();
    purchaseDateController = TextEditingController();
    itemsIdController = TextEditingController();
    groupByIdController = TextEditingController();
    groupByNameController = TextEditingController();
    purchaseIdController = TextEditingController();
    purchaseTotalPriceController = TextEditingController();
    purchaseSupplierNameController = TextEditingController();
    purchasePaymentMethodController = TextEditingController();
    itemCodeController = TextEditingController();
    buyingPriceController = TextEditingController();
    quantityController = TextEditingController();
    sellingPriceController = TextEditingController();
    itemNameController = TextEditingController();
    supplierNameController = TextEditingController();
    supplierIdController = TextEditingController();
    paymentMethodNameController = TextEditingController();
    paymentMethodIdController = TextEditingController();
    purchaseDiscountController = TextEditingController();
    dateController = TextEditingController();
    purchaseFeesController = TextEditingController();
    totalPriceController = TextEditingController();
  }
}
