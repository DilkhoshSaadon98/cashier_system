import 'package:cashier_system/controller/items/items_view_controller.dart';
import 'package:cashier_system/core/class/statusrequest.dart';
import 'package:cashier_system/core/constant/routes.dart';
import 'package:cashier_system/core/functions/handing_data_controller.dart';
import 'package:cashier_system/data/model/categories_model.dart';
import 'package:cashier_system/data/model/items_model.dart';
import 'package:cashier_system/data/model/types_model.dart';
import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemsUpdateController extends GetxController {
  ItemsModel? itemsModel;
  String screenRoute = "";
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
  TextEditingController? dropDownName;
  TextEditingController? dropDownID;
  TextEditingController? catName;
  TextEditingController? catID;
  TextEditingController? typeName;
  TextEditingController? typeID;
  SqlDb sqlDb = SqlDb();
  List<SelectedListItem> dropDownList = [];
  List<SelectedListItem> dropDownListTypes = [];
  Map<String, IconData> addItemList = {
    "Items Name": Icons.insert_comment_sharp,
    "Items Explain": Icons.description_outlined,
    "Items Count": Icons.numbers_outlined,
    "Selling Price": Icons.attach_money_sharp,
    "Buying Price": Icons.attach_money_sharp,
    "Wholesale Price": Icons.attach_money_sharp,
    "Cost Price": Icons.attach_money_sharp,
    "Barcode": Icons.barcode_reader,
  };
  StatusRequest? statusRequest = StatusRequest.none;

  List<TextEditingController?>? controllerList;
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

  //! Update Items :
  updateItems() async {
    if (formState.currentState!.validate()) {
      statusRequest = StatusRequest.loading;
      update();
      Map<String, dynamic> data = {
        'items_id': itemsModel!.itemsId.toString(),
        'items_name': itemsName!.text,
        'items_desc': itemsDesc!.text,
        'items_count': itemsCount!.text,
        'items_selling': itemsSellingPrice!.text,
        'items_buingprice': itemsBuyingPrice!.text,
        'items_wholesaleprice': itemsWholeSalePrice!.text,
        'items_costprice': itemsCostPrice!.text,
        'items_type': typeID!.text,
        'items_barcode': itemsBarcode!.text,
        'items_cat': catID!.text,
      };
      var response = await sqlDb.updateData(
          "tbl_items", data, "items_id = ${itemsModel!.itemsId}");
      statusRequest = handlingData(response);

      if (StatusRequest.success == statusRequest) {
        if (response > 0) {
          Get.offAllNamed(screenRoute);
          ItemsViewController temsViewController = Get.put(ItemsViewController());
          temsViewController.getItems();
        } else {
          statusRequest = StatusRequest.failure;
        }
      }
      update();
    }
  }

  initilaizeController() {
    itemsName = TextEditingController();
    itemsDesc = TextEditingController();
    itemsCount = TextEditingController();
    itemsSellingPrice = TextEditingController();
    itemsBuyingPrice = TextEditingController();
    itemsCostPrice = TextEditingController();
    itemsWholeSalePrice = TextEditingController();
    itemsType = TextEditingController();
    itemsBarcode = TextEditingController();
    dropDownName = TextEditingController();
    dropDownID = TextEditingController();
    catID = TextEditingController();
    catName = TextEditingController();
    typeName = TextEditingController();
    typeID = TextEditingController();
  }

  @override
  void onInit() {
    initilaizeController();
    itemsModel = Get.arguments['itemsModel'];
    screenRoute = Get.arguments['screen_route'];
    itemsName!.text = itemsModel!.itemsName!;
    itemsDesc!.text = itemsModel!.itemsDesc!;
    itemsCount!.text = itemsModel!.itemsCount!.toString();
    itemsSellingPrice!.text = itemsModel!.itemsSellingprice!.toString();
    itemsBuyingPrice!.text = itemsModel!.itemsBuingprice!.toString();
    itemsWholeSalePrice!.text = itemsModel!.itemsWholesaleprice!.toString();
    itemsCostPrice!.text = itemsModel!.itemsCostprice!.toString();
    typeName!.text = itemsModel!.typeName!.toString();
    typeID!.text = itemsModel!.itemsType!.toString();
    itemsBarcode!.text = itemsModel!.itemsBarcode!;
    catName!.text = itemsModel!.categoriesName!.toString();
    catID!.text = itemsModel!.itemsCat!.toString();
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
}
