import 'package:cashier_system/controller/buying/buying_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/functions/handle_data_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyingTableRows extends StatelessWidget {
  const BuyingTableRows({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(BuyingController());
    return GetBuilder<BuyingController>(builder: (controller) {
      return checkData(
          controller.purchaseData,
          10,
          Expanded(
              flex: 10,
              child: Container(
                decoration: const BoxDecoration(
                  color: white,
                ),
                alignment: Alignment.topCenter,
                child: ListView.builder(
                    itemCount: controller.purchaseData.length,
                    itemBuilder: (context, index) {
                      var dataItem = controller.purchaseData[index];
                      return GestureDetector(
                        onDoubleTap: () {},
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
                                    //! Purchase Check
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
                                          value: false,
                                          onChanged: (value) {},
                                          // value: controller.selectedRows
                                          //     .contains(controller
                                          //         .importData[index].importId
                                          //         .toString()),
                                          // onChanged: (value) {
                                          //   controller.checkSelectedRows(
                                          //       value!, index);
                                          // },
                                        ),
                                      ),
                                    ),
                                    //! Purchase Code
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
                                          "${dataItem.purchaseId}",
                                          style: titleStyle,
                                        ),
                                      ),
                                    ),
                                    //! Purchase Items Name
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
                                          "${dataItem.itemName}",
                                          style: titleStyle,
                                        ),
                                      ),
                                    ),
                                    //! Purchase Price
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
                                                dataItem.purchasePrice),
                                            style: titleStyle,
                                          )),
                                    ),
                                    //! Purchase QTY
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
                                            dataItem.purchaseQuantity!
                                                .toString(),
                                            style: titleStyle,
                                          )),
                                    ),
                                    //! Purchase Date
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
                                            dataItem.purchaseDate!,
                                            style: titleStyle,
                                          )),
                                    ),

                                    //! import Supplier Name
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
                                          "${dataItem.userName}",
                                          style: titleStyle,
                                        ),
                                      ),
                                    ),
                                    //! Purchase Payment
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
                                          "${dataItem.purchasePayment}",
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
