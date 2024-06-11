import 'package:cashier_system/core/class/statusrequest.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/routes.dart';
import 'package:cashier_system/core/functions/handing_data_controller.dart';
import 'package:cashier_system/data/model/items_model.dart';
import 'package:cashier_system/data/model/purchaes_model.dart';
import 'package:cashier_system/data/sql/data/items_class.dart';
import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemsViewController extends GetxController {
  ScrollController scrollController = ScrollController();
  TextEditingController? itemsNameController;
  TextEditingController? itemsDesc;
  TextEditingController? itemsCountContrller;
  TextEditingController? itemsSellingPriceController;
  TextEditingController? itemsTypeController;
  TextEditingController? itemsBarcodeController;
  TextEditingController? catNameController;
  List<PurchaseModel> purchaesData = [];
  String? catId;
  double? scrollPosition = 0.0;
  bool isHover = false;
  Color continerColor = thirdColor;
  List<bool> hoverStates = [];
  ItemsClass itemsClass = ItemsClass();
  SqlDb sqlDb = SqlDb();

  void setHoverState(int index, bool isHovered) {
    hoverStates[index] = isHovered;
    update();
  }

  List<String> itemsTitle = [
    "Items NO",
    "Items Name",
    "Items QTY",
    "Selling Price",
    "Items Type",
    "Items Categories",
  ];

  bool isSearch = false;
  TextEditingController? search;
  checkSearch(val) {
    if (val == "") {
      statusRequest = StatusRequest.none;
      isSearch = false;
    }
    update();
  }

  onSearchItems() {
    isSearch = true;
    searchItems();
    update();
  }

  clearFileds() {
    itemsNameController!.clear();
    itemsCountContrller!.clear();
    itemsSellingPriceController!.clear();
    itemsTypeController!.clear();
    itemsBarcodeController!.clear();
    catNameController!.clear();
    itemsDesc!.clear();
  }

  List<ItemsModel> data = [];
  List<ItemsModel> listdataSearch = [];

  StatusRequest statusRequest = StatusRequest.none;

  getItems() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await itemsClass.getItemsData();
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      if (response['status'] == "success") {
        data.clear();
        hoverStates.clear();
        List dataList = response['data'];
        hoverStates = List.generate(dataList.length, (_) => false);
        data.addAll(dataList.map((e) => ItemsModel.fromJson(e)));
      } else {
        statusRequest = StatusRequest.failure;
      }
      // End
    }
    update();
  }

  searchItems() async {
    String? itemsNO;
    String? itemsName;
    String? itemsCount;
    String? itemsSelling;
    String? itemsType;
    String? itemsCat;
    if (itemsBarcodeController!.text.isNotEmpty) {
      itemsNO = itemsBarcodeController!.text;
    }
    if (itemsNameController!.text.isNotEmpty) {
      itemsName = itemsNameController!.text;
    }
    if (itemsCountContrller!.text.isNotEmpty) {
      itemsCount = itemsCountContrller!.text;
    }
    if (itemsSellingPriceController!.text.isNotEmpty) {
      itemsSelling = itemsSellingPriceController!.text;
    }
    if (itemsTypeController!.text.isNotEmpty) {
      itemsType = itemsTypeController!.text;
    }
    if (catNameController!.text.isNotEmpty) {
      itemsCat = catNameController!.text;
    }
    statusRequest = StatusRequest.loading;
    var response = await itemsClass.searchItemsData(
      itemsNo: itemsNO,
      itemsName: itemsName,
      itemsCount: itemsCount,
      itemsSelling: itemsSelling,
      itemsType: itemsType,
      itemsCategories: itemsCat,
    );
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      if (response['status'] == "success") {
        listdataSearch.clear();
        hoverStates.clear();
        List responsedata = response['data'];
        hoverStates = List.generate(responsedata.length, (_) => false);
        listdataSearch.addAll(responsedata.map((e) => ItemsModel.fromJson(e)));
      } else {
        statusRequest = StatusRequest.failure;
      }
    }
    update();
  }

  deleteItems(String id) {
    sqlDb.deleteData("tbl_items", "items_id = $id");
    Get.offAndToNamed(AppRoute.itemsScreen);
    getItems();
    update();
  }

  goUpdateItems(ItemsModel itemsModel) {
    Get.toNamed(AppRoute.itemsUpdateScreen,
        arguments: {'itemsModel': itemsModel});
  }

  getItemTransaction(String itemsId) async {
    var response = await sqlDb.getAllData("tbl_purchase",
        where: "purchase_items_id = $itemsId");
    purchaesData.clear();
    if (response['status'] == 'success') {
      List responsedata = response['data'] ?? [];
      purchaesData.addAll(responsedata.map((e) => PurchaseModel.fromJson(e)));
    }
  }

  updateItemPrice(
      String itemsId, String buyingPrice, String sellingPrice) async {
    Map<String, dynamic> data = {
      "items_selling": sellingPrice,
      "items_buingprice": buyingPrice,
    };
    var response =
        await sqlDb.updateData("tbl_items", data, "items_id = $itemsId");
    if (response > 0) {
      getItems();
    }
  }

  List<TextEditingController?> itemsController = [];
  @override
  void onInit() {
    getItems();
    search = TextEditingController();
    itemsNameController = TextEditingController();
    itemsDesc = TextEditingController();
    itemsCountContrller = TextEditingController();
    itemsSellingPriceController = TextEditingController();
    itemsTypeController = TextEditingController();
    itemsBarcodeController = TextEditingController();
    catNameController = TextEditingController();
    itemsController = [
      itemsBarcodeController,
      itemsNameController,
      itemsCountContrller,
      itemsSellingPriceController,
      itemsTypeController,
      catNameController,
    ];
    super.onInit();
  }
}
