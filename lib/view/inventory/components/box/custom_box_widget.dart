import 'package:cashier_system/controller/inventory/inventory_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/shared/custom_table_header_global.dart';
import 'package:cashier_system/view/inventory/components/box/all_invoices_table_box.dart';
import 'package:cashier_system/view/inventory/components/box/box_table_rows.dart';
import 'package:cashier_system/view/inventory/components/export/export_table_rows.dart';
import 'package:cashier_system/view/inventory/components/import/import_table_rows.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CustomBoxWidget extends StatelessWidget {
  const CustomBoxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    InventoryController controller = Get.put(InventoryController());
    return GetBuilder<InventoryController>(builder: (context) {
      return Column(
        children: [
          Expanded(
            child: DefaultTabController(
                length: 4,
                initialIndex: 0,
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
                         onTap: (index) {
                              if (index == 0) {
                                controller.updateIndex(0);
                              } else if (index == 1) {
                                controller.updateIndex(1);
                              } else if (index == 2) {
                                controller.updateIndex(2);
                              } else if (index == 3) {
                                controller.updateIndex(3);
                              }
                            },
                        tabs: [
                          Tab(
                            icon: const Icon(
                              Icons.all_inbox_outlined,
                              size: 20,
                              color: white,
                            ),
                            child: Text(
                              "All".tr,
                              style: bodyStyle.copyWith(color: white),
                            ),
                          ),
                          Tab(
                            icon: const Icon(
                              FontAwesomeIcons.moneyCheck,
                              size: 20,
                              color: white,
                            ),
                            child: Text(
                              "Bills".tr,
                              style: bodyStyle.copyWith(color: white),
                            ),
                          ),
                          Tab(
                            icon: const Icon(
                              FontAwesomeIcons.arrowDown,
                              size: 20,
                              color: white,
                            ),
                            child: Text("Imports".tr,
                                style: bodyStyle.copyWith(color: white)),
                          ),
                          Tab(
                            icon: const Icon(
                              FontAwesomeIcons.arrowUp,
                              size: 20,
                              color: white,
                            ),
                            child: Text("Exports".tr,
                                style: bodyStyle.copyWith(color: white)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                  height: 50,
                                  child: CustomTableHeaderGlobal(
                                      data: const [
                                        "Invoice Number",
                                        "Invoice Type",
                                        "Invoice Amount",
                                        "Invoice Date"
                                      ],
                                      onDoubleTap: () {},
                                      flex: const [2, 3, 3, 3])),
                              const AllInvoicesTableBox(),
                              Container(
                                height: 50,
                                color: primaryColor,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total Ballance".tr,
                                      style: titleStyle.copyWith(color: white),
                                    ),
                                    Text(
                                      formattingNumbers(
                                          controller.totalInventoryPrice),
                                      style: titleStyle.copyWith(color: white),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(
                                  height: 50,
                                  child: CustomTableHeaderGlobal(
                                      data: const [
                                        "Select",
                                        "Invoice Number",
                                        "Invoice Payment",
                                        "Total Invoice Price",
                                        "Invoice Cost",
                                        'Invoice Profit',
                                        "Invoice Date"
                                      ],
                                      onDoubleTap: () {},
                                      flex: const [1, 2, 2, 3, 3, 3, 3])),
                              const BoxTableRows(),
                              Container(
                                height: 50,
                                color: primaryColor,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total Bills Ballance".tr,
                                      style: titleStyle.copyWith(color: white),
                                    ),
                                    Text(
                                      formattingNumbers(
                                          controller.totalInvoicePrice),
                                      style: titleStyle.copyWith(color: white),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          //! Import Section
                          Column(
                            children: [
                              SizedBox(
                                  height: 50,
                                  child: CustomTableHeaderGlobal(
                                      data: const [
                                        "Select",
                                        "Import Number",
                                        "Import Account",
                                        "Supplier Name",
                                        "Import Price",
                                        'Import Note',
                                        "Import Date",
                                      ],
                                      onDoubleTap: () {},
                                      flex: const [1, 2, 2, 2, 2, 3, 2])),
                              const ImportTableRows(),
                              Container(
                                height: 50,
                                color: primaryColor,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total Imports Ballance".tr,
                                      style: titleStyle.copyWith(color: white),
                                    ),
                                    Text(
                                      formattingNumbers(
                                          controller.totalImportPrice),
                                      style: titleStyle.copyWith(color: white),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ), // Replace this with the content for each tab
                          //! Export Section
                          Column(
                            children: [
                              SizedBox(
                                  height: 50,
                                  child: CustomTableHeaderGlobal(
                                    data: const [
                                      "Select",
                                      "Export Number",
                                      "Export Account",
                                      'Supplier Name',
                                      "Export Price",
                                      'Export Note',
                                      "Export Date",
                                    ],
                                    onDoubleTap: () {},
                                    flex: const [1, 2, 2, 2, 2, 3, 2],
                                  )),
                              const ExportTableRows(),
                              Container(
                                height: 50,
                                color: primaryColor,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total Exports Ballance".tr,
                                      style: titleStyle.copyWith(color: white),
                                    ),
                                    Text(
                                      formattingNumbers(
                                          controller.totalExportPrice),
                                      style: titleStyle.copyWith(color: white),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ), // Replace this with the content for each tab
                        ],
                      ),
                    ),
                  ],
                )),
          )
        ],
      );
    });
  }
}
