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
                  dataRowColor: WidgetStateProperty.all(tableRowColor),
                  //  dataTextStyle: titleStyle,
                  dividerThickness: 1,
                  headingRowColor: WidgetStateProperty.all(primaryColor),
                  headingTextStyle: titleStyle.copyWith(color: white),
                  border: TableBorder.all(width: 2, color: thirdColor),
                  columns: [
                    DataColumn(
                        // headingRowAlignment: MainAxisAlignment.center,
                        label: Text(
                      textAlign: TextAlign.center,
                      'Select',
                      style: titleStyle.copyWith(color: white),
                    )),
                    DataColumn(
                        // headingRowAlignment: MainAxisAlignment.center,
                        label: Text(
                      textAlign: TextAlign.center,
                      'Invoice Number',
                      style: titleStyle.copyWith(color: white),
                    )),
                    DataColumn(
                        // headingRowAlignment: MainAxisAlignment.center,
                        label: Text(
                      'Account',
                      style: titleStyle.copyWith(color: white),
                    )),
                    DataColumn(
                        // headingRowAlignment: MainAxisAlignment.center,
                        label: Text(
                      'Date',
                      style: titleStyle.copyWith(color: white),
                    )),
                    DataColumn(
                        // headingRowAlignment: MainAxisAlignment.center,
                        label: Text(
                      'Amount',
                      style: titleStyle.copyWith(color: white),
                    )),
                    DataColumn(
                        // headingRowAlignment: MainAxisAlignment.center,
                        label: Text(
                      'Note',
                      style: titleStyle.copyWith(color: white),
                    )),
                    DataColumn(
                        // headingRowAlignment: MainAxisAlignment.center,
                        label: Text(
                      'Supplier Name',
                      style: titleStyle.copyWith(color: white),
                    )),
                  ],
                  rows: [
                    ...List.generate(controller.importData.length, (index) {
                      var dataItem = controller.importData[index];
                      return DataRow(cells: [
                        DataCell(Checkbox(
                          value: controller.selectedRowsImports.contains(
                              controller.importData[index].importId.toString()),
                          onChanged: (value) {
                            controller.checkSelectedRowsImports(value!, index);
                          },
                        )),
                        DataCell(Text(
                          dataItem.importId.toString(),
                          style: bodyStyle,
                        )),
                        DataCell(Text(
                          dataItem.importAccount!,
                          style: bodyStyle,
                        )),
                        DataCell(Text(
                          dataItem.importCreateDate!,
                          style: bodyStyle,
                        )),
                        DataCell(Text(
                          formattingNumbers(dataItem.importAmount!),
                          style: bodyStyle,
                        )),
                        DataCell(Text(
                          dataItem.importNote!,
                          style: bodyStyle,
                        )),
                        DataCell(Text(
                          dataItem.usersName!,
                          style: bodyStyle,
                        )),
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
