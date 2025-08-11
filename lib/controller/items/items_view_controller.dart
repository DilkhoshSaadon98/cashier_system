import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/controller/items/items_definition_controller.dart';
import 'package:cashier_system/controller/printer/invoice_controller.dart';
import 'package:cashier_system/controller/printer/sunmi_printer_controller.dart';
import 'package:cashier_system/core/class/statusrequest.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/screen_routes.dart';
import 'package:cashier_system/core/dialogs/custom_snack_bar.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/core/dialogs/snackbar_helper.dart';
import 'package:cashier_system/core/functions/handing_data_controller.dart';
import 'package:cashier_system/core/functions/show_popup_menu.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/data/model/items_model.dart';
import 'package:cashier_system/data/model/purchaes_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemsViewController extends ItemsDefinitionController {
  final CustomShowPopupMenu customShowPopupMenu = CustomShowPopupMenu();
  bool layoutDisplay = false;
  void changeLayout() {
    layoutDisplay = !layoutDisplay;
    update();
  }

//? Selecting Table Rows:
  void selectAllRows() {
    if (selectedItems.length == data.length) {
      selectedItems.clear();
    } else {
      selectedItems = data.map((item) => item.itemsId ?? 0).toList();
    }
    update();
  }

  List<Map<String, dynamic>> get sortFields => [
        {
          "title": TextRoutes.itemsName,
          "value": "item_name",
          "icon": Icons.text_fields,
        },
        {
          "title": TextRoutes.itemsQty,
          "value": "item_count",
          "icon": Icons.numbers_outlined,
        },
        {
          "title": TextRoutes.sellingPrice,
          "value": "item_selling_price",
          "icon": Icons.attach_money,
        },
        {
          "title": TextRoutes.createDate,
          "value": "item_create_date",
          "icon": Icons.calendar_today,
        },
        {
          "title": TextRoutes.productionDate,
          "value": "production_date",
          "icon": Icons.date_range,
        },
        {
          "title": TextRoutes.expireDate,
          "value": "expiry_date",
          "icon": Icons.event_busy,
        },
        {
          "title": TextRoutes.barcode,
          "value": "item_barcode",
          "icon": Icons.qr_code,
        },
      ];
  String selectedSortField = "item_name";
  bool sortAscending = true;

  void changeSortField(String field) {
    selectedSortField = field;
    update();
  }

  void toggleSortOrder() {
    sortAscending = !sortAscending;
    getItemsData(isInitialSearch: true);
    update();
  }

  //* Constants
  static const double initialScrollPositions = 0.0;
  ScrollController? scrollControllers;
  final int pageSize = 20;
  bool hasMoreData = true;
  int currentPage = 0;
  int itemsPerPage = 50;
  int itemsOffset = 0;
  bool isLoading = false;
  bool showBackToTopButton = false;
  int stackIndex = 0;
  changeIndex(int index) {
    stackIndex = index;
    update();
  }

  void initScrolls() {
    scrollControllers!.addListener(() {
      bool shouldShow = scrollControllers!.offset > 20;
      if (showBackToTopButton != shouldShow) {
        showBackToTopButton = shouldShow;
        update();
      }
    });
    scrollControllers!.addListener(() {
      if (scrollControllers!.position.pixels >=
          scrollControllers!.position.maxScrollExtent) {
        if (!isLoading) {
          getItemsData();
        }
      }
    });
  }

  //? Update hover state for UI
  void setHoverState(int index, bool isHovered) {
    if (index < hoverStates.length) {
      hoverStates[index] = isHovered;
      update();
    }
  }

  //? Check if an item is selected
  bool isSelected(int itemsId) {
    return selectedItems.contains(itemsId);
  }

  //? Select or deselect an item
  void selectItem(int itemsId, bool? selected) {
    if (selected == true) {
      selectedItems.add(itemsId);
    } else {
      selectedItems.remove(itemsId);
    }
    update();
  }

  onSearchItems() {
    isSearch = true;
    getItemsData(calculateData: true, isInitialSearch: true);
    update();
  }

  clearFileds() {
    itemsNameController.clear();
    catNameController.clear();
    itemsDescControllerController.clear();
    itemsCountController.clear();
    itemsBarcodeController.clear();
    itemsSellingPriceController.clear();
    prodFromController.clear();
    prodToController.clear();
    expFromController.clear();
    expToController.clear();
    createFromController.clear();
    createToController.clear();
    itemsCodeController.clear();
    getItemsData(isInitialSearch: true, calculateData: true);
  }

  void addItemsToCart(List<int> itemsId) {
    CashierController cashierController = Get.put(CashierController());
    String cartNumber =
        myServices.sharedPreferences.getString("cart_number") ?? "1";

    for (int id in itemsId) {
      cashierController.addItemsToCart(id.toString(), cartNumber);
    }

    showSuccessSnackBar(TextRoutes.dataAddedSuccess);
  }

  bool showSnackBar = true;
  Future<void> getItemsData({
    bool isInitialSearch = false,
    bool calculateData = false,
  }) async {
    if (isLoading) return;

    try {
      if (isInitialSearch) {
        statusRequest = StatusRequest.loading;
        update();

        data.clear();
        itemsOffset = 0;
        itemsPerPage = 50;
        showSnackBar = true; // reset snackbar flag on new search
      }

      // Prepare filter parameters with null if empty
      String? itemsBarcode = itemsBarcodeController.text.trim().isNotEmpty
          ? itemsBarcodeController.text.trim()
          : null;
      String? itemsName = itemsNameController.text.trim().isNotEmpty
          ? itemsNameController.text.trim()
          : null;
      String? itemsCount = itemsCountController.text.trim().isNotEmpty
          ? itemsCountController.text.trim()
          : null;
      String? itemsSelling = itemsSellingPriceController.text.trim().isNotEmpty
          ? itemsSellingPriceController.text.trim()
          : null;
      String? itemsCat = catNameController.text.trim().isNotEmpty
          ? catNameController.text.trim()
          : null;
      String? productionFrom = prodFromController.text.trim().isNotEmpty
          ? prodFromController.text.trim()
          : null;
      String? productionTo = prodToController.text.trim().isNotEmpty
          ? prodToController.text.trim()
          : null;
      String? expiryFrom = expFromController.text.trim().isNotEmpty
          ? expFromController.text.trim()
          : null;
      String? expiryTo = expToController.text.trim().isNotEmpty
          ? expToController.text.trim()
          : null;
      String? createFrom = createFromController.text.trim().isNotEmpty
          ? createFromController.text.trim()
          : null;
      String? createTo = createToController.text.trim().isNotEmpty
          ? createToController.text.trim()
          : null;
      String? itemsCode = itemsCodeController.text.trim().isNotEmpty
          ? itemsCodeController.text.trim()
          : null;
      String? itemsDesc = itemsDescControllerController.text.trim().isNotEmpty
          ? itemsDescControllerController.text.trim()
          : null;

      final response = await itemsClass.searchItemsData(
        itemsNo: itemsCode,
        itemsBarcode: itemsBarcode,
        itemsName: itemsName,
        itemsCount: itemsCount,
        itemsSelling: itemsSelling,
        itemsCategories: itemsCat,
        itemsDesc: itemsDesc,
        offset: itemsOffset,
        limit: itemsPerPage,
        productionFrom: productionFrom,
        productionTo: productionTo,
        expiryFrom: expiryFrom,
        expiryTo: expiryTo,
        createFrom: createFrom,
        createTo: createTo,
        sortField: selectedSortField,
        sortOrder: sortAscending ? "ASC" : "DESC",
      );
      statusRequest = handlingData(response);

      if (statusRequest == StatusRequest.success) {
        final List responsedata = response['data'] ?? [];

        if (responsedata.isNotEmpty) {
          data.addAll(responsedata.map((e) => ItemsModel.fromMap(e)));
          itemsOffset += itemsPerPage;
        } else {
          if (isInitialSearch || data.isEmpty) {
            statusRequest = StatusRequest.noData;
          }
          showSuccessSnackBar(TextRoutes.allDataLoaded);
        }

        if (calculateData) {
          totalItemsPrice = response['total_selling_price'] ?? 0.0;
          totalItemsCount = response['total_items'] ?? 0;
        }
      } else {
        showErrorSnackBar(TextRoutes.failDuringFetchData);
        statusRequest = StatusRequest.failure;
      }
    } catch (e) {
      statusRequest = StatusRequest.serverException;
      showErrorDialog(e.toString(), message: TextRoutes.errorFetchingItemsData);
    } finally {
      isLoading = false;
      update();
    }
  }

  //? Delete items from the database
  Future<void> deleteItems(List<int> ids) async {
    try {
      String idList = ids.join(', ');
      int response =
          await sqlDb.deleteData("tbl_items", "item_id IN ($idList)");
      if (response > 0) {
        showSuccessSnackBar(TextRoutes.dataDeletedSuccess);
        selectedItems.clear();
      }
    } catch (e) {
      showErrorDialog(e.toString(), message: TextRoutes.failDeleteData);
    } finally {
      getItemsData(isInitialSearch: true, calculateData: true);
      Get.back();
      update();
    }
  }

  //? Navigate to update items screen
  Future<void> goUpdateItems(
    ItemsModel itemsModel,
  ) async {
    Get.toNamed(AppRoute.itemsUpdateScreen, arguments: {
      'itemsModel': itemsModel,
      "screen_route": AppRoute.itemsViewScreen,
      'show_back': false
    });
  }

  //? Fetch item transactions
  Future<void> getItemTransaction(String itemsId) async {
    try {
      var response = await sqlDb.getAllData("tbl_purchase",
          where: "purchase_items_id = $itemsId");
      purchaesData.clear();
      if (response['status'] == 'success') {
        List responsedata = response['data'] ?? [];
        purchaesData.addAll(responsedata.map((e) => PurchaseModel.fromJson(e)));
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error fetching item transactions");
    }
  }

  //? Update item price
  Future<void> updateItemPrice(
      String itemsId, String buyingPrice, String sellingPrice) async {
    try {
      Map<String, dynamic> data = {
        "item_selling_price": sellingPrice,
        "item_buying_price": buyingPrice,
      };
      var response =
          await sqlDb.updateData("tbl_items", data, "item_id = $itemsId");
      if (response > 0) {
        await getItemsData(isInitialSearch: true);
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error updating item price");
    }
  }

  //? Update item details
  Future<void> updateItemsDetails(String itemsId, String typeId) async {
    try {
      var dataResponse = await sqlDb.getAllData("unitsView",
          where: "unit_item_id = $itemsId AND unit_type_id = $typeId");
      if (dataResponse.isNotEmpty) {
        Map<String, dynamic> data = {
          "item_selling_price": dataResponse['data'][0]['unit_price_amount'],
          "item_type": dataResponse['data'][0]['type_name'],
          "item_barcode": dataResponse['data'][0]['unit_price_barcode'],
        };
        var response =
            await sqlDb.updateData("tbl_items", data, "item_id = $itemsId");
        if (response > 0) {
          await getItemsData(isInitialSearch: true);
        }
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error updating item details");
    }
  }

  String selectedPrinter =
      myServices.sharedPreferences.getString("selected_printer") ??
          "A4 Printer";
  printData() async {
    InvoiceController invoiceController = Get.put(InvoiceController());
    List<ItemsModel> selectedItems =
        data.where((item) => isSelected(item.itemsId!)).toList();
    if (selectedItems.isNotEmpty) {
      invoiceController.loadPreferences();
      invoiceController.update();
      Map<String, List<String>> result = {
        "#": [],
        "Code": [],
        "Name": [],
        "QTY": [],
        "Price": [],
        "Total Price": [],
        "Type": [],
      };

      for (var i = 0; i < selectedItems.length; i++) {
        var item = selectedItems[i];
        // Prepare the Name field by checking each laptop detail
        String itemName = item.itemsName;

        // Add data to result map
        result["#"]!.add((i + 1).toString());
        result["Code"]!.add(item.itemsId?.toString() ?? '');
        result["Name"]!.add(itemName);
        result["QTY"]!.add(item.itemsBaseQty.toString());
        result["Price"]!.add(item.itemsSellingPrice.toString());
        double totalPrice = (item.itemsBaseQty) * (item.itemsSellingPrice);
        result["Total Price"]!.add(totalPrice.toString());

        result["unit"]!.add(item.unitName.toString());
      }

      // Prepare the invoice data
      Map<String, dynamic> invoiceData = {};

      try {
        if (myServices.sharedPreferences.getString("selected_printer") ==
            null) {
          myServices.sharedPreferences
              .setString('selected_printer', "A4 Printer");
        }
        if (selectedPrinter == "A4 Printer") {
          invoiceController.printInvoice(invoiceData, result, "bills");
        } else if (selectedPrinter == "A5 Printer") {
          invoiceController.printInvoice(invoiceData, result, "bills");
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
    } else {
      customSnackBar("Error", "Please select one row at least".tr);
    }
  }

  @override
  void onClose() {
    data.clear();
    super.onClose();
  }

  bool? showAddToCart = false;
  String cartNumber = "1";
  @override
  void onInit() {
    scrollControllers = ScrollController();
    getItemsData(isInitialSearch: true, calculateData: true);
    initScrolls();

    if (Get.arguments != null && Get.arguments['show_add_cart'] != null) {
      showAddToCart = Get.arguments['show_add_cart'] ?? false;
      cartNumber = Get.arguments['cart_number'] ?? 1;
    }

    super.onInit();
  }
}
