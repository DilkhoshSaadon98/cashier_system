// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:cashier_system/core/class/statusrequest.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/screen_routes.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/core/dialogs/snackbar_helper.dart';
import 'package:cashier_system/core/functions/upload_file.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/data/model/categories_model.dart';
import 'package:cashier_system/data/sql/sqldb.dart';

class CatagoriesController extends GetxController {
  //? Keys & Controllers
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController? catagoriesName;
  TextEditingController? catagoriesId;
  TextEditingController? search;

  //? File/Image
  File? file;
  Uint8List? imageBytes;
  String fileName = '';

  //? Data & State
  SqlDb sqlDb = SqlDb();
  List<CategoriesModel> data = [];
  late StatusRequest statusRequest;
  bool isSearch = false;
  int stackIndex = 0;

  //? ===== CRUD Functions =====

  Future<void> addCategories(BuildContext context) async {
    if (formState.currentState!.validate()) {
      Map<String, dynamic> data = {
        "categories_name": catagoriesName!.text,
        'categories_image': file == null ? "" : basename(file!.path),
        'categories_createdate': currentTime,
      };

      int response = await sqlDb.insertData("tbl_categories", data);

      if (response > 0) {
        showSuccessSnackBar(TextRoutes.dataAddedSuccess);
        Navigator.of(context).pop();
        CatagoriesController catagoriesController = Get.find();
        catagoriesController.getCategoriesData();
        Get.toNamed(AppRoute.catagoriesScreen);
      }

      update();
    }
  }

  Future<void> updateCategories(String id, BuildContext context) async {
    if (formState.currentState!.validate()) {
      Map<String, dynamic> data = {
        "categories_name": catagoriesName!.text,
        'categories_image': file == null ? "" : basename(file!.path),
      };

      int response =
          await sqlDb.updateData("tbl_categories", data, "categories_id = $id");

      if (response > 0) {
        showSuccessSnackBar(TextRoutes.dataUpdatedSuccess);
        Navigator.of(context).pop();
        CatagoriesController controller = Get.find();
        controller.getCategoriesData();
      }

      update();
    }
  }

  Future<void> deleteCategoriesData(String id) async {
    try {
      var response =
          await sqlDb.deleteData("tbl_categories", "categories_id = $id");
      if (response > 0) {
        showSuccessSnackBar(TextRoutes.dataDeletedSuccess);
        getCategoriesData();
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error during removing data");
    } finally {
      update();
    }
  }



  // ===== File Handling =====

  Future<void> choseFile() async {
    file = await fileUploadGallery();
    imageBytes = await getImageBytesFromFile(file!);
    update();
  }

  void removeFile() {
    file = null;
    update();
  }

  Future<void> uploadFile() async {
    if (file == null) return;

    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String folderName = "MR-ROBOt file";
    Directory newDirectory =
        Directory('${appDocumentsDirectory.path}/$folderName');

    if (!await newDirectory.exists()) {
      await newDirectory.create(recursive: true);
    }

    if (myServices.sharedPreferences.getString("image_path") == null) {
      myServices.sharedPreferences.setString("image_path", newDirectory.path);
    }

    fileName = basename(file!.path);
    String newFilePath = '${newDirectory.path}/$fileName';
    file = await file!.copy(newFilePath);

    update();
  }

  Future<Uint8List> getImageBytesFromFile(File file) async {
    return await file.readAsBytes();
  }

  // ===== Data Handling =====

  Future<void> getCategoriesData() async {
    try {
      var response = await sqlDb.getAllData("categories_view");
      if (response['status'] == "success") {
        data.clear();
        List dataList = response['data'];
        data.addAll(dataList.map((e) => CategoriesModel.fromJson(e)));
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error during fetching data");
    } finally {
      update();
    }
  }

  Future<void> searchCategories() async {
    var response = await sqlDb.getAllData(
      "tbl_categories",
      where: "categories_name LIKE '%${search!.text}%'",
    );

    if (response['status'] == "success") {
      data.clear();
      List responsedata = response['data'];
      data.addAll(responsedata.map((e) => CategoriesModel.fromJson(e)));
    }

    update();
  }

  // ===== UI State =====

  void changeIndex(int index) {
    stackIndex = index;
    update();
  }

  void checkSearch(String val) {
    if (val.isEmpty) {
      statusRequest = StatusRequest.none;
      isSearch = false;
    }
    update();
  }

  void onSearchItems() {
    isSearch = true;
    searchCategories();
    update();
  }

  // ===== Lifecycle =====

  @override
  void onInit() {
    getCategoriesData();
    catagoriesName = TextEditingController();
    catagoriesId = TextEditingController();
    search = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    catagoriesName!.dispose();
    catagoriesId!.dispose();
    search!.dispose();
    super.dispose();
  }
}
