
import 'package:cashier_system/controller/inventory/inventory_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/routes.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/functions/handle_data_function.dart';
import 'package:cashier_system/core/functions/show_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreditorTableRows extends StatelessWidget {
  const CreditorTableRows({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(InventoryController());
    final CustomShowPopupMenu customShowPopupMenu = CustomShowPopupMenu();
    return GetBuilder<InventoryController>(builder: (controller) {
      return checkData(
          controller.expensesData,
          10,
          Expanded(
              flex: 10,
              child: Container(
                decoration: const BoxDecoration(
                  color: white,
                ),
                alignment: Alignment.topCenter,
                child: ListView.builder(
                    itemCount: controller.expensesData.length,
                    itemBuilder: (context, index) {
                      var dataItem = controller.expensesData[index];
                      return GestureDetector(
                        onTapDown: customShowPopupMenu.storeTapPosition,
                        onTap: () {
                          customShowPopupMenu.showPopupMenu(context, [
                            "View",
                            "Delete Selected"
                          ], [
                            () async {
                              Get.toNamed(AppRoute.editImportExport,
                                  arguments: {
                                    "id": dataItem.exportId,
                                    "table": "Export"
                                  });
                            },
                            () async {},
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
                                    //! Expenses Check
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
                                    //! Expense Code
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
                                    //! Expense Account
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
