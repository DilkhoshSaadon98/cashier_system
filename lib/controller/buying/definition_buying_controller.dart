import 'package:cashier_system/data/model/items_model.dart';
import 'package:cashier_system/data/model/purchaes_model.dart';
import 'package:cashier_system/data/model/users_model.dart';
import 'package:cashier_system/data/sql/data/buying_class.dart';
import 'package:cashier_system/data/sql/data/items_class.dart';
import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DefinitionBuyingController extends GetxController {
  //! Data Model
  List<ItemsModel> itemsNameData = [];
  List<ItemsModel> itemsCodesData = [];
  List<UsersModel> usersData = [];
  List<PurchaseModel> purchaseData = [];
  List<PurchaseModel> purchaseDetailsData = [];
  //! Database Classes
  BuyingClass buyingClass = BuyingClass();
  ItemsClass itemsClass = ItemsClass();
  SqlDb sqlDb = SqlDb();
  //! Store drop down data items
  List<SelectedListItem> dropDownList = [];
  List<SelectedListItem> dropDownListCodes = [];
  List<SelectedListItem> usersDropDownData = [];
  //! Table Rows:
  List<DataRow> rows = [];
  //! Search Side Titles:
  List<String> itemsTitle = [
    "Items NO",
    "Items Name",
    "Purchase Date",
    "Selling Price",
    "Buying Price",
  ];
  //! Update Screen Index:
  int currentIndex = 0;
  updateIndex(int index) {
    currentIndex = index;
    update();
  }

  //! Text Controllers
  //! View Items
  TextEditingController? itemsNameController;
  TextEditingController? itemsSellingPriceController;
  TextEditingController? itemsBuyingPriceController;
  TextEditingController? purchaseDateController;
  TextEditingController? itemsIdController;
  TextEditingController? groupByIdController;
  TextEditingController? groupByNameController;

  //! Buy Items
  TextEditingController? itemCodeController;
  TextEditingController? buyingPriceController;
  TextEditingController? quantityController;
  TextEditingController? sellingPriceController;
  TextEditingController? itemNameController;
  TextEditingController? supplierNameController;
  TextEditingController? supplierIdController;
  TextEditingController? paymentMethodNameController;
  TextEditingController? paymentMethodIdController;
  TextEditingController? purchaseDiscountController;
  TextEditingController? totalPriceController;
  //! List Text Controller:
  List<TextEditingController> itemCodeControllers = [];
  List<TextEditingController> buyingPriceControllers = [];
  List<TextEditingController> discountBuyingPriceControllers = [];
  List<TextEditingController> quantityControllers = [];
  List<TextEditingController> sellingPriceControllers = [];
  List<TextEditingController> itemNameControllers = [];
  List<TextEditingController> itemTotalPriceControllers = [];
  //! --------------------------Functions ---------------------------------
  //! Get Supplier names
  getUsers() async {
    var response = await sqlDb.getAllData("tbl_users");
    if (response['status'] == "success") {
      usersDropDownData.clear();
      usersData.clear();
      List responsedata = response['data'];
      usersData.addAll(responsedata.map((e) => UsersModel.fromJson(e)));
      for (int i = 0; i < usersData.length; i++) {
        usersDropDownData.add(SelectedListItem(
            name: usersData[i].usersName!,
            value: usersData[i].usersId!.toString()));
      }
    }
    update();
  }

//! Get Items Name for searching
  getItems() async {
    var response = await sqlDb.getAllData("tbl_items");
    if (response['status'] == "success") {
      itemsNameData.clear();
      List responsedata = response['data'];
      itemsNameData.addAll(responsedata.map((e) => ItemsModel.fromJson(e)));
      for (int i = 0; i < itemsNameData.length; i++) {
        dropDownList.add(SelectedListItem(
            name: itemsNameData[i].itemsName!,
            value: itemsNameData[i].itemsId!.toString()));
      }
    }
    update();
  }

//! Get Items Codes for searching
  getCodes() async {
    var response = await sqlDb.getAllData("tbl_items");
    if (response['status'] == "success") {
      itemsCodesData.clear();
      dropDownListCodes.clear();
      List responsedata = response['data'];
      itemsCodesData.addAll(responsedata.map((e) => ItemsModel.fromJson(e)));
      for (int i = 0; i < itemsCodesData.length; i++) {
        dropDownListCodes.add(SelectedListItem(
            name: itemsCodesData[i].itemsId!.toString(),
            value: itemsCodesData[i].itemsName!.toString()));
      }
    }
    update();
  }
}
