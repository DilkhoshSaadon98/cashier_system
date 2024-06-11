import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/controller/inventory/inventory_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/routes.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/functions/show_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllInvoicesTableTotalProfit extends StatelessWidget {
  const AllInvoicesTableTotalProfit({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(InventoryController());

    final CustomShowPopupMenu customShowPopupMenu = CustomShowPopupMenu();

    return GetBuilder<InventoryController>(builder: (controller) {
      return Expanded(
          flex: 10,
          child: Container(
            decoration: const BoxDecoration(
              color: white,
            ),
            alignment: Alignment.topCenter,
            child: ListView.builder(
                itemCount: controller.totalProfitModel.length,
                itemBuilder: (context, index) {
                  var dataItem = controller.totalProfitModel[index];
                  return GestureDetector(
                    onTapDown: customShowPopupMenu.storeTapPosition,
                    onTap: () => customShowPopupMenu.showPopupMenu(context, [
                      "View",
                      "Remove"
                    ], [
                      () async {
                        if (dataItem.totalProfitTable == "Cash") {
                          CashierController cashierController =
                              Get.put(CashierController());
                          await cashierController.getCartData(myServices
                                  .systemSharedPreferences
                                  .getString("cart_number") ??
                              "1");
                          await cashierController.updateInvoice(
                              dataItem.totalProfitRowId.toString());
                          Get.toNamed(AppRoute.cashierScreen);
                        } else {
                          Get.toNamed(AppRoute.editImportExport, arguments: {
                            "id": dataItem.totalProfitRowId,
                            "table": "Export"
                          });
                        }
                      },
                      () {}
                    ]),
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
                                //! Invoice Check
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: .3, color: primaryColor)),
                                    child: Checkbox(
                                      value: controller.selectedRows.contains(
                                          dataItem.totalProfitId.toString()),
                                      onChanged: (value) {
                                        controller.checkSelectedRows(
                                            value!,
                                            dataItem.totalProfitId.toString(),
                                            controller.selectedRows);
                                      },
                                    ),
                                  ),
                                ),
                                //! Invoice Code
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: .3, color: primaryColor)),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      "${dataItem.totalProfitId}",
                                      style: titleStyle,
                                    ),
                                  ),
                                ),
                                //! Invoice Source
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: .3, color: primaryColor)),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      "${dataItem.totalProfitTable}",
                                      style: titleStyle,
                                    ),
                                  ),
                                ),

                                //! Invoice Price
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: .3, color: primaryColor)),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      formattingNumbers(
                                          dataItem.totalProfitAmount),
                                      style: titleStyle,
                                    ),
                                  ),
                                ),
                                //! Invoice Date
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: .3, color: primaryColor)),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      "${dataItem.totalProfitCreateDate}",
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
          ));
    });
  }
}
