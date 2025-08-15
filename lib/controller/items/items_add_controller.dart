import 'package:cashier_system/controller/items/items_definition_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/screen_routes.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/core/dialogs/snackbar_helper.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class AddItemsController extends ItemsDefinitionController {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool autoFill = false;

  //? Auto Fill Items data:
  autoFillItems(bool value) {
    autoFill = value;
    if (autoFill) {
      loadStoredData();
    } else {
      clearAllControllers();
    }
    update();
  }

  final addItemsFormKey = GlobalKey<FormState>();

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
        showSuccessSnackBar(TextRoutes.dataAddedSuccess);
        localStoreData();
        Get.offAndToNamed(AppRoute.itemsScreen);
      } else {
        showErrorSnackBar(TextRoutes.failAddData);
      }
    } catch (e) {
      showErrorDialog(e.toString(), message: TextRoutes.failAddData);
    } finally {
      update();
    }
  }

//? Store last inserted item data:
  void localStoreData() async {
    // Store the data in SharedPreferences after successful insertion
    await myServices.sharedPreferences
        .setString("item_name", itemsNameController.text);
    await myServices.sharedPreferences
        .setString("item_description", itemsDescControllerController.text);
    await myServices.sharedPreferences
        .setInt("item_count", int.tryParse(itemsCountController.text) ?? 0);
    await myServices.sharedPreferences.setDouble("item_selling_price",
        double.tryParse(itemsSellingPriceController.text) ?? 0);
    await myServices.sharedPreferences.setDouble("item_buying_price",
        double.tryParse(itemsBuyingPriceController.text) ?? 0);
    await myServices.sharedPreferences.setDouble("item_wholesale_price",
        double.tryParse(itemsWholeSalePriceController.text) ?? 0);
    await myServices.sharedPreferences
        .setString("item_barcode", itemsBarcodeController.text);
    await myServices.sharedPreferences
        .setString("item_category_id", catIdController.text);
    await myServices.sharedPreferences
        .setString("item_category_name", catNameController.text);
  }

//? load last inserted item data:
  void loadStoredData() async {
    itemsNameController.text =
        myServices.sharedPreferences.getString("item_name") ?? "";
    itemsDescControllerController.text =
        myServices.sharedPreferences.getString("item_description") ?? "";
    itemsCountController.text =
        myServices.sharedPreferences.getInt("item_count")?.toString() ?? "0";
    itemsSellingPriceController.text = myServices.sharedPreferences
            .getDouble("item_selling_price")
            ?.toString() ??
        "0.0";
    itemsBuyingPriceController.text = myServices.sharedPreferences
            .getDouble("item_buying_price")
            ?.toString() ??
        "0.0";
    itemsWholeSalePriceController.text = myServices.sharedPreferences
            .getDouble("item_wholesale_price")
            ?.toString() ??
        "0.0";
    itemsBarcodeController.text =
        myServices.sharedPreferences.getString("item_barcode") ?? "";
    catIdController.text =
        myServices.sharedPreferences.getString("item_category_id") ?? "";
    catNameController.text =
        myServices.sharedPreferences.getString("item_category_name") ?? "";

    update();
  }

  void clearAllControllers() {
    itemsNameController.clear();
    itemsDescControllerController.clear();
    itemsCountController.clear();
    itemsSellingPriceController.clear();
    itemsBuyingPriceController.clear();
    itemsWholeSalePriceController.clear();
    itemsBarcodeController.clear();
    catIdController.clear();
    catNameController.clear();

    update();
  }

  @override
  void onInit() {
    itemsSecondeBarcode = TextEditingController();
    fromTypeName = TextEditingController();
    fromTypeID = TextEditingController();
    getUnits();
    super.onInit();
  }

  @override
  void dispose() {
    itemsNameController.dispose();
    itemsDescControllerController.dispose();
    itemsCountController.dispose();
    itemsSellingPriceController.dispose();
    itemsBuyingPriceController.dispose();
    itemsWholeSalePriceController.dispose();
    itemsCostPriceController.dispose();
    super.dispose();
  }
}
