import 'dart:typed_data';

import 'package:cashier_system/controller/setting/invoice_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/shared/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/view/Settings/invoices/printing_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvoicesScreen extends StatelessWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(InvoiceController());
    return Scaffold(
      body: GetBuilder<InvoiceController>(builder: (controller) {
        return Row(
          children: [
            Expanded(
              flex: 2,
              child: const PrintingWidget(),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customSizedBox(),
                  Text(
                    "Header Titles",
                    style: titleStyle.copyWith(fontSize: 20),
                  ),
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      itemCount: controller.tileTitle.length,
                      itemBuilder: (BuildContext context, index) {
                        return CheckboxListTile(
                          title: Text(
                            controller.tileTitle[index],
                            style: titleStyle,
                          ),
                          value: controller.tileState[index],
                          onChanged: (value) {
                            controller.tileState[index] = value!;
                            controller.update();
                          },
                        );
                      },
                    ),
                  ),
                  customSizedBox(),
                  Text(
                    "Table Columns",
                    style: titleStyle.copyWith(fontSize: 20),
                  ),
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      itemCount: controller.tablesTileTitle.length,
                      itemBuilder: (BuildContext context, index) {
                        return CheckboxListTile(
                          title: Text(
                            controller.tablesTileTitle[index],
                            style: titleStyle,
                          ),
                          value: controller.tablesTileState[index],
                          onChanged: (value) {
                            controller.tablesTileState[index] = value!;
                            controller.update();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(15),
                color: primaryColor,
                child: ListView(
                  children: [
                    CustomHeaderScreen(
                      imagePath: AppImageAsset.settingIcons,
                      root: () {},
                      title: "Invoice",
                    ),
                    customSizedBox(),
                    Container(
                      height: 400, // Adjust as needed
                      child: DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              color: primaryColor,
                              child: TabBar(
                                dividerColor: primaryColor,
                                dividerHeight: 1,
                                unselectedLabelColor: white,
                                indicatorColor: secondColor,
                                indicatorSize: TabBarIndicatorSize.tab,
                                automaticIndicatorColorAdjustment: true,
                                labelColor: secondColor,
                                tabs: [
                                  Tab(
                                    child: Text(
                                      "A4 Recive".tr,
                                      style: bodyStyle.copyWith(color: white),
                                    ),
                                  ),
                                  Tab(
                                    child: Text("Mini Recive".tr,
                                        style:
                                            bodyStyle.copyWith(color: white)),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  Column(
                                    children: [
                                      customButtonGlobal(
                                        () {
                                          controller.choseHeaderFile();
                                        },
                                        "Upload Header",
                                        Icons.upload,
                                      ),
                                      customButtonGlobal(
                                        () async {},
                                        "Upload Footer",
                                        Icons.upload,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      customButtonGlobal(
                                        () {},
                                        "Upload Header",
                                        Icons.upload,
                                      ),
                                      customButtonGlobal(
                                        () {},
                                        "Upload Header",
                                        Icons.upload,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
