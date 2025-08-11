import 'dart:io';
import 'dart:math';
import 'package:barcode/barcode.dart';
import 'package:cashier_system/core/class/statusrequest.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/core/functions/date_picker.dart';
import 'package:cashier_system/core/functions/upload_file.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/data/model/categories_model.dart';
import 'package:cashier_system/data/model/item_details_model.dart';
import 'package:cashier_system/data/model/items_model.dart';
import 'package:cashier_system/data/model/purchaes_model.dart';
import 'package:cashier_system/data/model/units_model.dart';
import 'package:cashier_system/data/source/items_class.dart';
import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:cashier_system/main.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ItemsDefinitionController extends GetxController {
  //*
  double totalItemsPrice = 0.0;
  int totalItemsCount = 0;
  //* States & UI
  bool isHovered = false;
  bool autoPrintBarcode = false;
  bool isHover = false;
  bool isSearch = false;

  //* Scroll
  static const double initialScrollPosition = 0.0;
  double scrollPosition = initialScrollPosition;

  //* Barcode
  String randomBarcode = "00000000";
  String? svg;

  //* File
  File? file;
  String? fileName = "";

  //* Time
  DateTime selectedDate = DateTime.now();

  //* Data
  List<PurchaseModel> purchaesData = [];
  List<SelectedListItem> dropDownListCategories = [];
  List<SelectedListItem> dropDownListUnits = [];
  List<ItemsModel> data = [];
  List<CategoriesModel> categoriesData = [];
  List<UnitModel> unitData = [];
  List<ItemDetailsModel> itemDetailsModel = [];
  List<ItemsModel> listDataSearch = [];
  List<UnitModel> unitsData = [];
  List<int> selectedItems = [];
  List<String> dropdownItems = [];
  List<bool> hoverStates = [];
  List<TextEditingController?> itemsController = [];

  //* DB Access
  final ItemsClass itemsClass = ItemsClass();
  final SqlDb sqlDb = SqlDb();
  StatusRequest statusRequest = StatusRequest.none;

  //* Controllers
  final itemsNameController = TextEditingController();
  final itemsDescControllerController = TextEditingController();
  final itemsCountController = TextEditingController();
  final itemsSellingPriceController = TextEditingController();
  final itemsBuyingPriceController = TextEditingController();
  final itemsCostPriceController = TextEditingController();
  final itemsWholeSalePriceController = TextEditingController();
  final itemsCategoriesControllerId = TextEditingController();
  final itemsCategoriesControllerName = TextEditingController();
  final itemsBarcodeController = TextEditingController();
  final itemsCodeController = TextEditingController();
  final prodFromController = TextEditingController();
  final prodToController = TextEditingController();
  final expFromController = TextEditingController();
  final expToController = TextEditingController();
  final createFromController = TextEditingController();
  final createToController = TextEditingController();
  final itemsUnitBaseController = TextEditingController(text: TextRoutes.pcs);
  final itemsUnitConversionController = TextEditingController(text: "1");
  final itemsProductionDateController = TextEditingController();
  final itemsExpiryDateController = TextEditingController();
  final catNameController = TextEditingController();
  final catIdController = TextEditingController();
  final searchController = TextEditingController();

  TextEditingController? fromTypeName = TextEditingController();
  TextEditingController? fromTypeID = TextEditingController();
  TextEditingController? itemsSecondeBarcode;
  final itemsBaseQtyController = TextEditingController();
  final itemsAltQtyController = TextEditingController();
  final itemsUnitAltController = TextEditingController();
  final itemsTotalQtyController = TextEditingController();
  //? Calculate Total QTY:
  bool isFromBigToSmall = true;

  void calculateTotalQty() {
    double totalQty = (double.tryParse(itemsBaseQtyController.text) ?? 0.0) *
        (double.tryParse(itemsUnitConversionController.text) ?? 0.0);
    itemsAltQtyController.text = totalQty.toString();
    // final baseQty = double.tryParse(itemsBaseQtyController.text.trim()) ?? 0;
    // final altQty = double.tryParse(itemsAltQtyController.text.trim()) ?? 0;
    // final conversion =
    //     double.tryParse(itemsUnitConversionController.text.trim());
    // if (conversion == null || conversion == 0) {
    //   itemsTotalQtyController.text = '0.00';
    //   return;
    // }

    // double totalQty;

    // if (!isFromBigToSmall) {
    //   totalQty = baseQty + (altQty * conversion);
    // } else {
    //   totalQty = baseQty + (altQty / conversion);
    // }

    // itemsTotalQtyController.text = totalQty.toStringAsFixed(2);
  }

  //* UI Maps
  List<Map<String, dynamic>> get itemsInputFieldsData => [
        {
          "title": TextRoutes.itemsName,
          "icon": Icons.text_fields,
          "controller": itemsNameController,
          "required": true,
          "valid": "",
          'read_only': false
        },
        {
          "title": TextRoutes.chooseCategories,
          "icon": Icons.layers,
          "controller": itemsCategoriesControllerName,
          "required": true,
          "valid": "",
          'read_only': true
        },
        {
          "title": TextRoutes.explain,
          "icon": Icons.description,
          "controller": itemsDescControllerController,
          "required": false,
          "valid": "",
          'read_only': false
        },
        {
          "title": TextRoutes.barcode,
          "icon": Icons.qr_code,
          "controller": itemsBarcodeController,
          "required": false,
          "valid": "number",
          'read_only': false,
          'on_tap': () {
            generateRandomBarcode();
          },
          'suffix_icon': Icons.replay
        },
        {
          "title": TextRoutes.buyingPrice,
          "icon": Icons.price_change,
          "controller": itemsBuyingPriceController,
          "required": false,
          "valid": "realNumber",
          'read_only': false
        },
        {
          "title": TextRoutes.wholesalePrice,
          "icon": Icons.price_change,
          "controller": itemsWholeSalePriceController,
          "required": false,
          "valid": "realNumber",
          'read_only': false
        },
        {
          "title": TextRoutes.costPrice,
          "icon": Icons.price_change,
          "controller": itemsCostPriceController,
          "required": false,
          "valid": "realNumber",
          'read_only': false
        },
        {
          "title": TextRoutes.sellingPrice,
          "icon": Icons.price_change,
          "controller": itemsSellingPriceController,
          "required": false,
          "valid": "realNumber",
          'read_only': false
        },
        {
          "title": TextRoutes.baseUnit,
          "icon": Icons.ac_unit,
          "controller": itemsUnitBaseController,
          "required": false,
          "valid": "",
          'read_only': true
        },
        {
          "title": TextRoutes.baseUnitQuantity,
          "icon": Icons.calculate,
          "controller": itemsBaseQtyController,
          "required": false,
          "valid": "realNumber",
          'read_only': false
        },
        {
          "title": TextRoutes.productionDate,
          "icon": Icons.date_range,
          "controller": itemsProductionDateController,
          "required": false,
          "valid": "",
          'read_only': true,
          'on_tap': () {
            selectDate(
                navigatorKey.currentContext!, itemsProductionDateController);
          },
          'suffix_icon': Icons.date_range
        },
        {
          "title": TextRoutes.expireDate,
          "icon": Icons.event_busy,
          "controller": itemsExpiryDateController,
          "required": false,
          "valid": "",
          'read_only': true,
          'on_tap': () {
            selectDate(navigatorKey.currentContext!, itemsExpiryDateController);
          },
          'suffix_icon': Icons.date_range
        },
      ];
  List<Map<String, dynamic>> get searchFields => [
        {
          "title": TextRoutes.chooseCategories,
          "icon": Icons.layers,
          "controller": catNameController,
          "valid": "",
          'read_only': true
        },
        {
          "title": TextRoutes.itemsName,
          "icon": Icons.text_fields,
          "controller": itemsNameController,
          "valid": "",
          'read_only': false
        },
        {
          "title": TextRoutes.code,
          "icon": FontAwesomeIcons.code,
          "controller": itemsCodeController,
          "valid": "number",
          'read_only': false
        },
        {
          "title": TextRoutes.itemsQty,
          "icon": Icons.numbers_outlined,
          "controller": itemsCountController,
          "valid": "number",
          'read_only': false
        },
        {
          "title": TextRoutes.sellingPrice,
          "icon": Icons.price_change,
          "controller": itemsSellingPriceController,
          "valid": "realNumber",
          'read_only': false
        },
        {
          "title": TextRoutes.barcode,
          "icon": Icons.qr_code,
          "controller": itemsBarcodeController,
          "valid": "number",
          'read_only': false,
        },
        {
          "title": TextRoutes.productionDate,
          "icon": Icons.date_range,
          "controller": prodFromController,
          "valid": "",
          "read_only": true,
          'suffix_icon': Icons.date_range,
          "on_tap": () =>
              selectDate(navigatorKey.currentContext!, prodFromController),
        },
        {
          "title": "Production To",
          "icon": Icons.date_range,
          "controller": prodToController,
          "valid": "",
          "read_only": true,
          'suffix_icon': Icons.date_range,
          "on_tap": () =>
              selectDate(navigatorKey.currentContext!, prodToController),
        },
        {
          "title": "Expiry From",
          "icon": Icons.date_range,
          "controller": expFromController,
          "valid": "",
          "read_only": true,
          'suffix_icon': Icons.date_range,
          "on_tap": () =>
              selectDate(navigatorKey.currentContext!, expFromController),
        },
        {
          "title": "Expiry To",
          "icon": Icons.date_range,
          "controller": expToController,
          "valid": "",
          "read_only": true,
          'suffix_icon': Icons.date_range,
          "on_tap": () =>
              selectDate(navigatorKey.currentContext!, expToController),
        },
        {
          "title": TextRoutes.creationDateFrom,
          "icon": Icons.event_busy,
          "controller": createFromController,
          "valid": "",
          'read_only': true,
          'on_tap': () {
            selectDate(navigatorKey.currentContext!, createFromController);
          },
          'suffix_icon': Icons.date_range
        },
        {
          "title": TextRoutes.creationDateTo,
          "icon": Icons.event_busy,
          "controller": createToController,
          "valid": "",
          'read_only': true,
          'on_tap': () {
            selectDate(navigatorKey.currentContext!, createToController);
          },
          'suffix_icon': Icons.date_range
        },
      ];
  //* Methods
  changeHover(bool value) {
    isHovered = value;
    update();
  }

  autoPrintBarcodeFunction(bool value) {
    autoPrintBarcode = value;
    update();
  }

  changeState(bool currentState, bool newState) {
    currentState = newState;
    update();
  }

  Future<void> choseFile() async {
    file = await fileUploadGallery();
    update();
  }

  void removeFile() {
    file = null;
    update();
  }

  Future<void> uploadFile() async {
    if (file != null) {
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final folder = Directory('$path/MR-ROBOt file');

      if (!(await folder.exists())) await folder.create(recursive: true);

      myServices.sharedPreferences.setString("image_path", folder.path);

      fileName = basename(file!.path);
      final newFilePath = '${folder.path}/$fileName';
      file = await file!.copy(newFilePath);
      update();
    }
  }

  Future<void> pickImageFromCamera() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      file = File(image.path);
      update();
    }
  }

  Future<bool> itemBarcodeExist(String barcode) async {
    final response = await sqlDb.getAllData(
      "tbl_items",
      where: "item_barcode = '$barcode'",
    );
    return response['status'] == 'success';
  }

  Future<void> generateRandomBarcode() async {
    final random = Random();
    final bc = Barcode.code128();
    bool exists = true;

    while (exists) {
      randomBarcode = (10000000 + random.nextInt(90000000)).toString();
      exists = await itemBarcodeExist(randomBarcode);
    }
    svg = bc.toSvg(randomBarcode, width: 200, height: 100);
    itemsBarcodeController.text = randomBarcode;
    update();
  }

  Future<void> getCategories() async {
    try {
      final response = await sqlDb.getAllData("tbl_categories");
      if (response['status'] == "success") {
        categoriesData.clear();
        dropDownListCategories.clear();
        List list = response['data'];
        categoriesData.addAll(list.map((e) => CategoriesModel.fromJson(e)));
        for (var category in categoriesData) {
          dropDownListCategories.add(
            SelectedListItem(
                name: category.categoriesName!,
                value: category.categoriesId!.toString()),
          );
        }
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error fetching categories");
    } finally {
      update();
    }
  }

  Future<void> getUnits() async {
    try {
      final response = await sqlDb.getAllData("tbl_units");
      if (response['status'] == "success") {
        unitData.clear();
        dropDownListUnits.clear();
        List list = response['data'];
        unitData.addAll(list.map((e) => UnitModel.fromJson(e)));
        for (var unit in unitData) {
          dropDownListUnits.add(SelectedListItem(
              name: unit.unitName, value: unit.convertValue.toString()));
          if (unit.unitName == "Pcs") {
            fromTypeName!.text = unit.unitName;
            fromTypeID!.text = unit.unitId.toString();
          }
        }
      } else {
        showErrorDialog("", title: "Error", message: "Failed to fetch types");
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error fetching types");
    } finally {
      update();
    }
  }

  Future<void> getItemDetailsData(String itemId) async {
    try {
      final response =
          await sqlDb.getAllData("item_details", where: "item_id =$itemId");
      if (response['status'] == "success") {
        itemDetailsModel.clear();
        final list = response['data'];
        itemDetailsModel.addAll(list.map((e) => ItemDetailsModel.fromMap(e)));
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error fetching types");
    } finally {
      update();
    }
  }

  void _loadAdditionalData() {
    getCategories();
    getUnits();
  }

  @override
  void onInit() {
    _loadAdditionalData();
    super.onInit();
  }

  @override
  void dispose() {
    // Dispose controllers
    itemsNameController.dispose();
    itemsDescControllerController.dispose();
    itemsCountController.dispose();
    itemsSellingPriceController.dispose();
    itemsBuyingPriceController.dispose();
    itemsCostPriceController.dispose();
    itemsWholeSalePriceController.dispose();
    itemsCategoriesControllerId.dispose();
    itemsCategoriesControllerName.dispose();
    itemsBarcodeController.dispose();
    catNameController.dispose();
    searchController.dispose();
    fromTypeName?.dispose();
    fromTypeID?.dispose();
    itemsSecondeBarcode?.dispose();

    // Clear data lists
    purchaesData.clear();
    dropDownListCategories.clear();
    dropDownListUnits.clear();
    data.clear();
    categoriesData.clear();
    unitData.clear();
    listDataSearch.clear();
    unitsData.clear();
    selectedItems.clear();
    dropdownItems.clear();
    hoverStates.clear();
    itemsController.clear();

    super.dispose();
  }
}
