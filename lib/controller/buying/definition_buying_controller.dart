import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/data/model/items_model.dart';
import 'package:cashier_system/data/model/purchaes_model.dart';
import 'package:cashier_system/data/model/users_model.dart';
import 'package:cashier_system/data/sql/data/buying_class.dart';
import 'package:cashier_system/data/sql/data/items_class.dart';
import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DefinitionBuyingController extends GetxController {
  //! Data Model
  List<ItemsModel> itemsNameData = [];
  List<ItemsModel> itemsCodesData = [];
  List<UsersModel> usersData = [];
  List<PurchaseModel> purchaseData = [];
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
    "Purchase NO",
    "Total Price",
    "Purchase Date",
    "Supplier Name",
    "Payment Method"
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
  TextEditingController? purchaseIdController;
  TextEditingController? purchaseTotalPriceController;
  TextEditingController? purchaseSupplierNameController;
  TextEditingController? purchasePaymentMethodController;

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
  TextEditingController? purchaseFeesController;
  TextEditingController? totalPriceController;
  //! List Text Controller:
  List<TextEditingController> itemCodeControllers = [];
  List<TextEditingController> buyingPriceControllers = [];
  List<TextEditingController> discountBuyingPriceControllers = [];
  List<TextEditingController> quantityControllers = [];
  List<TextEditingController> sellingPriceControllers = [];
  List<TextEditingController> itemNameControllers = [];
  List<TextEditingController> itemTotalPriceControllers = [];

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<GlobalKey<FormState>> formKeysCode = [];
  List<GlobalKey<FormState>> formKeysName = [];
  List<GlobalKey<FormState>> formKeysBuying = [];
  List<GlobalKey<FormState>> formKeysBuyingDiscount = [];
  List<GlobalKey<FormState>> formKeysQTY = [];
  List<GlobalKey<FormState>> formKeysTotalPrice = [];
  //! --------------------------Functions ---------------------------------
  //? Get current date Data for date picker
  DateTime selectedDate = DateTime.now();
  Future<void> selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      barrierColor: primaryColor.withOpacity(.3),
      initialDate: selectedDate,
      firstDate: DateTime(2024, 1),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) selectedDate = picked;
    controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
    update();
  }

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

  Future<int> generateUniquePurchaseNumber() async {
    int result = 0;
    var response = await sqlDb.getData(
        "SELECT MAX(purchase_number) AS purchase_number FROM tbl_purchase");
    if (response[0]['purchase_number'] == null) {
      result = 0;
    } else {
      result = response[0]['purchase_number'];
    }
    return result;
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
