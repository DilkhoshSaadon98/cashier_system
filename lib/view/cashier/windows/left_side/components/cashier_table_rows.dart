import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/core/class/handlingdataview.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/routes.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/functions/show_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CashierTableRows extends StatelessWidget {
  const CashierTableRows({super.key});

  @override
  Widget build(BuildContext context) {
    final CustomShowPopupMenu customShowPopupMenu = CustomShowPopupMenu();
    Get.put(CashierController());
    return GetBuilder<CashierController>(builder: (controller) {
      return myServices.sharedPreferences.getBool("start_new_cart") == true
          ? Expanded(
              flex: 10,
              child: Container(
                  width: Get.width,
                  alignment: Alignment.center,
                  color: white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Please choose items or scanning a barcode".tr,
                        style: titleStyle.copyWith(fontSize: 20),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(Icons.qr_code_2)
                    ],
                  )))
          : HandlingDataView(
              statusRequest: controller.statusRequest,
              widget: Expanded(
                  flex: 10,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: white,
                    ),
                    alignment: Alignment.topCenter,
                    child: ListView.builder(
                        itemCount: controller.cartData.length,
                        itemBuilder: (context, index) {
                          var dataItem = controller.cartData[index];
                          return GestureDetector(
                            onDoubleTap: () {
                              controller.checkSelectedRows(
                                  controller.checkValue, index);
                              controller.checkValueFunction();
                            },
                            onTapDown: customShowPopupMenu.storeTapPosition,
                            onTap: () {
                              customShowPopupMenu.showPopupMenu(context, [
                                "View",
                                "Edit",
                                "Remove"
                              ], [
                                () async {},
                                () async {
                                  await controller.getItemsById(
                                      dataItem.itemsId.toString());
                                  Get.toNamed(AppRoute.itemsUpdateScreen,
                                      arguments: {
                                        "itemsModel": controller.dataItem[0],
                                        "screen_route": AppRoute.cashierScreen
                                      });
                                },
                                () {
                                  controller.deleteCartItem(
                                      [dataItem.itemsId.toString()]);
                                }
                              ]);
                            },
                            child: Container(
                              height: 40,
                              alignment: Alignment.topCenter,
                              color: white,
                              child: ListView(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: dataItem.cartItemGift == 1
                                          ? const Color(0xffD6589F)
                                              .withOpacity(0.3)
                                          : tableRowColor,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        //! Check Items
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            height: 40,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: .3,
                                                    color: primaryColor)),
                                            child: Checkbox(
                                              value: controller.selectedRows
                                                  .contains(controller
                                                      .cartData[index].itemsId
                                                      .toString()),
                                              onChanged: (value) {
                                                controller.checkSelectedRows(
                                                    value!, index);
                                              },
                                            ),
                                          ),
                                        ),
                                        //! Items Code
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            height: 40,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: .3,
                                                    color: primaryColor)),
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              "${dataItem.itemsId}",
                                              style: titleStyle,
                                            ),
                                          ),
                                        ),
                                        //! Items Name
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            height: 40,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: .3,
                                                    color: primaryColor)),
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              dataItem.itemsName.toString(),
                                              style: titleStyle,
                                            ),
                                          ),
                                        ),
                                        //! Items Type
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                              height: 40,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: .3,
                                                      color: primaryColor)),
                                              child: Text(
                                                textAlign: TextAlign.center,
                                                dataItem.itemsType.toString(),
                                                style: titleStyle,
                                              )),
                                        ),
                                        //! Items Price
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                              height: 40,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: .3,
                                                      color: primaryColor)),
                                              child: Text(
                                                textAlign: TextAlign.center,
                                                formattingNumbers(
                                                    dataItem.itemsSellingprice),
                                                style: titleStyle,
                                              )),
                                        ),
                                        //! Items Discount
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                              height: 40,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: .3,
                                                      color: primaryColor)),
                                              child: Text(
                                                textAlign: TextAlign.center,
                                                formattingNumbers(((100 -
                                                            dataItem
                                                                .cartItemDiscount!) /
                                                        100) *
                                                    int.parse(dataItem
                                                        .itemsSellingprice
                                                        .toString())),
                                                style: titleStyle.copyWith(
                                                    color: secondColor),
                                              )),
                                        ),
                                        //! Items Stack
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                              height: 40,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: .3,
                                                      color: primaryColor)),
                                              child: Text(
                                                textAlign: TextAlign.center,
                                                dataItem.itemsCount.toString(),
                                                style: titleStyle,
                                              )),
                                        ),
                                        //! Items Total Price
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            height: 40,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: .3,
                                                    color: primaryColor)),
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              formattingNumbers(
                                                  controller.totalItemsPrice(
                                                      dataItem
                                                          .itemsSellingprice!,
                                                      dataItem.cartItemsCount!,
                                                      dataItem
                                                          .cartItemDiscount!)),
                                              style: titleStyle,
                                            ),
                                          ),
                                        ),
                                        //! Items Quantity
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            height: 40,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: .3,
                                                    color: primaryColor)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: IconButton(
                                                      onPressed: () {
                                                        controller.cartItemDecrease(
                                                            controller
                                                                .cartData[index]
                                                                .cartItemsCount!,
                                                            controller
                                                                .cartData[index]
                                                                .itemsId
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
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: TextFormField(
                                                      onFieldSubmitted:
                                                          (value) {
                                                        controller
                                                            .updateItemNumber(
                                                                controller
                                                                    .cartData[
                                                                        index]
                                                                    .itemsId
                                                                    .toString(),
                                                                value);
                                                      },
                                                      cursorOpacityAnimates:
                                                          true,
                                                      textAlign: TextAlign
                                                          .center, // Align text to the center
                                                      style:
                                                          titleStyle.copyWith(
                                                              fontSize: 20),
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 10),
                                                        hintText: controller
                                                            .cartData[index]
                                                            .cartItemsCount
                                                            .toString(),
                                                        hintStyle:
                                                            titleStyle.copyWith(
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
                                                        if (controller
                                                                .cartData[index]
                                                                .itemsCount! >
                                                            controller
                                                                .cartData[index]
                                                                .cartItemsCount!) {
                                                          controller.cartItemIncrease(
                                                              controller
                                                                  .cartData[
                                                                      index]
                                                                  .cartItemsCount!,
                                                              controller
                                                                  .cartData[
                                                                      index]
                                                                  .itemsId
                                                                  .toString());
                                                        }
                                                      },
                                                      icon: const Icon(
                                                        Icons.add,
                                                        color: Colors.green,
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  )),
              flex: 10);
    });
  }
}
