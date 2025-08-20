import 'dart:io';
import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/controller/items/items_definition_controller.dart';
import 'package:cashier_system/controller/printer/invoice_controller.dart';
import 'package:cashier_system/controller/printer/sunmi_printer_controller.dart';
import 'package:cashier_system/core/class/statusrequest.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/dialogs/custom_snack_bar.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/core/dialogs/snackbar_helper.dart';
import 'package:cashier_system/core/functions/handing_data_controller.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/data/model/categories_model.dart';
import 'package:cashier_system/data/model/items_model.dart';
import 'package:cashier_system/data/model/purchaes_model.dart';
import 'package:cashier_system/data/model/units_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class ItemsViewController extends ItemsDefinitionController {
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

  void changeSortField(String field) {
    selectedSortField = field;
    getItemsData(isInitialSearch: true);
    update();
  }

  void toggleSortOrder() {
    sortAscending = !sortAscending;
    getItemsData(isInitialSearch: true);
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

  clearFileds() {
    itemsNameController.clear();
    itemsDescControllerController.clear();
    itemsCountController.clear();
    itemsBarcodeController.clear();
    itemsSellingPriceController.clear();
    itemsCodeController.clear();
    itemsProductionDateController.clear();
    itemsExpiryDateController.clear();
    selectedCat = null;
    selectedCatId = null;
    //  file = null;
  }

  clearSearchFileds() {
    itemsSearchNameController.clear();
    itemsSearchCountController.clear();
    itemsSearchBarcodeController.clear();
    itemsSearchSellingPriceController.clear();
    itemsSearchCodeController.clear();
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

//! Get Items Data:
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
      String? itemsBarcode = itemsSearchBarcodeController.text.trim().isNotEmpty
          ? itemsSearchBarcodeController.text.trim()
          : null;
      String? itemsName = itemsSearchNameController.text.trim().isNotEmpty
          ? itemsSearchNameController.text.trim()
          : null;
      String? itemsCount = itemsSearchCountController.text.trim().isNotEmpty
          ? itemsSearchCountController.text.trim()
          : null;
      String? itemsSelling =
          itemsSearchSellingPriceController.text.trim().isNotEmpty
              ? itemsSearchSellingPriceController.text.trim()
              : null;
      int? itemsCat = selectedSearchCategoriesId;
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
      String? itemsCode = itemsSearchCodeController.text.trim().isNotEmpty
          ? itemsSearchCodeController.text.trim()
          : null;

      final response = await itemsClass.searchItemsData(
        itemsNo: itemsCode,
        itemsBarcode: itemsBarcode,
        itemsName: itemsName,
        itemsCount: itemsCount,
        itemsSelling: itemsSelling,
        itemsCategories: itemsCat,
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
          data.addAll(
            responsedata.map((e) {
              final mapData = Map<String, dynamic>.from(e);
              return ItemsModel.fromMap(mapData);
            }),
          );
          itemsOffset += itemsPerPage;
        } else {
          if (isInitialSearch || data.isEmpty) {
            statusRequest = StatusRequest.noData;
          }
          showSuccessSnackBar(TextRoutes.allDataLoaded);
        }

        if (calculateData) {
          totalItemsPrice = (response['total_selling_price'] ?? 0.0).toDouble();
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
    if (ids.isEmpty) {
      showErrorSnackBar(TextRoutes.selectOneRowAtLeast);
      return;
    }
    try {
      Map<String, String> response = await itemsClass.deleteItems(ids);

      bool allDeleted =
          response.values.every((v) => v == 'Deleted successfully');

      if (allDeleted) {
        showSuccessSnackBar(TextRoutes.dataDeletedSuccess);
        selectedItems.clear();
        getItemsData(isInitialSearch: true, calculateData: true);
        Get.back();
      } else {
        response.forEach((key, value) {
          if (value != TextRoutes.success) {
            showErrorSnackBar("${TextRoutes.item.tr} $key: $value");
          }
        });
      }
    } catch (e) {
      showErrorDialog(e.toString(), message: TextRoutes.failDeleteData);
    } finally {
      update();
    }
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
  Future<void> updateItemDetails(
      int itemsId, String barcode, double sellingPrice, String unitName) async {
    try {
      Map<String, dynamic> data = {
        "item_selling_price": sellingPrice,
        "item_barcode": barcode,
        "selected_unit": unitName,
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

        result["unit"]!.add(item.baseUnitName.toString());
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

//!----------------------------------------
  Future<void> addItems() async {
    try {
      if (!formState.currentState!.validate()) {
        showErrorSnackBar(TextRoutes.formValidationFailed);
        return;
      }

      update();
      if (itemsBarcodeController.text.isNotEmpty) {
        if (await itemBarcodeExist(itemsBarcodeController.text)) {
          showErrorSnackBar("This barcode already exists.");
          return;
        }
      }

      final itemData = {
        'item_name': itemsNameController.text,
        'item_barcode': itemsBarcodeController.text,
        'item_selling_price':
            double.tryParse(itemsSellingPriceController.text) ?? 0.0,
        'item_buying_price': double.tryParse(itemsBuyingPriceController.text) ??
            double.tryParse(itemsCostPriceController.text) ??
            0.0,
        'item_wholesale_price':
            double.tryParse(itemsWholeSalePriceController.text) ?? 0.0,
        'item_cost_price': double.tryParse(itemsCostPriceController.text) ??
            double.tryParse(itemsBuyingPriceController.text) ??
            0.0,
        'item_count': double.tryParse(itemsCountController.text) ?? 0.0,
        'item_description': itemsDescControllerController.text,
        'item_category_id': selectedCatId,
        'item_image': file?.path != null ? basename(file!.path) : "",
        'item_create_date': currentTime,
        'item_production_date': itemsProductionDateController.text,
        'item_expiry_date': itemsExpiryDateController.text,
        'unit_id': selectedUnitId,
        "selected_unit": selectedUnitData!.unitBaseName,
      };
      if (itemsBarcodeController.text.isNotEmpty &&
          await itemBarcodeExist(itemsBarcodeController.text)) {
        showErrorSnackBar("barcode already exist");
        return;
      }
      final response = await sqlDb.insertData("tbl_items", itemData);
      if (response > 0) {
        final int newItemId = response;

        double initialQuantity =
            double.tryParse(itemsCountController.text) ?? 0;

        if (initialQuantity > 0) {
          final movementData = {
            'item_id': newItemId,
            'movement_type': 'purchase',
            'quantity': initialQuantity,
            'cost_price': double.tryParse(itemsCostPriceController.text) ?? 0,
            'movement_date': currentTime,
            'note': 'Opening stock',
            'account_id': null,
            'sale_price':
                double.tryParse(itemsSellingPriceController.text) ?? 0,
          };

          await sqlDb.insertData("tbl_inventory_movements", movementData);
        }
        uploadFile();
        //? For Main UNit
        Map<String, dynamic> mainUnitData = {
          "item_id": response,
          "unit_id": selectedUnitId,
          "item_price":
              double.tryParse(itemsSellingPriceController.text) ?? 0.0,
          "item_barcode": itemsBarcodeController.text,
          'factor': selectedUnitFactor,
          "created_at": currentTime,
        };
        await sqlDb.insertData('tbl_units_price', mainUnitData);
        //? For Alt Units:
        for (var product in rows) {
          Map<String, dynamic> unitData = {
            "item_id": response,
            "unit_id": product.unitId,
            "item_price": product.sellingPrice,
            "item_barcode": product.barcode,
            'factor': product.conversionFactorController.text,
            "created_at": currentTime,
          };
          await sqlDb.insertData('tbl_units_price', unitData);
        }
        Get.back();
        getItemsData(isInitialSearch: true, calculateData: true);
        showSuccessSnackBar(TextRoutes.dataAddedSuccess);
      } else {
        showErrorSnackBar(TextRoutes.failAddData);
      }
    } catch (e) {
      showErrorDialog(e.toString(), message: TextRoutes.failAddData);
    } finally {
      update();
    }
  }

//!----------------------------------------
//? Update Items:
  void getAltUnits(List<AltUnit> altUnits, List<UnitModel> unitsList) {
    rows.clear();

    for (var altUnit in altUnits) {
      final unitModel = unitsList.firstWhere(
        (unit) => unit.unitId == altUnit.unitId,
        orElse: () => UnitModel(unitId: 0, unitBaseName: ''),
      );
      rows.add(
        ProductRow(
          barcode: altUnit.barcode,
          conversionFactor: altUnit.unitFactor,
          sellingPrice: altUnit.price,
          conversionUnit: unitModel,
          unitId: altUnit.unitId,
        ),
      );
    }
  }

  passDataForUpdate(ItemsModel? itemsModel) {
    selectedItemsForUpdateId = itemsModel?.itemsId;
    itemsNameController.text = itemsModel?.itemsName ?? '';
    itemsBarcodeController.text = itemsModel?.itemsBarcode ?? '';
    currentBarcode = itemsModel?.itemsBarcode ?? '';
    itemsSellingPriceController.text =
        itemsModel?.itemsSellingPrice.toString() ?? '';
    itemsBuyingPriceController.text =
        itemsModel?.itemsBuyingPrice.toString() ?? '';
    itemsWholeSalePriceController.text =
        itemsModel?.itemsWholesalePrice.toString() ?? '';
    itemsCostPriceController.text = itemsModel?.itemsCostPrice.toString() ?? '';
    selectedCatId = itemsModel!.itemsCategoryId;
    getAltUnits(itemsModel.altUnits, unitsDropDownData);
    itemsDescControllerController.text = itemsModel.itemsDescription;
    itemsCountController.text = itemsModel.itemsCount.toString();
    itemsUnitBaseController.text = itemsModel.baseUnitName.toString();
    selectedUnitId = itemsModel.mainUnitId;
    selectedCat = dropDownListCategoriesData.firstWhere(
      (cat) => cat.categoriesId == selectedCatId,
      orElse: () => CategoriesModel(),
    );
    selectedUnitData = unitsDropDownData.firstWhere(
      (unit) => unit.unitId == selectedUnitId,
      orElse: () => UnitModel(),
    );
    if (itemsModel.itemsImage.isNotEmpty) {
      file = File(
          "${myServices.sharedPreferences.getString('image_path')!}/${itemsModel.itemsImage}");
    }
  }

  //! Update Items:
  Future<void> updateItems(int itemsId) async {
    try {
      if (!formState.currentState!.validate()) {
        showErrorSnackBar(TextRoutes.formValidationFailed);
        return;
      }
      final itemData = {
        'item_name': itemsNameController.text,
        'item_barcode': itemsBarcodeController.text,
        'item_selling_price':
            double.tryParse(itemsSellingPriceController.text) ?? 0.0,
        'item_buying_price': double.tryParse(itemsBuyingPriceController.text) ??
            double.tryParse(itemsCostPriceController.text) ??
            0.0,
        'item_wholesale_price':
            double.tryParse(itemsWholeSalePriceController.text) ?? 0.0,
        'item_cost_price': double.tryParse(itemsCostPriceController.text) ??
            double.tryParse(itemsBuyingPriceController.text) ??
            0.0,
        'item_count': double.tryParse(itemsCountController.text) ?? 0.0,
        'item_description': itemsDescControllerController.text,
        'item_category_id': selectedCatId,
        'item_image': file?.path != null ? basename(file!.path) : "",
        // 'item_create_date': currentTime,
        'item_production_date': itemsProductionDateController.text,
        'item_expiry_date': itemsExpiryDateController.text,
        'unit_id': selectedUnitId,
        "selected_unit": selectedUnitData!.unitBaseName,
      };
      if (currentBarcode != itemsBarcodeController.text) {
        if (itemsBarcodeController.text.isNotEmpty) {
          if (await itemBarcodeExist(itemsBarcodeController.text)) {
            showErrorSnackBar("This barcode already exists.");
            return;
          }
        }
      }
      var response =
          await sqlDb.updateData("tbl_items", itemData, "item_id = $itemsId");

      if (response > 0) {
        final mainUnitRow = ProductRow(
          unitId: selectedUnitId,
          sellingPrice:
              double.tryParse(itemsSellingPriceController.text) ?? 0.0,
          barcode: itemsBarcodeController.text,
          conversionFactor: selectedUnitFactor,
          conversionUnit: unitsDropDownData.firstWhere(
            (u) => u.unitId == selectedUnitId,
            orElse: () => UnitModel(unitId: selectedUnitId, unitBaseName: ''),
          ),
        );
        final allUnitsRows = [mainUnitRow, ...rows];
        final oldUnits = await sqlDb.getData(
            "SELECT unit_id FROM tbl_units_price WHERE item_id = $itemsId");
        final oldUnitIds = oldUnits.map((e) => e['unit_id'] as int).toList();
        final newUnitIds = allUnitsRows.map((e) => e.unitId).toList();

// 4️⃣ UPDATE / INSERT
        for (var row in allUnitsRows) {
          Map<String, dynamic> unitData = {
            "item_id": itemsId,
            "unit_id": row.unitId,
            "item_price": row.sellingPrice,
            "item_barcode": row.barcode,
            "factor": row.conversionFactorController.text,
            "created_at": currentTime,
          };

          if (oldUnitIds.contains(row.unitId)) {
            await sqlDb.updateData(
              'tbl_units_price',
              unitData,
              "item_id = $itemsId AND unit_id = ${row.unitId}",
            );
          } else {
            await sqlDb.insertData('tbl_units_price', unitData);
          }
        }

        for (var oldId in oldUnitIds) {
          if (!newUnitIds.contains(oldId)) {
            await sqlDb.deleteData(
              'tbl_units_price',
              "item_id = $itemsId AND unit_id = $oldId",
            );
          }
        }
        Get.back();
        showSuccessSnackBar(TextRoutes.dataUpdatedSuccess);
        if (file?.path != null) {
          uploadFile();
        }
        getItemsData(isInitialSearch: true);
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Failed to add items.");
    } finally {
      update();
    }
  }

  @override
  void onClose() {
    data.clear();
    super.onClose();
  }

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
