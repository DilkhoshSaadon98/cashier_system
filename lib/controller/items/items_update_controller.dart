import 'dart:io';
import 'package:cashier_system/controller/items/items_definition_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/screen_routes.dart';
import 'package:cashier_system/core/dialogs/custom_snack_bar.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/core/dialogs/snackbar_helper.dart';
import 'package:cashier_system/data/model/items_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class ItemsUpdateController extends ItemsDefinitionController {
  bool? showBackButton = false;
  ItemsModel? itemsModel;
  String screenRoute = AppRoute.itemsScreen;
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  var selectedType = '';

  Set<int> selectedIndices = {};

  //! Update Items:
  Future<void> updateItems() async {
    try {
      if (formState.currentState!.validate()) {
        final itemData = {
          'item_name': itemsNameController.text,
          'item_barcode': itemsBarcodeController.text,
          'item_selling_price':
              double.tryParse(itemsSellingPriceController.text) ?? 0,
          'item_buying_price':
              double.tryParse(itemsBuyingPriceController.text) ??
                  double.tryParse(itemsCostPriceController.text) ??
                  0,
          'item_wholesale_price':
              double.tryParse(itemsWholeSalePriceController.text) ?? 0,
          'item_cost_price': double.tryParse(itemsCostPriceController.text) ??
              double.tryParse(itemsBuyingPriceController.text) ??
              0,
          'item_base_quantity': itemsBaseQtyController.text,
          'item_alt_quantity': itemsAltQtyController.text,
          'unit_conversion': itemsUnitConversionController.text,
          'unit_name': itemsUnitBaseController.text,
          'alt_unit_name': itemsUnitAltController.text,
          'item_description': itemsDescControllerController.text,
          'item_category_id': int.tryParse(catIdController.text) ?? 0,
          'item_image': file?.path != null ? basename(file!.path) : "",
          'production_date': itemsProductionDateController.text,
          'expiry_date': itemsExpiryDateController.text,
          'item_create_date': currentTime,
          'item_code': itemsBarcodeController.text,
          'item_count': int.tryParse(itemsCountController.text) ?? 0,
        };
        if (currentBarcode != itemsBarcodeController.text) {
          if (itemsBarcodeController.text.isNotEmpty) {
            if (await itemBarcodeExist(itemsBarcodeController.text)) {
              showErrorSnackBar("This barcode already exists.");
              return;
            }
          }
        }

        var response = await sqlDb.updateData(
            "tbl_items", itemData, "item_id = ${itemsModel!.itemsId}");

        if (response > 0) {
          uploadFile();
          Get.offAllNamed(screenRoute);
        }
      } else {
        customSnackBar("Fail", "Form not validate");
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Failed to add items.");
    } finally {
      update();
    }
  }

  @override
  void onInit() {
    _initializeController();

    try {
      _populateItemFields();
      _populateLaptopFields();
    } catch (e) {
      _handleError(e);
    } finally {
      update();
    }

    super.onInit();
  }

  void _initializeController() {
    fromTypeName = TextEditingController();
    fromTypeID = TextEditingController();
    itemsSecondeBarcode = TextEditingController();
  }

  String? currentBarcode;
  void _populateItemFields() {
    final args = Get.arguments;
    itemsModel = args['itemsModel'];
    screenRoute = args['screen_route'];
    showBackButton = args['show_back'];
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
    catNameController.text = itemsModel?.categoriesName ?? '';
    catIdController.text = itemsModel!.itemsCategoryId.toString();

    itemsDescControllerController.text = itemsModel?.itemsDescription ?? '';
    itemsBaseQtyController.text = itemsModel?.itemsBaseQty.toString() ?? '';
    itemsUnitBaseController.text = itemsModel?.baseUnitName.toString() ?? '';
    if (itemsModel?.itemsImage.isNotEmpty ?? false) {
      file = File(
          "${myServices.sharedPreferences.getString('image_path')!}/${itemsModel?.itemsImage}");
    }
  }

  void _populateLaptopFields() {}

  void _handleError(dynamic e) {
    showErrorDialog(e.toString(),
        title: "Error", message: "Failed to initialize controller");
  }
}
