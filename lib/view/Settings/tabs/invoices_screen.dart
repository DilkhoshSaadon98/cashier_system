import 'package:cashier_system/controller/setting/invoice_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/shared/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
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
              child: Container(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Container(
                    height: Get.height - 80,
                    decoration: BoxDecoration(border: Border.all()),
                    child: Column(
                      children: [
                        Container(
                          height: 200,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: controller.headerFile != null
                                    ? FileImage(controller.headerFile!)
                                    : AssetImage(
                                        controller.selectedHeaderImage.isEmpty
                                            ? 'assets/header.png'
                                            : controller.selectedHeaderImage,
                                      ) as ImageProvider,
                              ),
                              color: primaryColor),
                        ),
                        SizedBox(
                          height: controller.headerHeight,
                          child: LayoutBuilder(builder: (context, constraints) {
                            controller.headerListHeight();
                            return SizedBox(
                              height: 30,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: GridView.custom(
                                  childrenDelegate: SliverChildBuilderDelegate(
                                      childCount: controller
                                          .selectedColumnsHeader
                                          .length, (context, index) {
                                    return Text(
                                      controller.selectedColumnsHeader[index],
                                      style: titleStyle,
                                    );
                                  }),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 10),
                                ),
                              ),
                            );
                          }),
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
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(title),
                                    ),
                                  );
                                }).toList(),
                              ),
                              // Add your table rows here dynamically based on the selectedColumns
                            ],
                          ),
                        ),
                        const Spacer(),
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
                                        () {
                                          controller.choseFooterFile();
                                        },
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
