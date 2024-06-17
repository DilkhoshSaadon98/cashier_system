import 'package:cashier_system/data/model/purchaes_model.dart';
import 'package:cashier_system/data/sql/data/buying_class.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyingDetailsViewController extends GetxController {
  //! Database Classes
  BuyingClass buyingClass = BuyingClass();
  //! Text Controllers
  //! View Items
  late TextEditingController itemsNameController;
  late TextEditingController itemsSellingPriceController;
  late TextEditingController itemsBuyingPriceController;
  late TextEditingController purchaseDateController;
  late TextEditingController itemsIdController;
  late TextEditingController groupByIdController;
  late TextEditingController groupByNameController;
  List<PurchaseModel> purchaseDetailsData = [];
  //! Buy Items
  late TextEditingController itemCodeController;
  //! Search Side Titles:
  List<String> itemsTitle = [
    "Items NO",
    "Items Name",
    "Purchase Date",
    "Selling Price",
    "Buying Price",
  ];

  getPurchaseDetailsData(String purchaseNumber) async {
    String? itemsNO;
    String? itemsName;
    String? itemsSelling;
    String? itemsBuying;
    String? itemsDate;
    String? groupBy;

    if (itemsIdController.text.isNotEmpty) {
      itemsNO = itemsIdController.text;
    }
    if (itemsNameController.text.isNotEmpty) {
      itemsName = itemsNameController.text;
    }
    if (itemsSellingPriceController.text.isNotEmpty) {
      itemsSelling = itemsSellingPriceController.text;
    }
    if (itemsBuyingPriceController.text.isNotEmpty) {
      itemsBuying = itemsBuyingPriceController.text;
    }
    if (purchaseDateController.text.isNotEmpty) {
      itemsDate = purchaseDateController.text;
    }
    if (groupByNameController.text.isNotEmpty) {
      groupBy = groupByNameController.text;
    }
    var response = await buyingClass.searchPurchaseDetailsData(purchaseNumber,
        itemsBuying: itemsBuying,
        itemsDate: itemsDate,
        itemsName: itemsName,
        itemsNo: itemsNO,
        itemsSelling: itemsSelling,
        groupBy: groupBy);
    if (response['status'] == "success") {
      List responsedata = response['data'] ?? [];
      purchaseDetailsData
          .addAll(responsedata.map((e) => PurchaseModel.fromJson(e)));
    }
    update();
  }

  List<TextEditingController> itemsController = [];
  String cartNumber = "";

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
    if (cartNumber.isNotEmpty) {
      getPurchaseDetailsData(cartNumber);
    }
  }
}
