import 'package:cashier_system/controller/inventory/inventory_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/constant/routes.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_divider.dart';
import 'package:cashier_system/core/shared/custom_formfield_global.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_table_header_global.dart';
import 'package:cashier_system/view/inventory/components/box/custom_box_widget.dart';
import 'package:cashier_system/view/inventory/components/custom_drop_down_inventory.dart';
import 'package:cashier_system/view/inventory/components/deptor/debtor_table_rows.dart';
import 'package:cashier_system/view/inventory/components/expense/expense_table_rows.dart';
import 'package:cashier_system/view/inventory/components/export/export_table_rows.dart';
import 'package:cashier_system/view/inventory/components/import/import_table_rows.dart';
import 'package:cashier_system/view/inventory/components/profits/profits_table_rows.dart';
import 'package:cashier_system/view/inventory/components/total_profit/custom_total_profits_widgets.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/shared/custom_sized_box.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(InventoryController());
    return Scaffold(
      body: GetBuilder<InventoryController>(builder: (controller) {
        return Row(
          children: [
            //! Table Content Side (Left Side):
            Expanded(
                flex: 6,
                child: Scaffold(
                  appBar: customAppBarTitle(myServices.sharedPreferences
                          .getString("inventory_title") ??
                      "Box"),
                  body: IndexedStack(
                    index: myServices.sharedPreferences
                            .getInt("inventory_index") ??
                        0,
                    children: [
                      //! Index 0:(Box Show)
                      const CustomBoxWidget(),
                      //! Index 1:(Profit Show)
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
                          const ProfitTableRows()
                        ],
                      ),
                      //! Index 2 - (Expenses Show)
                      Column(
                        children: [
                          SizedBox(
                              height: 50,
                              child: CustomTableHeaderGlobal(
                                  data: const [
                                    "Select",
                                    "Expense Number",
                                    "Expense Account",
                                    "Supplier Name",
                                    "Expense Price",
                                    'Expense Note',
                                    "Expense Date",
                                  ],
                                  onDoubleTap: () {},
                                  flex: const [1, 2, 2, 2, 2, 3, 2])),
                          const ExpenseTableRows()
                        ],
                      ),
                      //! Index 3 - (Imports Show)
                      Column(
                        children: [
                          SizedBox(
                              height: 50,
                              child: CustomTableHeaderGlobal(
                                  data: const [
                                    "Select",
                                    "Import Number",
                                    "Import Account",
                                    "Import Supllier",
                                    "Import Price",
                                    'Import Note',
                                    "Import Date",
                                  ],
                                  onDoubleTap: () {},
                                  flex: const [1, 2, 2, 2, 2, 3, 2])),
                          const ImportTableRows()
                        ],
                      ),
                      //! Index 4 - (Export Show)
                      Column(
                        children: [
                          SizedBox(
                              height: 50,
                              child: CustomTableHeaderGlobal(
                                  data: const [
                                    "Select",
                                    "Export Number",
                                    "Export Account",
                                    "Export Supplier",
                                    "Export Price",
                                    'Export Note',
                                    "Export Date",
                                  ],
                                  onDoubleTap: () {},
                                  flex: const [1, 2, 2, 2, 2, 3, 2])),
                          const ExportTableRows()
                        ],
                      ),
                      //! Index 5:(Total Profi Inventory Show)
                      const CustomTotalProfitWidget(),
                      //! Index 6 - (Deptor Show)
                      Column(
                        children: [
                          SizedBox(
                              height: 50,
                              child: CustomTableHeaderGlobal(
                                  data: const [
                                    "Debtor Id",
                                    "Debtor Name",
                                    'Total Ballance',
                                  ],
                                  onDoubleTap: () {},
                                  flex: const [1, 3, 3])),
                          const DebtorTableRows()
                        ],
                      ),
                    ],
                  ),
                )),
            //! Actions Side (Right Side):
            Expanded(
                flex: 2,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                  color: primaryColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomHeaderScreen(
                        imagePath: AppImageAsset.inventoryIcons,
                        root: () {
                          Get.offAndToNamed(AppRoute.inventoryScreen);
                        },
                        title: "Inventory".tr,
                      ),
                      customSizedBox(25),
                      CustomDropDownInventory(
                        title: myServices.sharedPreferences
                                .getString("inventory_title") ??
                            "Box",
                        contrllerId: controller.catID!,
                        contrllerName: controller.catName!,
                        listData: [
                          SelectedListItem(name: "Box", value: "box"),
                          SelectedListItem(name: "Profits", value: "profits"),
                          SelectedListItem(name: "Expenses", value: "expenses"),
                          SelectedListItem(name: "Imports", value: "imports"),
                          SelectedListItem(name: "Exports", value: "exports"),
                          SelectedListItem(
                              name: "Total Profit / Invertory",
                              value: "total_profits"),
                          SelectedListItem(name: "Debtor", value: "debtor"),
                          SelectedListItem(name: "Creditor", value: "creditor"),
                        ],
                        iconData: Icons.layers,
                      ),
                      customSizedBox(),
                      Text(
                        "Invoice Number".tr,
                        style: titleStyle.copyWith(color: white, fontSize: 16),
                      ),
                      customSizedBox(5),
                      Row(children: [
                        Expanded(
                            child: CustomTextFormFieldGlobal(
                          hinttext: "From",
                          labeltext: "From",
                          mycontroller: controller.fromNOController,
                          iconData: Icons.numbers_rounded,
                          isNumber: true,
                          borderColor: white,
                          valid: (p0) {
                            return validInput(p0!, 0, 20, 'number');
                          },
                        )),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CustomTextFormFieldGlobal(
                            hinttext: "To",
                            labeltext: "To",
                            iconData: Icons.numbers_rounded,
                            mycontroller: controller.toNOController,
                            isNumber: true,
                            borderColor: white,
                            valid: (p0) {
                              return validInput(p0!, 0, 20, 'number');
                            },
                          ),
                        ),
                      ]),
                      customSizedBox(25),
                      Text(
                        "Date".tr,
                        style: titleStyle.copyWith(color: white, fontSize: 16),
                      ),
                      customSizedBox(5),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFormFieldGlobal(
                              onTap: () {
                                controller.selectDate(
                                    context, controller.fromDateController);
                              },
                              mycontroller: controller.fromDateController,
                              readOnly: true,
                              hinttext: "From",
                              labeltext: "From",
                              iconData: Icons.date_range_outlined,
                              isNumber: true,
                              borderColor: white,
                              valid: (p0) {
                                return validInput(p0!, 0, 20, 'number');
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: CustomTextFormFieldGlobal(
                              onTap: () {
                                controller.selectDate(
                                    context, controller.toDateController);
                              },
                              mycontroller: controller.toDateController,
                              readOnly: true,
                              hinttext: "To",
                              labeltext: "To",
                              iconData: Icons.date_range_outlined,
                              isNumber: true,
                              borderColor: white,
                              valid: (p0) {
                                return validInput(p0!, 0, 20, 'number');
                              },
                            ),
                          ),
                        ],
                      ),
                      customButtonGlobal(
                        () {
                          controller.searchButton(myServices.sharedPreferences
                                  .getInt("inventory_index") ??
                              0);
                        },
                        "Search",
                        Icons.search,
                        whiteNeon,
                        black,
                      ),
                      customDivider(),
                      customDivider(white),
                      customSizedBox(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Total Ballance".tr,
                            style: titleStyle.copyWith(
                                color: controller.totalInventoryPrice.isNegative
                                    ? Colors.red
                                    : white,
                                fontSize:
                                    controller.totalInventoryPrice.isNegative
                                        ? 25
                                        : 20),
                          ),
                          Text(
                            formattingNumbers(controller.totalInventoryPrice),
                            style: titleStyle.copyWith(
                                color: controller.totalInventoryPrice.isNegative
                                    ? Colors.red
                                    : white,
                                fontSize:
                                    controller.totalInventoryPrice.isNegative
                                        ? 25
                                        : 20),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
          ],
        );
      }),
    );
  }
}
