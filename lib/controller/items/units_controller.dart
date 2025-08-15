import 'package:cashier_system/core/class/statusrequest.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/core/dialogs/snackbar_helper.dart';
import 'package:cashier_system/core/functions/handing_data_controller.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/data/model/units_model.dart';
import 'package:cashier_system/data/source/units_class.dart';
import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnitsController extends GetxController {
  final baseUnitName = TextEditingController();
  final unitFactor = TextEditingController();
  final search = TextEditingController();
  UnitsClass unitsClass = UnitsClass();
  var isActive = true.obs;
  List<UnitModel> unitsData = [];
  bool isSearch = false;
  int stackIndex = 0;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  StatusRequest statusRequest = StatusRequest.none;
  SqlDb sqlDb = SqlDb();
  //? Get UNits Data:
  Future<void> getUnitsData() async {
    try {
      var response = await sqlDb.getAllData("tbl_units");
      statusRequest = handlingData(response);
      if (statusRequest == StatusRequest.success) {
        unitsData.clear();
        List dataList = response['data'];
        unitsData.addAll(dataList.map((e) => UnitModel.fromJson(e)));
      } else {
        statusRequest = StatusRequest.noData;
      }
    } catch (e) {
      statusRequest = StatusRequest.serverException;
      showErrorDialog(e.toString(),
          title: "Error", message: "Error during fetching data");
    } finally {
      update();
    }
  }

  //? Add UNits Data:
  addUnitData() async {
    if (!formState.currentState!.validate()) {
      showErrorSnackBar(TextRoutes.formValidationFailed);
      return;
    }
    try {
      final baseUnitData = {
        "base_unit_name": "${baseUnitName.text} ${unitFactor.text}",
        "factor": unitFactor.text,
        "created_at": currentTime,
      };

      await unitsClass.addUnitsData(baseUnitData);

      Get.back();
      showSuccessSnackBar(TextRoutes.dataAddedSuccess);
    } catch (e) {
      showErrorDialog(e.toString(), message: TextRoutes.anErrorOccurred);
    } finally {
      baseUnitName.clear();
      unitFactor.clear();
    }
  }

  updateUnitData() async {
    if (!formState.currentState!.validate()) {
      showErrorSnackBar(TextRoutes.formValidationFailed);
      return;
    }
    try {
      final baseUnitData = {
        "base_unit_name": "${baseUnitName.text} ${unitFactor.text}",
        "factor": unitFactor.text,
        "created_at": currentTime,
      };

      await unitsClass.updateUnitsData(baseUnitData, 0);

      Get.back();
      showSuccessSnackBar(TextRoutes.dataAddedSuccess);
    } catch (e) {
      showErrorDialog(e.toString(), message: TextRoutes.anErrorOccurred);
    } finally {
      baseUnitName.clear();
      unitFactor.clear();
    }
  }

  Future<void> searchUnits() async {
    var response = await sqlDb.getAllData(
      "tbl_units",
      where: "base_unit_name LIKE '%${search.text}%'",
    );

    if (response['status'] == "success") {
      unitsData.clear();
      List responsedata = response['data'];
      unitsData.addAll(responsedata.map((e) => UnitModel.fromJson(e)));
    }

    update();
  }

  void onSearchItems() {
    isSearch = true;
    searchUnits();
    update();
  }

  @override
  void onInit() {
    getUnitsData();
    super.onInit();
  }
}
