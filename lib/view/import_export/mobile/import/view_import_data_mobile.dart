import 'package:cashier_system/controller/imp_exp/import_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewImportDataMobile extends StatelessWidget {
  const ViewImportDataMobile({super.key});

  @override
  Widget build(BuildContext context) {
    ImportController controller = Get.put(ImportController());
    return Scaffold(
      appBar: customAppBarTitle("Import", true),
      body: GetBuilder<ImportController>(builder: (context) {
        return Container(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: SizedBox(
              width: Get.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  dataRowColor: MaterialStateProperty.all(tableRowColor),
                  //  dataTextStyle: titleStyle,
                  dividerThickness: 1,
                  headingRowColor: MaterialStateProperty.all(primaryColor),
                  headingTextStyle: titleStyle.copyWith(color: white),
                  border: TableBorder.all(width: 2, color: thirdColor),
                  columns: const [
                    DataColumn(
                        // headingRowAlignment: MainAxisAlignment.center,
                        label: Text(
                            textAlign: TextAlign.center, 'Invoice Number')),
                    DataColumn(
                        // headingRowAlignment: MainAxisAlignment.center,
                        label: Text('Account')),
                    DataColumn(
                        // headingRowAlignment: MainAxisAlignment.center,
                        label: Text('Date')),
                    DataColumn(
                        // headingRowAlignment: MainAxisAlignment.center,
                        label: Text('Amount')),
                    DataColumn(
                        // headingRowAlignment: MainAxisAlignment.center,
                        label: Text('Note')),
                    DataColumn(
                        // headingRowAlignment: MainAxisAlignment.center,
                        label: Text('Supplier Name')),
                  ],
                  rows: [
                    ...List.generate(controller.importData.length, (index) {
                      var dataItem = controller.importData[index];
                      return DataRow(cells: [
                        DataCell(Text(dataItem.importId.toString())),
                        DataCell(Text(dataItem.importAccount!)),
                        DataCell(Text(dataItem.importCreateDate!)),
                        DataCell(
                            Text(formattingNumbers(dataItem.importAmount!))),
                        DataCell(Text(dataItem.importNote!)),
                        DataCell(Text(dataItem.usersName!)),
                      ]);
                    })
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
