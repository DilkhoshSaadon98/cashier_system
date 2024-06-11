import 'package:cashier_system/controller/imp_exp/import_export_controller.dart';
import 'package:cashier_system/core/shared/custom_snack_bar.dart';
import 'package:cashier_system/data/model/export_model.dart';

class ExportController extends ImportExportController {
  //! Get Export Data
  getexportData() async {
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
    response = await exportClass.getExportData(
      supplier: supplier,
      account: account,
      startNo: startNo,
      endNo: endNo,
      startTime: startTime,
      endTime: endTime,
    );
    if (response["status"] == 'success') {
      totalExportBallance = 0;
      clearFileds();
      exportData.clear();
      List listData = response['data']['data'] ?? [];
      totalExportBallance = response["total_ballance"];
      exportData.addAll(listData.map((e) => ExportModel.fromJson(e)));
    }
    update();
  }

  addExportData() async {
    Map<String, dynamic> data = {
      "export_supplier_id": userControllerId.text,
      "export_amount": amountController.text,
      "export_account": accountControllerName.text,
      "export_note": noteController.text,
      "export_create_date": dateController.text,
    };
    var response = await exportClass.addExportData(data);
    clearFileds();
    if (response > 0) {
      getexportData();
    }
  }

  deleteExportData() async {
    if (selectedRows.isNotEmpty) {
      var response = await exportClass.deleteExportData(selectedRows);
      if (response > 0) {
        getexportData();
      }
    } else {
      customSnackBar("Error", "Please select one row at least");
    }

    update();
  }

  ExportModel? initialExportModel; // Add this to store initial data if needed
  Future<void> updateControllerData(ExportModel exportModel) async {
    accountControllerName.text = exportModel.exportAccount.toString();
    userControllerName.text = exportModel.exportSupplier.toString();
    dateController.text = exportModel.exportCreateDate.toString();
    amountController.text = exportModel.exportAmount.toString();
    noteController.text = exportModel.exportNote.toString();
    update();
  }

  @override
  void onInit() {
    getexportData();
    super.onInit();
  }
}
