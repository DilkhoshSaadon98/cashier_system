import 'dart:io';
import 'dart:math';
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
import 'package:cashier_system/data/model/unit_conversation_model.dart';
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
  List<CategoriesModel> dropDownListCategoriesData = [];
  List<SelectedListItem> dropDownListCategories = [];
  List<SelectedListItem> dropDownListUnits = [];
  List<String> dropDownListUnitsTemplate = [];
  List<UnitModel> unitsDropDownData = [];
  List<ItemsModel> data = [];
  List<CategoriesModel> categoriesData = [];
  List<ItemDetailsModel> itemDetailsModel = [];
  List<ItemsModel> listDataSearch = [];
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
          "controller": itemsCountController,
          "required": false,
          "valid": "realNumber",
          'read_only': false
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
          'on_tap': () async {
            itemsBarcodeController.text = await generateRandomBarcode();
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

  Future<String> generateRandomBarcode() async {
    final random = Random();
    bool exists = true;
    String randomBarcode = '';

    while (exists) {
      randomBarcode = (10000000 + random.nextInt(90000000)).toString();
      exists = await itemBarcodeExist(randomBarcode);
    }

    update();

    return randomBarcode;
  }

  Future<void> getCategories() async {
    try {
      final response = await sqlDb.getAllData("tbl_categories");
      if (response['status'] == "success") {
        dropDownListCategoriesData.clear();
        List list = response['data'];
        dropDownListCategoriesData
            .addAll(list.map((e) => CategoriesModel.fromJson(e)));
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error fetching categories");
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

  // String? selectedUnit = '';
  UnitModel? selectedUnitData;
  int? selectedUnitId;
  double? selectedUnitFactor;
  CategoriesModel? selectedCat;
  int? selectedCatId;
  UnitConversationModel? selectedUnitConversation;
  int? selectedUnitConversationId;
  Future<void> getUnits() async {
    try {
      final response = await sqlDb.getAllData("tbl_units");
      if (response['status'] == "success") {
        unitsDropDownData.clear();
        List list = response['data'] ?? [];
        if (list.isNotEmpty) {
          unitsDropDownData.addAll(list.map((e) => UnitModel.fromJson(e)));
        }

        // Ensure selectedUnitData is valid
        if (unitsDropDownData.isNotEmpty) {
          selectedUnitData = unitsDropDownData.first;
          selectedUnitId = selectedUnitData!.unitId;
        } else {
          selectedUnitData = null;
          selectedUnitId = null;
        }
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error fetching types");
    } finally {
      update();
    }
  }

  String selectedUnitPriceDetails = "";
  List<UnitModel> unitsPriceDetails = [];
  List<String> unitNames = [];

  Future<void> getUnitsPriceDetails(int id) async {
    try {
      final response = await sqlDb.getAllData("tbl_units");
      if (response['status'] == "success") {
        unitsPriceDetails.clear();

        List listData = response['data'];
        unitsPriceDetails.addAll(
          listData.map((e) => UnitModel.fromJson(e)),
        );

        for (var row in rows) {
          row.conversionUnit =
              unitsPriceDetails.isNotEmpty ? unitsPriceDetails.first : null;
        }
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error fetching types");
    } finally {
      update();
    }
  }

  List<ProductRow> rows = [];
  void addRow() {
    // if (unitsPriceDetails.isEmpty) {
    //   showErrorSnackBar(TextRoutes.noSubUnits);
    //   return;
    // }
    rows.add(ProductRow(
      conversionUnit:
          unitsPriceDetails.isNotEmpty ? unitsPriceDetails.first : null,
      barcode: '',
      sellingPrice: 0.0,
    ));
    update();
  }

  void removeRow(int index) {
    rows.removeAt(index);
    update();
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
    listDataSearch.clear();
    selectedItems.clear();
    dropdownItems.clear();
    hoverStates.clear();
    itemsController.clear();

    super.dispose();
  }
}

class ProductRow {
  int? unitId;
  UnitModel? conversionUnit;
  String? barcode;
  double? sellingPrice;
  double? conversionFactor;

  final TextEditingController barcodeController;
  final TextEditingController sellingPriceController;
  final TextEditingController conversionFactorController;

  ProductRow({
    this.conversionUnit,
    this.unitId,
    this.barcode,
    this.sellingPrice,
    this.conversionFactor,
  })  : barcodeController = TextEditingController(text: barcode ?? ''),
        sellingPriceController =
            TextEditingController(text: sellingPrice?.toString() ?? ''),
        conversionFactorController =
            TextEditingController(text: conversionFactor?.toString() ?? '');

  void dispose() {
    barcodeController.dispose();
    sellingPriceController.dispose();
    conversionFactorController.dispose();
  }

  Map<String, dynamic> toMap() {
    return {
      'conversion_unit': conversionUnit?.unitBaseName ?? '',
      'unit_id': unitId,
      'barcode': barcodeController.text,
      'selling_price': double.tryParse(sellingPriceController.text) ?? 0.0,
      'factor':
          double.tryParse(conversionFactorController.text) ?? 0.0,
    };
  }
}
