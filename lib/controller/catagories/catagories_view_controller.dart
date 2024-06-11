import 'dart:typed_data';
import 'package:cashier_system/core/class/statusrequest.dart';
import 'package:cashier_system/core/constant/routes.dart';
import 'package:cashier_system/core/functions/handing_data_controller.dart';
import 'package:cashier_system/data/model/categories_model.dart';
import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CatagoriesController extends GetxController {
  int stackIndex = 0;
  changeIndex(int index) {
    stackIndex = index;
    update();
  }

  SqlDb sqlDb = SqlDb();
  List<CategoriesModel> data = [];
  List<CategoriesModel> listdataSearch = [];
  late StatusRequest statusRequest;
  bool isSearch = false;
  TextEditingController? search;
  Uint8List? imageBytes;
  checkSearch(val) {
    if (val == "") {
      statusRequest = StatusRequest.none;
      isSearch = false;
    }
    update();
  }

  // Future<void> _loadCategoryImage(int? catId) async {
  //   Uint8List? bytes = await SqlDb().getCategoryImage(catId!);
  //   imageBytes = bytes;
  //   update();
  // }

  onSearchItems() {
    isSearch = true;
    searchCategories();
    update();
  }

  //!Get data SQL:
  getCategoriesData() async {
    statusRequest = StatusRequest.loading;
    var response = await sqlDb.getAllData("tbl_categories");
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      // Start backend
      if (response['status'] == "success") {
        data.clear();
        List dataList = response['data'];
        data.addAll(dataList.map((e) => CategoriesModel.fromJson(e)));
      } else {
        statusRequest = StatusRequest.failure;
      }
    }
    update();
  }

  //? Search Categories
  searchCategories() async {
    statusRequest = StatusRequest.loading;
    var response = await sqlDb.getAllData("tbl_categories",
        where: "categories_name LIKE '%${search!.text}%'");
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      if (response['status'] == "success") {
        listdataSearch.clear();
        List responsedata = response['data'];
        listdataSearch
            .addAll(responsedata.map((e) => CategoriesModel.fromJson(e)));
      } else {
        statusRequest = StatusRequest.failure;
      }
    }
    update();
  }

  //!Get data SQL:
  deleteCategoriesData(String id) async {
    statusRequest = StatusRequest.loading;
    var response =
        await sqlDb.deleteData("tbl_categories", "categories_id = $id");
    statusRequest = handlingData(response);
    if (response > 0) {
      getCategoriesData();
    }
    if (StatusRequest.success == statusRequest) {
      // Start backend
      // if (response['status'] == "success") {
      //   data.clear();
      //   List dataList = response['data'];
      //   data.addAll(dataList.map((e) => CategoriesModel.fromJson(e)));
      // } else {
      //   statusRequest = StatusRequest.failure;
      // }
    }
    update();
  }

  goUpdate(CategoriesModel catagoriesModel) {
    Get.toNamed(AppRoute.categoriesUpdateScreen,
        arguments: {'categoriesModel': catagoriesModel});
  }

  @override
  void onInit() async {
    getCategoriesData();
    search = TextEditingController();
  //  _loadCategoryImage(0);
    super.onInit();
  }

  @override
  void dispose() {
    search!.dispose();
    super.dispose();
  }
}
