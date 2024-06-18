import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/custom_table_header_global.dart';
import 'package:cashier_system/view/import_export/desktop/export/export_table_rows.dart';
import 'package:flutter/material.dart';

class ExportTableWidget extends StatelessWidget {
  const ExportTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarTitle("Exports"),
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
                  "Amount",
                  "Note",
                  "Supplier Name"
                ],
                onDoubleTap: () {},
                flex: const [1, 2, 2, 2, 2, 3, 3]),
          ),
          const ExportTableRows()
        ],
      ),
    );
  }
}
