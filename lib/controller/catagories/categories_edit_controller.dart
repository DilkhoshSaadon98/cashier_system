import 'dart:io';
import 'package:cashier_system/controller/catagories/catagories_view_controller.dart';
import 'package:cashier_system/core/class/statusrequest.dart';
import 'package:cashier_system/core/constant/routes.dart';
import 'package:cashier_system/core/functions/upload_file.dart';
import 'package:cashier_system/data/model/categories_model.dart';
import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CatagoriesEditController extends GetxController {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController? catagoriesName;
  SqlDb sqlDb = SqlDb();
  CategoriesModel? catagoriesModel;
  StatusRequest? statusRequest = StatusRequest.none;

  File? file;
  choseFile() async {
    file = await fileUploadGallery();
    update();
  }

  updateCategories(id) async {
    if (formState.currentState!.validate()) {
      statusRequest = StatusRequest.loading;
      Map<String, dynamic> data = {
        'categories_name': catagoriesName!.text,
      };
      int response =
          await sqlDb.updateData("tbl_categories", data, "categories_id = $id");

      if (response > 0) {
        CatagoriesController controller = Get.find();
        controller.getCategoriesData();
        Get.offAndToNamed(AppRoute.catagoriesScreen);
      }
      // if (StatusRequest.success == statusRequest) {
      //   data.clear();
      //   if (response['status'] == "success") {
      //     Get.offAllNamed(AppRoute.catagoriesScreen);
      //     CatagoriesController catagoriesController = Get.find();
      //     catagoriesController.getCategoriesData();
      //     customSnackBar("Success", "Categories Updated Successfuly", true);
      //   } else {
      //     statusRequest = StatusRequest.failure;
      //   }
      //   // End
      // }
      update();
    }
  }

  @override
  void onInit() {
    catagoriesModel = Get.arguments['categoriesModel'];
    catagoriesName = TextEditingController();
    catagoriesName!.text = catagoriesModel!.categoriesName!;
    super.onInit();
  }
}
