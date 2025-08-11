import 'package:cashier_system/controller/printer/invoice_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/view/invoices/shared/design_barcode.dart';
import 'package:cashier_system/view/invoices/shared/design_page.dart';
import 'package:cashier_system/view/invoices/shared/printing_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvoiceScreenMobile extends StatelessWidget {
  const InvoiceScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    InvoiceController controller = Get.put(InvoiceController());
    return Scaffold(
      appBar: customAppBarTitle("Invoices", true),
      body: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              Container(
                color: buttonColor,
                child: TabBar(
                  dividerColor: primaryColor,
                  dividerHeight: 1,
                  unselectedLabelColor: white,
                  indicatorColor: secondColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  automaticIndicatorColorAdjustment: true,
                  dragStartBehavior: DragStartBehavior.start,
                  labelColor: secondColor,
                  onTap: (index) {
                    if (index == 1) {
                      controller.getItems();
                    }
                  },
                  tabs: [
                    Tab(
                      child: Text(
                        "Design".tr,
                        style: titleStyle.copyWith(color: white),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Barcode".tr,
                        style: titleStyle.copyWith(color: white),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "View".tr,
                        style: titleStyle.copyWith(color: white),
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(
                  child: TabBarView(children: [
                DesignPage(
                  isWindows: false,
                ),
                DesignBarcode(
                  isWindows: false,
                ),
                PrintingWidget(
                  headerData: {},
                  tableData: {},
                ),
              ]))
            ],
          )),
    );
  }
}
