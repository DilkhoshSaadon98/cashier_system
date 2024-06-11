import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomPendingCarts extends GetView<CashierController> {
  const CustomPendingCarts({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CashierController());
    return GetBuilder<CashierController>(builder: (controller) {
      return Expanded(
        flex: 3,
        child: Container(
          height: 45,
          margin: EdgeInsets.symmetric(horizontal: 15.h),
          padding: EdgeInsets.symmetric(
            horizontal: 5.w,
          ),
          decoration: BoxDecoration(
              color: white, borderRadius: BorderRadius.circular(5.r)),
          child: ListView.builder(
              itemCount: controller.cartsNumbers.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                int selectedIndex = controller.cartsNumbers[index];
                String? storedCartNumber = controller
                    .myServices.systemSharedPreferences
                    .getString("cart_number");
                int storedCartNumberInt = storedCartNumber != null
                    ? int.tryParse(storedCartNumber) ?? 0
                    : 0;
                Color color;
                if (controller.cartData.isNotEmpty &&
                    selectedIndex == storedCartNumberInt &&
                    controller.cartData[0].cartUpdate == 1) {
                  color = Colors.red;
                } else if (selectedIndex == storedCartNumberInt) {
                  color = secondColor;
                } else {
                  color = primaryColor;
                }
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.myServices.systemSharedPreferences
                            .setBool("start_new_cart", false);
                        controller.myServices.systemSharedPreferences.setString(
                            "cart_number",
                            controller.cartsNumbers[index].toString());
                        controller.getCartData(
                            controller.cartsNumbers[index].toString());
                        controller.selectedRows.clear();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: color,
                            border: Border.all(color: white),
                            borderRadius: BorderRadius.circular(10.r)),
                        margin: EdgeInsets.symmetric(horizontal: 5.w),
                        width: 50.w,
                        alignment: Alignment.center,
                        child: Text(
                          "${index + 1}",
                          style: titleStyle.copyWith(
                              color: white, fontSize: 30.sp),
                        ),
                      ),
                    ),
                    myServices.sharedPreferences.getBool("start_new_cart") ==
                                true &&
                            index + 1 == controller.pendedCarts.length
                        ? Container(
                            decoration: BoxDecoration(
                                color: secondColor,
                                border: Border.all(color: white),
                                borderRadius: BorderRadius.circular(10.r)),
                            margin: EdgeInsets.symmetric(horizontal: 5.w),
                            width: 50.w,
                            alignment: Alignment.center,
                            child: Text(
                              "${index + 2}",
                              style: titleStyle.copyWith(
                                  color: white, fontSize: 30.sp),
                            ),
                          )
                        : Container()
                  ],
                );
              }),
        ),
      );
    });
  }
}
