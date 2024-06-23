import 'package:cashier_system/controller/inventory/inventory_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/handle_data_function.dart';
import 'package:cashier_system/core/functions/show_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DebtorTableRows extends StatelessWidget {
  const DebtorTableRows({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(InventoryController());
    final CustomShowPopupMenu customShowPopupMenu = CustomShowPopupMenu();
    return GetBuilder<InventoryController>(builder: (controller) {
      return checkData(
          controller.debtorsData,
          10,
          Expanded(
              flex: 10,
              child: Container(
                decoration: const BoxDecoration(
                  color: white,
                ),
                alignment: Alignment.topCenter,
                child: ListView.builder(
                    itemCount: controller.debtorsData.length,
                    itemBuilder: (context, index) {
                      var dataItem = controller.debtorsData[index];
                      return GestureDetector(
                        onTapDown: customShowPopupMenu.storeTapPosition,
                        onTap: () {
                          customShowPopupMenu.showPopupMenu(context, [
                            "View",
                            "Delete Selected"
                          ], [
                            () async {
                              // Get.toNamed(AppRoute.editImportExport,
                              //     arguments: {
                              //       "id": dataItem.exportId,
                              //       "table": "Export"
                              //     });
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
                                    //! Debtors Name
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
                                          dataItem.debtorsName,
                                          style: titleStyle,
                                        ),
                                      ),
                                    ),
                                    //! Debtors Invoices
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        height: 40,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: .3,
                                                color: primaryColor)),
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          "${dataItem.totalInvoicesCount}",
                                          style: titleStyle,
                                        ),
                                      ),
                                    ),
                                    //! Debtors Invoice Ballance
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
                                          "${dataItem.totalInvoiceValueDept}",
                                          style: titleStyle,
                                        ),
                                      ),
                                    ),

                                    //! Debtors Imports
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        height: 40,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: .3,
                                                color: primaryColor)),
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          dataItem.totalImportsCount.toString(),
                                          style: titleStyle,
                                        ),
                                      ),
                                    ),
                                    //! Debtors Imports Ballance
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
                                            dataItem.totalImportValue
                                                .toString(),
                                            style: titleStyle,
                                          )),
                                    ),
                                    //! Debtors Ballance
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
                                          "${dataItem.totalCustomerDebtorBallance}",
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
