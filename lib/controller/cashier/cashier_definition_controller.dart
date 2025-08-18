import 'package:cashier_system/data/model/locale/custom_selected_list_items.dart';
import 'package:cashier_system/data/model/invoice_model.dart';
import 'package:cashier_system/data/model/locale/custom_selected_list_users.dart';
import 'package:cashier_system/data/model/units_model.dart';
import 'package:cashier_system/data/source/cashier_class.dart';
import 'package:cashier_system/core/services/services.dart';
import 'package:cashier_system/data/model/cart_model.dart';
import 'package:cashier_system/data/model/items_model.dart';
import 'package:cashier_system/data/model/users_model.dart';
import 'package:cashier_system/data/source/items_class.dart';
import 'package:cashier_system/core/class/sqldb.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CashierDefinitionController extends GetxController {
  final FocusNode focusNode = FocusNode();
  bool isExpanded = false;
  //? class to access to functions that sending data request:
  //? class to access to Shared Preference:
  final MyServices myServices = Get.find();
  //? Define controller's for textformfields:
  TextEditingController? itemsQuantity;
  TextEditingController? dropDownName;
  TextEditingController? dropDownID;
  TextEditingController? catName;
  TextEditingController? catID;
  final TextEditingController itemsNameController = TextEditingController();
  final TextEditingController itemsDescControllerController =
      TextEditingController();
  final TextEditingController itemsCountController = TextEditingController();
  final TextEditingController itemsSellingPriceController =
      TextEditingController();
  final TextEditingController itemsBuyingPriceController =
      TextEditingController();
  final TextEditingController itemsCostPriceController =
      TextEditingController();
  final TextEditingController itemsWholeSalePriceController =
      TextEditingController();
  final TextEditingController itemsTypeController = TextEditingController();
  final TextEditingController itemsTypeControllerId = TextEditingController();
  final TextEditingController itemsCategoriesControllerId =
      TextEditingController();
  final TextEditingController itemsCategoriesControllerName =
      TextEditingController();
  final TextEditingController itemsBarcodeController = TextEditingController();
  final TextEditingController catNameController = TextEditingController();

  final ItemsClass itemsClass = ItemsClass();
  //? Scrolling
  final int pageSize = 20;
  bool hasMoreData = true;
  int currentPage = 0;
  int itemsPerPage = 100;
  bool isLoading = false;
  //? Store drop down data items
  List<CustomSelectedListItems> dropDownList = [];
  //? Data Lists:
  //* Cart Data List
  List<CartModel> cartData = [];
  //* Item Drop Down Search Data List
  List<ItemsModel> listDataSearch = [];
  List<ItemsModel> dataItem = [];
  //* Last Invoices Data
  List<InvoiceModel> lastInvoices = [];
  //*
  List<UnitModel> unitsData = [];
  //* Store Selected Rows:
  List<int> selectedRows = [];
  //* Store pended Carts:
  List<int> pendedCarts = []; // Changed type to CartModel
  //* Store Cart Number That Are pended
  List<int> cartsNumbers = []; // Changed type to int
  //* Counting pended Cart
  int pendingCartCount = 0;
  //* Store Cart Total Price
  double cartTotalPrice = 0.0; // Changed to 0.0
  double totalPrice = 0.0; // Changed to 0.0
  //*Cart Cost Price:
  int cartTotalCostPrice = 0;
  //* Max Invoice Number:
  int maxInvoiceNumber = 0;
  //* Check Buttons Hover State
  bool isHover = false;
  List<bool> hoverStates = List.filled(16, false);
  //* Sqlflite Define:
  SqlDb sqlDb = SqlDb();
  CashierClass cashierClass = CashierClass();
  //*
  int cartItemsCount = 0;
  //*
  bool checkValue = false;
  //* Users list:
  List<CustomSelectedListUsers> dropDownListUsers = [];
  List<UsersModel> listDataSearchUsers = [];
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
  GlobalKey<FormState> formState = GlobalKey<FormState>();

}
