import 'dart:ui';

import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_divider.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

customDialogShowInvoices(String title) {
  CashierController controller = Get.put(CashierController());
  Get.defaultDialog(
    title: "",
    titleStyle: titleStyle,
    content: BackdropFilter(
      filter:
          ImageFilter.blur(sigmaX: 1, sigmaY: 1, tileMode: TileMode.repeated),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title.tr,
              style: bodyStyle.copyWith(fontSize: 20),
            ),
            customDivider(),
            verticalGap(10),
            controller.lastInvoices.isEmpty
                ? Container(
                    alignment: Alignment.center,
                    height: 200,
                    child: Text(
                      TextRoutes.noDataFound.tr,
                      style: titleStyle,
                    ),
                  )
                : SizedBox(
                    height: 300,
                    width: Get.width,
                    child: ListView.builder(
                        itemCount: controller.lastInvoices.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              controller.updateInvoice(controller
                                  .lastInvoices[index].invoiceId
                                  .toString());
                              Get.back();
                            },
                            child: Card(
                              child: ListTile(
                                leading: Text(
                                  controller.lastInvoices[index].invoiceId
                                      .toString(),
                                  style: titleStyle,
                                ),
                                title: Text(
                                  controller.lastInvoices[index].usersName!.tr,
                                  style: titleStyle,
                                ),
                                subtitle: Text(
                                  controller
                                      .lastInvoices[index].invoiceCreateDate!,
                                  style: bodyStyle,
                                ),
                                trailing: Text(
                                  formattingNumbers(controller
                                      .lastInvoices[index].invoicePrice!),
                                  style: titleStyle,
                                ),
                              ),
                            ),
                          );
                        }),
                  )
          ],
        ),
      ),
    ),
  );
}
