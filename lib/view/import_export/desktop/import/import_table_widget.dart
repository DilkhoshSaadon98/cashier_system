import 'package:cashier_system/controller/imp_exp/import_controller.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/custom_table_header_global.dart';
import 'package:cashier_system/view/import_export/desktop/import/import_table_rows.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImportTableWidget extends GetView<ImportController> {
  const ImportTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarTitle("Imports"),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: CustomTableHeaderGlobal(
                data: const [
                  "Select",
                  "Invoice Number",
                  "Account",
                  "Date",
                  "Amount ",
                  "Note",
                  "Supplier Name",
                ],
                onDoubleTap: () {
                  controller.selectAllRows();
                },
                flex: const [1, 2, 2, 2, 2, 3, 3]),
          ),
          const ImportTableRows()
        ],
      ),
    );
  }
}
