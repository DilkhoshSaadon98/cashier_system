import 'dart:io';
import 'package:cashier_system/controller/items/items_view_controller.dart';
import 'package:cashier_system/core/class/statusrequest.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/routes.dart';
import 'package:cashier_system/core/functions/handing_data_controller.dart';
import 'package:cashier_system/core/functions/upload_file.dart';
import 'package:cashier_system/data/model/categories_model.dart';
import 'package:cashier_system/data/model/types_model.dart';
import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddItemsViewController extends GetxController {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController? itemsName;
  TextEditingController? itemsDesc;
  TextEditingController? itemsCount;
  TextEditingController? itemsSellingPrice;
  TextEditingController? itemsBuyingPrice;
  TextEditingController? itemsWholeSalePrice;
  TextEditingController? itemsCostPrice;
  TextEditingController? itemsType;
  TextEditingController? itemsBarcode;
  TextEditingController? dropDownNameCategories;
  TextEditingController? dropDownIDCategories;
  TextEditingController? catName;
  TextEditingController? catID;
  TextEditingController? typeName;
  TextEditingController? typeID;
  String? catId;
  List<SelectedListItem> dropDownList = [];
  List<SelectedListItem> dropDownListTypes = [];
  Map<String, IconData> addItemList = {
    "Items Name": Icons.edit_document,
    "Items Explain": Icons.description_outlined,
    "Items Count": Icons.numbers_outlined,
    "Selling Price": Icons.attach_money_sharp,
    "Buying Price": Icons.attach_money_sharp,
    "Wholesale Price": Icons.attach_money_sharp,
    "Cost Price": Icons.attach_money_sharp,
    "Barcode": Icons.barcode_reader,
  };
  StatusRequest? statusRequest = StatusRequest.none;
  SqlDb sqlDb = SqlDb();
  File? file;
  choseFile() async {
    file = await fileUploadGallery();
    update();
  }

  //? Get Categories:
  getCategories() async {
    List<CategoriesModel> data = [];
    statusRequest = StatusRequest.loading;
    var response = await sqlDb.getAllData("tbl_categories");
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      // Start backend
      if (response['status'] == "success") {
        data.clear();
        dropDownList.clear();
        List dataList = response['data'];
        data.addAll(dataList.map((e) => CategoriesModel.fromJson(e)));
        for (int i = 0; i < data.length; i++) {
          dropDownList.add(SelectedListItem(
              name: data[i].categoriesName!,
              value: data[i].categoriesId!.toString()));
        }
      } else {
        statusRequest = StatusRequest.failure;
      }
    }
    update();
  }

  //? Get Types:
  getTypes() async {
    List<TypesModel> data = [];
    var response = await sqlDb.getAllData("tbl_types");
    if (response['status'] == "success") {
      data.clear();
      dropDownListTypes.clear();
      List dataList = response['data'];
      data.addAll(dataList.map((e) => TypesModel.fromJson(e)));
      for (int i = 0; i < data.length; i++) {
        dropDownListTypes.add(SelectedListItem(
            name: data[i].typesName!, value: data[i].typesId!.toString()));
      }
    }
    update();
  }

  addItems() async {
    if (formState.currentState!.validate()) {
      statusRequest = StatusRequest.loading;
      update();
      Map<String, dynamic> data = {
        'items_name': itemsName!.text,
        'items_desc': itemsDesc!.text,
        'items_count': itemsCount!.text,
        'items_selling': itemsSellingPrice!.text,
        'items_buingprice': itemsBuyingPrice!.text,
        'items_wholesaleprice': itemsWholeSalePrice!.text,
        'items_costprice': itemsCostPrice!.text,
        'items_barcode': itemsBarcode!.text,
        'items_type': catName!.text,
        'items_cat': catID!.text,
        'items_createdate': currentTime,
      };
      var response = await sqlDb.insertData("tbl_items", data);
      statusRequest = handlingData(response);

      if (StatusRequest.success == statusRequest) {
        if (response > 0) {
          Get.offAllNamed(AppRoute.itemsScreen);
          ItemsViewController temsViewController = Get.find();
          temsViewController.getItems();
        } else {
          statusRequest = StatusRequest.failure;
        }
        // End
      }
      update();
    }
  }

  List<TextEditingController?>? controllerList;
  @override
  void onInit() {
    itemsName = TextEditingController();
    itemsDesc = TextEditingController();
    itemsCount = TextEditingController();
    itemsSellingPrice = TextEditingController();
    itemsBuyingPrice = TextEditingController();
    itemsCostPrice = TextEditingController();
    itemsWholeSalePrice = TextEditingController();
    itemsType = TextEditingController();
    itemsBarcode = TextEditingController();
    dropDownNameCategories = TextEditingController();
    dropDownIDCategories = TextEditingController();
    catID = TextEditingController();
    catName = TextEditingController();
    typeName = TextEditingController();
    typeID = TextEditingController();
    controllerList = [
      itemsName,
      itemsDesc,
      itemsCount,
      itemsSellingPrice,
      itemsBuyingPrice,
      itemsWholeSalePrice,
      itemsCostPrice,
      itemsBarcode
    ];
    getCategories();
    getTypes();
    super.onInit();
  }

  @override
  void dispose() {
    itemsName!.dispose();
    itemsDesc!.dispose();
    itemsCount!.dispose();
    itemsSellingPrice!.dispose();
    itemsBuyingPrice!.dispose();
    itemsWholeSalePrice!.dispose();
    itemsCostPrice!.dispose();
    itemsType!.dispose();
    itemsBarcode!.dispose();
    dropDownNameCategories!.dispose();
    dropDownIDCategories!.dispose();
    catID!.dispose();
    catName!.dispose();
    super.dispose();
  }
}
