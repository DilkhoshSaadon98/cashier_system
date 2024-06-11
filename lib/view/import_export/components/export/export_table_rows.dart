import 'package:cashier_system/controller/imp_exp/export_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/functions/handle_data_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExportTableRows extends StatelessWidget {
  const ExportTableRows({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ExportController());
    return GetBuilder<ExportController>(builder: (controller) {
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
                                    //! import Check
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
                                          value: controller.selectedRows
                                              .contains(controller
                                                  .exportData[index].exportId
                                                  .toString()),
                                          onChanged: (value) {
                                            controller.checkSelectedRows(
                                                value!, index);
                                          },
                                        ),
                                      ),
                                    ),
                                    //! import Code
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
                                    //! import Account
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

                                    //! import Date
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
                                          dataItem.exportCreateDate!,
                                          style: titleStyle,
                                        ),
                                      ),
                                    ),
                                    //! import Amount
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
                                          )),
                                    ),
                                    //! import Note
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
                                            dataItem.exportNote!,
                                            style: titleStyle,
                                          )),
                                    ),
                                    //! import Employee Name
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
                                          "${dataItem.usersName}",
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
