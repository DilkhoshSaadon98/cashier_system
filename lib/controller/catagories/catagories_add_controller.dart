import 'dart:io';
import 'dart:typed_data';
import 'package:cashier_system/controller/catagories/catagories_view_controller.dart';
import 'package:cashier_system/core/class/statusrequest.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/routes.dart';
import 'package:cashier_system/core/functions/handing_data_controller.dart';
import 'package:cashier_system/core/functions/upload_file.dart';
import 'package:cashier_system/core/shared/custom_snack_bar.dart';
import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCategoriesController extends GetxController {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController? catagoriesName;
  SqlDb sqlDb = SqlDb();
  StatusRequest? statusRequest = StatusRequest.none;
  File? file;
  Uint8List? imageBytes;
  Future<Uint8List> getImageBytesFromFile(File file) async {
    // Read file bytes and return as Uint8List
    return await file.readAsBytes();
  }

  choseFile() async {
    file = await fileUploadGallery();
    imageBytes = await getImageBytesFromFile(file!);
    update();
  }

  addCategories() async {
    if (formState.currentState!.validate()) {
      if (file != null) {
        Get.snackbar('Warning', 'Select Image');
      } else {
        statusRequest = StatusRequest.loading;
        Map<String, dynamic> data = {
          "categories_name": catagoriesName!.text,
          'categories_createdate': currentTime,
        };
        var response = await sqlDb.insertData("tbl_categories", data);

        statusRequest = handlingData(response);
        if (StatusRequest.success == statusRequest) {
          Get.offAllNamed(AppRoute.catagoriesScreen);
          CatagoriesController catagoriesController = Get.find();
          catagoriesController.getCategoriesData();
          customSnackBar("Success", "Categories Added Successfuly", true);
          // End
        }
        update();
      }
    }
  }

  @override
  void onInit() {
    catagoriesName = TextEditingController();
    super.onInit();
  }
}
