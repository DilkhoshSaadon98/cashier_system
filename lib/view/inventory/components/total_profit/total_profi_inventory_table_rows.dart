import 'package:cashier_system/controller/inventory/inventory_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TotalInventoryProfitTableRows extends StatelessWidget {
  const TotalInventoryProfitTableRows({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(InventoryController());
    return GetBuilder<InventoryController>(builder: (controller) {
      return Expanded(
          flex: 10,
          child: Container(
            decoration: const BoxDecoration(
              color: white,
            ),
            alignment: Alignment.topCenter,
            child: ListView.builder(
                itemCount: controller.profitData.length,
                itemBuilder: (context, index) {
                  var dataItem = controller.profitData[index];
                  return GestureDetector(
                    onTap: () {
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
                                      "${dataItem.invoiceId}",
                                      style: titleStyle,
                                    ),
                                  ),
                                ),
                                //! Invoice Payment
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
                                      "${dataItem.invoicePayment}",
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
                                      formattingNumbers(dataItem.invoicePrice),
                                      style: titleStyle,
                                    ),
                                  ),
                                ),
                                //! Invoice Cost Price
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
                                            dataItem.invoiceCostPrice),
                                        style: titleStyle,
                                      )),
                                ),
                                //! Invoice Profit
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
                                        formattingNumbers(int.parse(dataItem
                                                .invoicePrice
                                                .toString()) -
                                            int.parse(dataItem.invoiceCostPrice
                                                .toString())),
                                        style: titleStyle,
                                      )),
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
                                      "${dataItem.invoiceCreateDate}",
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
