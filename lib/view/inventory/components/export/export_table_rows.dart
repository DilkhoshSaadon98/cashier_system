import 'package:cashier_system/controller/inventory/inventory_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/routes.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/functions/handle_data_function.dart';
import 'package:cashier_system/core/functions/show_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExportTableRows extends StatelessWidget {
  const ExportTableRows({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(InventoryController());
    final CustomShowPopupMenu customShowPopupMenu = CustomShowPopupMenu();
    return GetBuilder<InventoryController>(builder: (controller) {
      return checkData(
          controller.exportData,
          10,
          Expanded(
              flex: 10,
              child: Container(
                decoration: const BoxDecoration(
                  color: white,
                ),
                alignment: Alignment.topCenter,
                child: ListView.builder(
                    itemCount: controller.exportData.length,
                    itemBuilder: (context, index) {
                      var dataItem = controller.exportData[index];
                      return GestureDetector(
                        onTapDown: customShowPopupMenu.storeTapPosition,
                        onTap: () {
                          customShowPopupMenu.showPopupMenu(context, [
                            "View",
                            "Remove"
                          ], [
                            () async {
                              Get.toNamed(AppRoute.editImportExport,
                                  arguments: {
                                    "id": dataItem.exportId,
                                    "table": "Export"
                                  });
                            },
                            () async {
                              await controller.deleteTableRow("tbl_export",
                                  "export_id = ${dataItem.exportId}");
                            }
                          ]);
                        },
                        child: Container(
                          height: 40,
                          alignment: Alignment.topCenter,
                          color: white,
                          child: ListView(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: tableRowColor,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //! Export Check
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        height: 40,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: .3,
                                                color: primaryColor)),
                                        child: Checkbox(
                                          value: controller.exportSelectedRows
                                              .contains(
                                                  dataItem.exportId.toString()),
                                          onChanged: (value) {
                                            controller.checkSelectedRows(
                                                value!,
                                                dataItem.exportId.toString(),
                                                controller.exportSelectedRows);
                                          },
                                        ),
                                      ),
                                    ),
                                    //! Export Code
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        height: 40,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: .3,
                                                color: primaryColor)),
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          "${dataItem.exportId}",
                                          style: titleStyle,
                                        ),
                                      ),
                                    ),
                                    //! Expense Title
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        height: 40,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: .3,
                                                color: primaryColor)),
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          "${dataItem.exportAccount}",
                                          style: titleStyle,
                                        ),
                                      ),
                                    ),
                                    //! Export Supplier
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        height: 40,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: .3,
                                                color: primaryColor)),
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          "${dataItem.usersName}",
                                          style: titleStyle,
                                        ),
                                      ),
                                    ),

                                    //! Expense Price
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        height: 40,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: .3,
                                                color: primaryColor)),
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          formattingNumbers(
                                              dataItem.exportAmount),
                                          style: titleStyle,
                                        ),
                                      ),
                                    ),
                                    //! Expense Note
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                          height: 40,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: .3,
                                                  color: primaryColor)),
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            dataItem.exportNote.toString(),
                                            style: titleStyle,
                                          )),
                                    ),
                                    //! Invoice Date
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        height: 40,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: .3,
                                                color: primaryColor)),
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          "${dataItem.exportCreateDate}",
                                          style: titleStyle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              )));
    });
  }
}
