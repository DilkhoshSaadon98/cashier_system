import 'package:cashier_system/controller/printer/invoice_controller.dart';
import 'package:cashier_system/controller/printer/sunmi_printer_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/data/model/purchaes_model.dart';
import 'package:cashier_system/data/source/buying_class.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyingDetailsViewController extends GetxController {
  //! Database Classes
  final BuyingClass buyingClass = BuyingClass();

  //! Text Controllers
  late final TextEditingController itemsNameController;
  late final TextEditingController itemsSellingPriceController;
  late final TextEditingController itemsBuyingPriceController;
  late final TextEditingController purchaseDateController;
  late final TextEditingController itemsIdController;
  late final TextEditingController groupByIdController;
  late final TextEditingController groupByNameController;
  late final TextEditingController itemCodeController;

  //! Data
  List<PurchaseModel> purchaseDetailsData = [];

  //! Search Side Titles:
  final List<String> itemsTitle = [
    "Items NO",
    "Items Name",
    "Purchase Date",
    "Selling Price",
    "Buying Price",
  ];

  List<TextEditingController> itemsController = [];
  String cartNumber = "";
  bool showBackButton = false;

  @override
  void onInit() {
    super.onInit();

    //! Initialize controllers for adding items
    itemsNameController = TextEditingController();
    itemsSellingPriceController = TextEditingController();
    itemsBuyingPriceController = TextEditingController();
    purchaseDateController = TextEditingController();
    itemsIdController = TextEditingController();
    groupByIdController = TextEditingController();
    groupByNameController = TextEditingController();
    itemCodeController = TextEditingController();

    itemsController = [
      itemsIdController,
      itemsNameController,
      purchaseDateController,
      itemsSellingPriceController,
      itemsBuyingPriceController
    ];

    cartNumber = Get.arguments['purchase_number'] ?? '';
    showBackButton = Get.arguments['show_back_button'] ?? false;
    if (cartNumber.isNotEmpty) {
      getPurchaseDetailsData(cartNumber);
    }
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

  //? Print Data:
  String selectedPrinter =
      myServices.sharedPreferences.getString("selected_printer") ??
          "A4 Printer";
  printingData() {
    List<dynamic> passedData = purchaseDetailsData;
    InvoiceController invoiceController = Get.put(InvoiceController());
    if (passedData.isNotEmpty) {
      Map<String, List<String>> result = {
        "#": [],
        "Code": [],
        "Item Name": [],
        "Price": [],
        "QTY": [],
        "Total Price": [],
      };
      for (var i = 0; i < passedData.length; i++) {
        var data = passedData[i];
        result["#"]!.add((i + 1).toString());
        result["Code"]!.add(data.purchaseNumber.toString());
        result["Item Name"]!.add(data.itemsName);
        result["Price"]!.add(data.purchasePrice.toString());
        result["QTY"]!.add(data.purchaseQuantity.toString());
        result["Total Price"]!
            .add((data.purchaseQuantity * data.purchasePrice).toString());
      }
      String customerName = passedData[0].userName ?? " ";
      String customerAddress = passedData[0].usersAddress ?? " ";
      String customerPhone = passedData[0].usersPhone ?? " ";
      String discount = passedData[0].purchaseDiscount.toString();
      String fees = passedData[0].purchaseFees.toString();
      bool allSame = true;

      for (int i = 1; i < passedData.length; i++) {
        if (passedData[i].userName != customerName) {
          allSame = false;
          break;
        }
      }

      if (allSame) {
        customerName = passedData[0].userName ?? " ";
        customerAddress = passedData[0].usersAddress ?? " ";
        customerPhone = passedData[0].usersPhone ?? " ";
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
        "Discount": discount,
        "Fees": fees,
        "Number Of Items": passedData.length,
        "Total Price": passedData[0].purchaseTotalPrice
      };
      try {
        if (myServices.sharedPreferences.getString("selected_printer") ==
            null) {
          myServices.sharedPreferences
              .setString('selected_printer', "A4 Printer");
        }
        if (selectedPrinter == "A4 Printer") {
          invoiceController.printInvoice(invoiceData, result, "inventory",
              passedHeaders: [
                "Code",
                "Item Name",
                "Price",
                "QTY",
                "Total Price"
              ]);
        } else if (selectedPrinter == "A5 Printer") {
          invoiceController.printInvoice(invoiceData, result, "inventory",
              passedHeaders: [
                "Code",
                "Item Name",
                "Price",
                "QTY",
                "Total Price"
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

  @override
  void onClose() {
    //! Dispose controllers to avoid memory leaks
    itemsNameController.dispose();
    itemsSellingPriceController.dispose();
    itemsBuyingPriceController.dispose();
    purchaseDateController.dispose();
    itemsIdController.dispose();
    groupByIdController.dispose();
    groupByNameController.dispose();
    itemCodeController.dispose();
    super.onClose();
  }
}
