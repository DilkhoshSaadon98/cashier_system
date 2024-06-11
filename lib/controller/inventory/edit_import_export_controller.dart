import 'package:cashier_system/controller/inventory/inventory_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/routes.dart';
import 'package:cashier_system/core/shared/custom_snack_bar.dart';
import 'package:cashier_system/data/model/export_model.dart';
import 'package:cashier_system/data/model/import_model.dart';
import 'package:cashier_system/data/model/users_model.dart';
import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditImportExportController extends GetxController {
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController accountControllerName = TextEditingController();
  TextEditingController accountControllerId = TextEditingController();
  TextEditingController userControllerName = TextEditingController();
  TextEditingController userControllerId = TextEditingController();
  List<ImportModel> importData = [];
  List<ExportModel> exportData = [];
  List<UsersModel> listdataSearchUsers = [];
  List<SelectedListItem> dropDownListUsers = [];
  SqlDb sqlDb = SqlDb();
  int dataId = 0;
  DateTime selectedDate = DateTime.now();
  //? Get current date Data for date picker
  Future<void> selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      barrierColor: primaryColor.withOpacity(.3),
      initialDate: selectedDate,
      firstDate: DateTime(2024, 1),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) selectedDate = picked;
    controller.text = DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDate);
    update();
  }

//? Get Users Data;
  getUsers() async {
    var response = await sqlDb.getAllData("tbl_users");
    if (response['status'] == "success") {
      dropDownListUsers.clear();
      listdataSearchUsers.clear();
      List responsedata = response['data'];
      listdataSearchUsers
          .addAll(responsedata.map((e) => UsersModel.fromJson(e)));
      for (int i = 0; i < listdataSearchUsers.length; i++) {
        dropDownListUsers.add(SelectedListItem(
            name: listdataSearchUsers[i].usersName!,
            value: listdataSearchUsers[i].usersId!.toString()));
      }
      update();
    }
  }

  String dataTable = "";
  getImportData(String id) async {
    var response =
        await sqlDb.getAllData("importDetailsView", where: "import_id = $id");
    if (response['status'] == 'success') {
      importData.clear();

      List listData = response['data'] ?? [];
      importData.addAll(listData.map((e) => ImportModel.fromJson(e)));
      amountController.text = importData[0].importAmount.toString();
      noteController.text = importData[0].importNote ?? "";
      dateController.text = importData[0].importCreateDate!;
      accountControllerName.text = importData[0].importAccount!;
      userControllerName.text = importData[0].usersName!;
      userControllerId.text = importData[0].usersId.toString();
    }
    update();
  }

  getExportData(String id) async {
    var response =
        await sqlDb.getAllData("exportDetailsView", where: "export_id = $id");
    if (response['status'] == 'success') {
      importData.clear();

      List listData = response['data'] ?? [];
      exportData.addAll(listData.map((e) => ExportModel.fromJson(e)));
      amountController.text = exportData[0].exportAmount.toString();
      noteController.text = exportData[0].exportNote ?? "";
      dateController.text = exportData[0].exportCreateDate!;
      accountControllerName.text = exportData[0].exportAccount!;
      userControllerName.text = exportData[0].usersName!;
      userControllerId.text = exportData[0].usersId.toString();
    }
  }

  editImportData() async {
    Map<String, dynamic> data = {
      "import_supplier_id": userControllerId.text,
      "import_amount": amountController.text,
      "import_account": accountControllerName.text,
      "import_note": noteController.text,
      "import_create_date": dateController.text,
    };
    var response =
        await sqlDb.updateData("tbl_import", data, "import_id = $dataId");
    if (response > 0) {
      customSnackBar("Success", "Updated Success");
      InventoryController controller = Get.put(InventoryController());
      controller.getBoxData();
      Get.offAllNamed(AppRoute.inventoryScreen);
    }
    update();
  }

  editExportData() async {
    Map<String, dynamic> data = {
      "export_supplier_id": userControllerId.text,
      "export_amount": amountController.text,
      "export_account": accountControllerName.text,
      "export_note": noteController.text,
      "export_create_date": dateController.text,
    };
    var response =
        await sqlDb.updateData("tbl_export", data, "export_id = $dataId");
    if (response > 0) {
      customSnackBar("Success", "Updated Success");
      InventoryController controller = Get.put(InventoryController());
      controller.getBoxData();
      Get.offAllNamed(AppRoute.inventoryScreen);
    }
    update();
  }

  deleteData(String tableName, String sql) async {
    int response = await sqlDb.deleteData(tableName, sql);
    if (response > 0) {
      InventoryController controller = Get.put(InventoryController());
      controller.getBoxData();
      Get.offAllNamed(AppRoute.inventoryScreen);
    }
  }

  @override
  void onInit() async {
    dataId = await Get.arguments["id"];
    dataTable = await Get.arguments["table"];
    if (dataTable == "Import") {
      await getImportData(dataId.toString());
    } else {
      await getExportData(dataId.toString());
    }
    getUsers();
    super.onInit();
  }
}
