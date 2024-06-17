import 'package:cashier_system/controller/setting/invoice_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
              child: Container(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Container(
                    width: 600,
                    height: Get.height - 80,
                    decoration: BoxDecoration(border: Border.all()),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: const Column(
                            children: <Widget>[
                              // Image.asset('assets/header-image.jpg'), // Replace with your image path
                              FlutterLogo(),
                              SizedBox(height: 8.0),
                              Text(
                                'Header Title',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Table(
                            border: TableBorder.all(),
                            columnWidths: Map.fromIterable(
                              controller.selectedColumns,
                              key: (item) =>
                                  controller.selectedColumns.indexOf(item),
                              value: (item) => FlexColumnWidth(1),
                            ),
                            children: [
                              TableRow(
                                children:
                                    controller.selectedColumns.map((title) {
                                  return TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(title),
                                    ),
                                  );
                                }).toList(),
                              ),
                              // Add your table rows here dynamically based on the selectedColumns
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: const Column(
                            children: <Widget>[
                              FlutterLogo(), // Replace with your image path
                              SizedBox(height: 8.0),
                              Text(
                                'Footer Text',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
