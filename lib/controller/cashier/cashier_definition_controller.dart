import 'package:cashier_system/data/model/locale/custom_selected_list_items.dart';
import 'package:cashier_system/data/model/invoice_model.dart';
import 'package:cashier_system/data/model/locale/custom_selected_list_users.dart';
import 'package:cashier_system/data/sql/data/cashier_class.dart';
import 'package:cashier_system/core/class/statusrequest.dart';
import 'package:cashier_system/core/services/services.dart';
import 'package:cashier_system/data/model/cart_model.dart';
import 'package:cashier_system/data/model/items_model.dart';
import 'package:cashier_system/data/model/users_model.dart';
import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CashierDefinitionController extends GetxController {
  //? class to access to functions that sending data request:
  //? class to access to Shared Preference:
  final MyServices myServices = Get.find();
  //? class to check request status:
  StatusRequest statusRequest = StatusRequest.none;
  //? Define Controlller for textformfields:
  TextEditingController? itemsQuantity;
  TextEditingController? dropDownName;
  TextEditingController? dropDownID;
  TextEditingController? catName;
  TextEditingController? catID;
  //? Store drop down data items
  List<CustomSelectedListItems> dropDownList = [];
  //? Data Lists:
  //* Cart Data List
  List<CartModel> cartData = [];
  //* Item Drop Down Search Data List
  List<ItemsModel> listdataSearch = [];
  List<ItemsModel> dataItem = [];
  //* Last Invoices Data
  List<InvoiceModel> lastInvoices = [];
  //* Strore Selected Rows:
  List<String> selectedRows = [];
  //* Store pended Carts:
  List pendedCarts = [];
  //* Store Cart Number That Are pended
  List cartsNumbers = [];
  //* Counting pended Cart
  int pendingCartCount = 0;
  //* Store Cart Total Price
  int cartTotalPrice = 0;
  var totalPrice = 0;
  //*Cart Cost PRice:
  int cartTotalCostPrice = 0;
  //* Max Invoice Number:
  int maxInvoiceNumber = 0;
  //* Chaeck Buttons Hover State
  bool isHover = false;
  List<bool> hoverStates = List.filled(16, false);
  //* Sqlflite Define:
  SqlDb sqlDb = SqlDb();
  CashierClass cashierClass = CashierClass();
  //*
  int cartItemsCount = 0;
  //*
  bool checkValue = false;
  //* users list:
  List<CustomSelectedListUsers> dropDownListUsers = [];
  List<UsersModel> listdataSearchUsers = [];
  TextEditingController? cartOwnerNameController;
  TextEditingController? cartOwnerIdController;
  //* Payment Controller:
  TextEditingController? reminderController;
  //* Button Controller;
  TextEditingController? buttonActionsController;
  TextEditingController? usernameController;
  TextEditingController? addressController;
  TextEditingController? phoneController;
  TextEditingController? noteController;
  //* Form State Key:

  GlobalKey<FormState> formstate = GlobalKey<FormState>();
}
