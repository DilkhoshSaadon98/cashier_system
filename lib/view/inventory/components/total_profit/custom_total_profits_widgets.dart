import 'package:cashier_system/controller/inventory/inventory_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/shared/custom_table_header_global.dart';
import 'package:cashier_system/view/inventory/components/expense/expense_table_rows.dart';
import 'package:cashier_system/view/inventory/components/profits/profits_table_rows.dart';
import 'package:cashier_system/view/inventory/components/total_profit/all_invoices_table.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CustomTotalProfitWidget extends StatelessWidget {
  const CustomTotalProfitWidget({super.key});

  @override
  Widget build(BuildContext context) {
    InventoryController controller = Get.put(InventoryController());
    return GetBuilder<InventoryController>(builder: (context) {
      return Column(
        children: [
          Expanded(
            child: DefaultTabController(
                length: 3,
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
                              FontAwesomeIcons.arrowUp,
                              size: 20,
                              color: white,
                            ),
                            child: Text("Expenses".tr,
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
                                        "Select",
                                        "Invoice Number",
                                        "Invoice Type",
                                        "Invoice Amount",
                                        "Invoice Date"
                                      ],
                                      onDoubleTap: () {},
                                      flex: const [1, 2, 3, 3, 3])),
                              const AllInvoicesTableTotalProfit(),
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
                                        "Invoice NO",
                                        "Invice Payment",
                                        "Total Invoice Price",
                                        "Invoice Cost",
                                        'Invoice Profit',
                                        "Invoice Date"
                                      ],
                                      onDoubleTap: () {},
                                      flex: const [1, 2, 2, 2, 3, 3, 3, 3])),
                              const ProfitTableRows(),
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
                          Column(
                            children: [
                              SizedBox(
                                  height: 50,
                                  child: CustomTableHeaderGlobal(
                                      data: const [
                                        "Select",
                                        "Expenses Number",
                                        "Expenses Account",
                                        "Supplier Name",
                                        "Expenses Price",
                                        'Expenses Note',
                                        "Expenses Date",
                                      ],
                                      onDoubleTap: () {},
                                      flex: const [1, 2, 2, 2, 2, 3, 2])),
                              const ExpenseTableRows(),
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
                                      "Total Expenses Ballance".tr,
                                      style: titleStyle.copyWith(color: white),
                                    ),
                                    Text(
                                      formattingNumbers(
                                          controller.totalExpensesPrice),
                                      style: titleStyle.copyWith(color: white),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
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
