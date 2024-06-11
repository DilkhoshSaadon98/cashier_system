import 'package:cashier_system/controller/imp_exp/import_export_controller.dart';
import 'package:cashier_system/core/shared/custom_snack_bar.dart';
import 'package:cashier_system/data/model/import_model.dart';

class ImportController extends ImportExportController {
  getImportData() async {
    var response = {};
    String? supplier;
    String? account;
    String? startNo;
    String? endNo;
    String? startTime;
    String? endTime;
    if (userControllerId.text.isNotEmpty) {
      supplier = userControllerId.text;
    }
    if (accountControllerName.text.isNotEmpty) {
      account = accountControllerName.text;
    }

    if (noFromController.text.isNotEmpty && noToController.text.isNotEmpty) {
      startNo = noFromController.text;
      endNo = noToController.text;
    }

    if (dateFromController.text.isNotEmpty &&
        dateToController.text.isNotEmpty) {
      startTime = dateFromController.text;
      endTime = dateToController.text;
    }
    response = await importClass.getImportData(
      supplier: supplier,
      account: account,
      startNo: startNo,
      endNo: endNo,
      startTime: startTime,
      endTime: endTime,
    );
    if (response["status"] == 'success') {
      totalImportBallance = 0;
      clearFileds();
      importData.clear();
      List listData = response['data']['data'] ?? [];
      totalImportBallance = response["total_ballance"];
      importData.addAll(listData.map((e) => ImportModel.fromJson(e)));
    }
    update();
  }

  addImportData() async {
    Map<String, dynamic> data = {
      "import_supplier_id": userControllerId.text,
      "import_amount": amountController.text,
      "import_account": accountControllerName.text,
      "import_note": noteController.text,
      "import_create_date": dateController.text,
    };
    var response = await importClass.addImportData(data);
    clearFileds();
    if (response > 0) {
      getImportData();
    }
    update();
  }

  deleteImportData() async {
    if (selectedRows.isNotEmpty) {
      var response = await importClass.deleteImportData(selectedRows);
      if (response > 0) {
        getImportData();
      }
    } else {
      customSnackBar("Error", "Please select one row at least");
    }

    update();
  }

  @override
  void onInit() {
    getImportData();
    super.onInit();
  }
}
