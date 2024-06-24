import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class QuantityFieldWidget extends GetView<CashierController> {
  final int index;
  const QuantityFieldWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    Get.put(CashierController());
    return GetBuilder<CashierController>(builder: (controller) {
      return Container(
        width: 150.w,
        height: 40,
        alignment: Alignment.center,
        decoration:
            BoxDecoration(border: Border.all(width: .3, color: primaryColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  controller.cartItemDecrease(
                      controller.cartData[index].cartItemsCount!,
                      controller.cartData[index].itemsId.toString());
                },
                icon: const Icon(
                  Icons.remove,
                  color: Colors.red,
                )),
            Container(
              width: 50,
              height: 40,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: TextFormField(
                initialValue:
                    controller.cartData[index].cartItemsCount.toString(),
                onChanged: (value) {
                  // controller.updateItemByNum(
                  //   controller.cartData[index].itemsId.toString(),
                  //   value,
                  // );
                },
                cursorOpacityAnimates: true,
                textAlign: TextAlign.center,
                style: titleStyle.copyWith(fontSize: 20),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  hintStyle: titleStyle.copyWith(fontSize: 20),
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  controller.cartItemIncrease(
                      controller.cartData[index].cartItemsCount!,
                      controller.cartData[index].itemsId.toString());
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.green,
                )),
          ],
        ),
      );
    });
  }
}
