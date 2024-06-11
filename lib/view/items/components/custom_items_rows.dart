 

import 'package:cashier_system/controller/items/items_view_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/functions/show_popup_menu.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class CustomItemsTableRows extends GetView<ItemsViewController> {
  // ignore: prefer_typing_uninitialized_variables
  var dataItem;
  final Color color;
  CustomItemsTableRows({super.key, this.dataItem, required this.color});

  @override
  Widget build(BuildContext context) {
    final CustomShowPopupMenu customShowPopupMenu = CustomShowPopupMenu();
    Get.put(ItemsViewController());
    return InkWell(
      onTapDown: customShowPopupMenu.storeTapPosition,
      onTap: () => customShowPopupMenu.showPopupMenu(context, [
        "View Item".tr,
        "Edit Item".tr,
        "Delete Item".tr
      ], [
        () async {
          await controller.getItemTransaction(dataItem.itemsId.toString());
          Get.defaultDialog(
            title: "Item Transaction",
            titleStyle: titleStyle,
            content: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  customSizedBox(25),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                        itemCount: controller.purchaesData.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              controller.updateItemPrice(
                                dataItem.itemsId.toString(),
                                controller.purchaesData[index].purchasePrice
                                    .toString(),
                                controller.purchaesData[index].sellingPrice
                                    .toString(),
                              );
                              Get.back();
                            },
                            child: Card(
                              child: ListTile(
                                leading: Text(
                                  "${index + 1}",
                                  style: titleStyle,
                                ),
                                title: Text(
                                  "Selling Price: ${formattingNumbers(controller.purchaesData[index].sellingPrice)}",
                                  style: titleStyle,
                                ),
                                subtitle: Text(
                                  "Purshaes Price: ${formattingNumbers(controller.purchaesData[index].purchasePrice)}",
                                  style: bodyStyle,
                                ),
                                trailing: Text(
                                  "QTY - ${controller.purchaesData[index].purchaseQuantity}",
                                  style: bodyStyle,
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
          );
        },
        () {
          controller.goUpdateItems(dataItem);
        },
        () {
          controller.deleteItems(dataItem.itemsId.toString());
        }
      ]),
      child: Container(
        decoration: BoxDecoration(
          color: tableRowColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //! Items Number
            Expanded(
              flex: 1,
              child: Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(width: .3, color: primaryColor)),
                child: Text(
                  textAlign: TextAlign.center,
                  "${int.parse(dataItem.itemsId.toString())}",
                  style: bodyStyle,
                ),
              ),
            ),
            //! Items Barcode
            Expanded(
              flex: 2,
              child: Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(width: .3, color: primaryColor)),
                child: Text(
                  textAlign: TextAlign.center,
                  dataItem.itemsBarcode.toString(),
                  style: bodyStyle,
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
                    border: Border.all(width: .3, color: primaryColor)),
                child: Text(
                  textAlign: TextAlign.center,
                  dataItem.itemsName.toString(),
                  style: bodyStyle,
                ),
              ),
            ),
            //! Items QTY
            Expanded(
              flex: 1,
              child: Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(width: .3, color: primaryColor)),
                child: Text(
                  textAlign: TextAlign.center,
                  dataItem.itemsQTY.toString(),
                  style: bodyStyle,
                ),
              ),
            ),
            //! Items Selling Price
            Expanded(
              flex: 2,
              child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(width: .3, color: primaryColor)),
                  child: Text(
                    textAlign: TextAlign.center,
                    formattingNumbers(
                        int.parse(dataItem.itemsSellingprice.toString())),
                    style: bodyStyle,
                  )),
            ),
            //! Items Buiing Price
            Expanded(
              flex: 2,
              child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(width: .3, color: primaryColor)),
                  child: Text(
                    textAlign: TextAlign.center,
                    formattingNumbers(
                        int.parse(dataItem.itemsBuingprice.toString())),
                    style: bodyStyle,
                  )),
            ),
            //! Items Cost Price
            Expanded(
              flex: 2,
              child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(width: .3, color: primaryColor)),
                  child: Text(
                    textAlign: TextAlign.center,
                    formattingNumbers(
                        int.parse(dataItem.itemsCostprice.toString())),
                    style: bodyStyle,
                  )),
            ),
            //! Items Type
            Expanded(
              flex: 1,
              child: Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(width: .3, color: primaryColor)),
                child: Text(
                  textAlign: TextAlign.center,
                  dataItem.typeName.toString(),
                  style: bodyStyle,
                ),
              ),
            ),
            //! Items Categories
            Expanded(
              flex: 2,
              child: Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(width: .3, color: primaryColor)),
                child: Text(
                  textAlign: TextAlign.center,
                  dataItem.categoriesName.toString(),
                  style: bodyStyle,
                ),
              ),
            ),
            //! Items Explain
            Expanded(
              flex: 2,
              child: Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(width: .3, color: primaryColor)),
                child: Text(
                  textAlign: TextAlign.center,
                  dataItem.itemsDesc.toString(),
                  style: bodyStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
