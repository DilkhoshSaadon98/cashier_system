import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/view/cashier/mobile/components/pending_carts_mobile.dart';
import 'package:cashier_system/view/cashier/mobile/components/search_widget_mobile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CashierScreenMobile extends StatelessWidget {
  const CashierScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CashierController());
    return SafeArea(
      child: Scaffold(
        backgroundColor: white, // Colors.grey[300],
        body: GetBuilder<CashierController>(builder: (controller) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            height: Get.height,
            child: Column(
              children: [
                //! Pendeing Carts List:
                const PendingCartsMobile(),
                const SearchWidgetMobile(),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                      child: DataTable(
                    columnSpacing: 50,
                    headingRowHeight: 50,
                    border: TableBorder.all(width: 0.5),
                    headingRowColor: WidgetStatePropertyAll(primaryColor),
                    columns: [
                      DataColumn(
                        headingRowAlignment: MainAxisAlignment.center,
                        label: Text(
                          "Item Name",
                          style: titleStyle.copyWith(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        headingRowAlignment: MainAxisAlignment.center,
                        label: Text(
                          "Item Price",
                          style: titleStyle.copyWith(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        headingRowAlignment: MainAxisAlignment.center,
                        label: Text(
                          "QTY",
                          style: titleStyle.copyWith(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        headingRowAlignment: MainAxisAlignment.center,
                        label: Text(
                          "Total Price",
                          style: titleStyle.copyWith(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        headingRowAlignment: MainAxisAlignment.center,
                        label: Text(
                          "Item Code",
                          style: titleStyle.copyWith(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        headingRowAlignment: MainAxisAlignment.center,
                        label: Text(
                          "Type",
                          style: titleStyle.copyWith(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        headingRowAlignment: MainAxisAlignment.center,
                        label: Text(
                          "Stack",
                          style: titleStyle.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                    rows: [
                      ...List<DataRow>.generate(controller.cartData.length,
                          (index) {
                        var dataItem = controller.cartData[index];
                        return DataRow(cells: [
                          DataCell(Text(
                            dataItem.itemsName ?? "",
                            style: bodyStyle,
                          )),
                          DataCell(Text(
                            formattingNumbers(dataItem.itemsSellingprice ?? 0),
                            style: bodyStyle,
                          )),
                          DataCell(Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: IconButton(
                                  onPressed: () {
                                    controller.cartItemDecrease(
                                      controller
                                          .cartData[index].cartItemsCount!,
                                      controller.cartData[index].itemsId
                                          .toString(),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.remove,
                                    color: Colors.red,
                                  ),
                                ),
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
                                        controller.cartData[index].itemsId
                                            .toString(),
                                        value,
                                      );
                                    },
                                    cursorOpacityAnimates: true,
                                    textAlign: TextAlign.center,
                                    style: titleStyle.copyWith(fontSize: 20),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 12),
                                      hintText: controller
                                          .cartData[index].cartItemsCount
                                          .toString(),
                                      hintStyle:
                                          titleStyle.copyWith(fontSize: 20),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  onPressed: () {
                                    if (controller.cartData[index].itemsCount! >
                                        controller
                                            .cartData[index].cartItemsCount!) {
                                      controller.cartItemIncrease(
                                        controller
                                            .cartData[index].cartItemsCount!,
                                        controller.cartData[index].itemsId
                                            .toString(),
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          )),
                          DataCell(Text(
                            formattingNumbers(
                              controller.totalItemsPrice(
                                dataItem.itemsSellingprice!,
                                dataItem.cartItemsCount!,
                                dataItem.cartItemDiscount!,
                              ),
                            ),
                            style: bodyStyle,
                          )),
                          DataCell(Text(
                            dataItem.itemsId?.toString() ?? "",
                            style: bodyStyle,
                          )),
                          DataCell(Text(
                            dataItem.itemsType?.toString() ?? "",
                            style: bodyStyle,
                          )),
                          DataCell(Text(
                            dataItem.itemsCount?.toString() ?? "",
                            style: bodyStyle,
                          )),
                        ]);
                      }),
                    ],
                  )),
                ),
                Container(
                  height: 40,
                  decoration:
                      BoxDecoration(border: Border.all(color: primaryColor)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          alignment:
                              myServices.sharedPreferences.getString("lang") ==
                                      "en"
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                          color: primaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            controller.cashierFooter[0],
                            style:
                                titleStyle.copyWith(color: white, fontSize: 12),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child:
                                  Text(controller.cartItemsCount.toString()))),
                      Expanded(
                        child: Container(
                          height: 50,
                          alignment:
                              myServices.sharedPreferences.getString("lang") ==
                                      "en"
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                          color: primaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            controller.cashierFooter[1],
                            style:
                                titleStyle.copyWith(color: white, fontSize: 12),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          controller.cartData[0].cartOwner!,
                          style: titleStyle.copyWith(
                              color: primaryColor, fontSize: 12),
                        ),
                      ))
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  decoration:
                      BoxDecoration(border: Border.all(color: primaryColor)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          alignment:
                              myServices.sharedPreferences.getString("lang") ==
                                      "en"
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                          color: primaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            controller.cashierFooter[2],
                            style:
                                titleStyle.copyWith(color: white, fontSize: 12),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                  controller.maxInvoiceNumber.toString()))),
                      Expanded(
                        child: Container(
                          height: 50,
                          alignment:
                              myServices.sharedPreferences.getString("lang") ==
                                      "en"
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                          color: primaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            controller.cashierFooter[3],
                            style:
                                titleStyle.copyWith(color: white, fontSize: 12),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          formattingNumbers(
                              controller.cartData[0].cartDiscount!),
                          style: titleStyle.copyWith(
                              color: primaryColor, fontSize: 12),
                        ),
                      ))
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  decoration:
                      BoxDecoration(border: Border.all(color: primaryColor)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          alignment:
                              myServices.sharedPreferences.getString("lang") ==
                                      "en"
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                          color: primaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            controller.cashierFooter[4],
                            style:
                                titleStyle.copyWith(color: white, fontSize: 12),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                controller.cartData[0].cartTax ?? "0",
                                style: titleStyle.copyWith(fontSize: 12),
                              ))),
                      Expanded(
                        child: Container(
                          height: 50,
                          alignment:
                              myServices.sharedPreferences.getString("lang") ==
                                      "en"
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                          color: primaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            controller.cashierFooter[5],
                            style:
                                titleStyle.copyWith(color: white, fontSize: 12),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          myServices.sharedPreferences
                                  .getString("admin_username") ??
                              "Admin",
                          style: titleStyle.copyWith(
                              color: primaryColor, fontSize: 12),
                        ),
                      ))
                    ],
                  ),
                ),
                Expanded(
                    child: GridView.builder(
                  itemCount: 6,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 3, crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(5),
                      color: primaryColor,
                    );
                  },
                ))
                // Expanded(
                //   child:
                //    Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Expanded(
                //         flex: 2,
                //         child: customButtonGlobal(
                //           () {},
                //           "Pay",
                //           Icons.payment,
                //           Colors.teal,
                //           white,
                //         ),
                //       ),
                //       Expanded(
                //         child: customButtonGlobal(
                //           () {},
                //           "Pay",
                //           Icons.pause,
                //           secondColor,
                //           white,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Expanded(
                //       flex: 1,
                //       child: customButtonGlobal(
                //         () {},
                //         "Discount",
                //         Icons.discount,
                //         thirdColor,
                //         white,
                //       ),
                //     ),
                //     Expanded(
                //       child: customButtonGlobal(
                //         () {},
                //         "Print",
                //         Icons.print,
                //         thirdColor,
                //         white,
                //       ),
                //     ),
                //   ],
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Expanded(
                //       child: customButtonGlobal(
                //         () {},
                //         "QTY",
                //         Icons.payment,
                //         thirdColor,
                //         white,
                //       ),
                //     ),
                //     Expanded(
                //       child: customButtonGlobal(
                //         () {},
                //         "Expand",
                //         Icons.expand_less_sharp,
                //         Colors.redAccent,
                //         white,
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
