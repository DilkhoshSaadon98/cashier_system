import 'dart:ui';

import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: bodyStyle.copyWith(fontSize: 20),
            ),
            customSizedBox(25),
            SizedBox(
              height: 200,
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
                            controller.lastInvoices[index].invoiceId.toString(),
                            style: titleStyle,
                          ),
                          title: Text(
                            controller.lastInvoices[index].usersName ??
                                "UNKNOWN",
                            style: titleStyle,
                          ),
                          subtitle: Text(
                            controller.lastInvoices[index].invoiceCreateDate!,
                            style: bodyStyle,
                          ),
                          trailing: Text(
                            formattingNumbers(
                                controller.lastInvoices[index].invoicePrice!),
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
