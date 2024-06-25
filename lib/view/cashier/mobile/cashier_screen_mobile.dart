import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/view/cashier/mobile/components/pending_carts_mobile.dart';
import 'package:cashier_system/view/cashier/mobile/components/search_widget_mobile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CashierScreenMobile extends StatelessWidget {
  const CashierScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CashierController());
    return Scaffold(
      body: GetBuilder<CashierController>(builder: (controller) {
        return SizedBox(
          height: Get.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const PendingCartsMobile(),
              const SearchWidgetMobile(),
              Expanded(
                  flex: 4,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: DataTable(
                          border: TableBorder.all(width: .5),
                          headingRowColor: WidgetStatePropertyAll(primaryColor),
                          columns: [
                            DataColumn(
                              headingRowAlignment: MainAxisAlignment.center,
                              label: Text(
                                "Item Name",
                                style: titleStyle.copyWith(color: white),
                              ),
                            ),
                            DataColumn(
                              headingRowAlignment: MainAxisAlignment.center,
                              label: Text(
                                "Item Price",
                                style: titleStyle.copyWith(color: white),
                              ),
                            ),
                            DataColumn(
                              headingRowAlignment: MainAxisAlignment.center,
                              label: Text(
                                "QTY",
                                style: titleStyle.copyWith(color: white),
                              ),
                            ),
                            DataColumn(
                              headingRowAlignment: MainAxisAlignment.center,
                              label: Text(
                                "Total Price",
                                style: titleStyle.copyWith(color: white),
                              ),
                            ),
                            DataColumn(
                              headingRowAlignment: MainAxisAlignment.center,
                              label: Text(
                                "Item Code",
                                style: titleStyle.copyWith(color: white),
                              ),
                            ),
                            DataColumn(
                              headingRowAlignment: MainAxisAlignment.center,
                              label: Text(
                                "Type",
                                style: titleStyle.copyWith(color: white),
                              ),
                            ),
                            DataColumn(
                              headingRowAlignment: MainAxisAlignment.center,
                              label: Text(
                                "Stack",
                                style: titleStyle.copyWith(color: white),
                              ),
                            ),
                          ],
                          rows: [
                            ...List<DataRow>.generate(
                                controller.cartData.length, (index) {
                              var dataItem = controller.cartData[index];
                              return DataRow(cells: [
                                DataCell(Text(
                                  dataItem.itemsName!,
                                  style: bodyStyle,
                                )),
                                DataCell(Text(
                                  formattingNumbers(dataItem.itemsSellingprice),
                                  style: bodyStyle,
                                )),
                                DataCell(Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: IconButton(
                                          onPressed: () {
                                            controller.cartItemDecrease(
                                                controller.cartData[index]
                                                    .cartItemsCount!,
                                                controller
                                                    .cartData[index].itemsId
                                                    .toString());
                                          },
                                          icon: const Icon(
                                            Icons.remove,
                                            color: Colors.red,
                                          )),
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: TextFormField(
                                          onFieldSubmitted: (value) {
                                            controller.updateItemNumber(
                                                controller
                                                    .cartData[index].itemsId
                                                    .toString(),
                                                value);
                                          },
                                          cursorOpacityAnimates: true,
                                          textAlign: TextAlign
                                              .center, // Align text to the center
                                          style:
                                              titleStyle.copyWith(fontSize: 20),
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 10),
                                            hintText: controller
                                                .cartData[index].cartItemsCount
                                                .toString(),
                                            hintStyle: titleStyle.copyWith(
                                                fontSize: 20),
                                            border: InputBorder
                                                .none, // Remove border to make circle visible
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: IconButton(
                                          onPressed: () {
                                            if (controller.cartData[index]
                                                    .itemsCount! >
                                                controller.cartData[index]
                                                    .cartItemsCount!) {
                                              controller.cartItemIncrease(
                                                  controller.cartData[index]
                                                      .cartItemsCount!,
                                                  controller
                                                      .cartData[index].itemsId
                                                      .toString());
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.add,
                                            color: Colors.green,
                                          )),
                                    ),
                                  ],
                                )),
                                DataCell(Text(
                                  formattingNumbers(controller.totalItemsPrice(
                                      dataItem.itemsSellingprice!,
                                      dataItem.cartItemsCount!,
                                      dataItem.cartItemDiscount!)),
                                  style: bodyStyle,
                                )),
                                DataCell(Text(
                                  dataItem.itemsId!.toString(),
                                  style: bodyStyle,
                                )),
                                DataCell(Text(
                                  dataItem.itemsType.toString(),
                                  style: bodyStyle,
                                )),
                                DataCell(Text(
                                  dataItem.itemsCount!.toString(),
                                  style: bodyStyle,
                                )),
                              ]);
                            })
                          ]),
                    ),
                  )),
              Expanded(
                  flex: 2,
                  child: Container(
                    color: primaryColor,
                  )),
              Expanded(
                  flex: 2,
                  child: Container(
                    color: white,
                  )),
            ],
          ),
        );
      }),
    );
  }
}
