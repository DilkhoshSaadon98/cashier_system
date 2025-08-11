import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/screen_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PendingCartsMobile extends StatelessWidget {
  const PendingCartsMobile({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CashierController());
    return GetBuilder<CashierController>(builder: (controller) {
      return SizedBox(
          width: Get.width,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: white,
                    border: Border.all(width: 1, color: primaryColor),
                    borderRadius: BorderRadius.circular(5)),
                child: IconButton(
                    onPressed: () {
                      Get.toNamed(AppRoute.homeScreen);
                    },
                    icon: const Icon(
                      Icons.home,
                      color: primaryColor,
                      size: 30,
                    )),
              ),
              const SizedBox(
                width: 5,
              ),
              controller.pendedCarts.isNotEmpty
                  ? Expanded(
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 5.w),
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: primaryColor),
                          color: white,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: ListView.builder(
                          itemCount: controller.fixedCartNumbers.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            int cartNumber = controller.fixedCartNumbers[index];

                            String? storedCartNumber = controller
                                .myServices.systemSharedPreferences
                                .getString("cart_number");

                            int storedCartNumberInt = storedCartNumber != null
                                ? int.tryParse(storedCartNumber) ?? 0
                                : 0;

                            Color color;
                            if (controller.cartData.isNotEmpty &&
                                cartNumber == storedCartNumberInt &&
                                controller.cartData[0].cartUpdate == 1) {
                              color = Colors.red;
                            } else if (cartNumber == storedCartNumberInt) {
                              color = secondColor;
                            } else if (controller.cartsNumbers
                                .contains(cartNumber)) {
                              color = Colors.blue;
                            } else {
                              color = primaryColor;
                            }
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    controller
                                        .myServices.systemSharedPreferences
                                        .setBool("start_new_cart", false);
                                    controller
                                        .myServices.systemSharedPreferences
                                        .setString("cart_number",
                                            cartNumber.toString());
                                    controller
                                        .getCartData(cartNumber.toString());
                                    controller.selectedRows.clear();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: color,
                                      border: Border.all(color: white),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 5.w),
                                    width: 45.w,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "$cartNumber",
                                      style: titleStyle.copyWith(color: white),
                                    ),
                                  ),
                                ),
                                controller.myServices.systemSharedPreferences
                                                .getBool("start_new_cart") ==
                                            true &&
                                        index + 1 ==
                                            controller.fixedCartNumbers.length
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: secondColor,
                                          border: Border.all(color: white),
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5.w),
                                        width: 45.w,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${cartNumber + 1}",
                                          style:
                                              titleStyle.copyWith(color: white),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            );
                          },
                        ),
                      ),
                    )
                  : Container(
                      width: Get.width - 75,
                      alignment: Alignment.center,
                      height: 50,
                      decoration: BoxDecoration(
                          color: white,
                          border: Border.all(color: primaryColor, width: .8),
                          borderRadius: BorderRadius.circular(5.r)),
                      child: Text(
                        "Empty cart".tr,
                        style: titleStyle.copyWith(color: primaryColor),
                      ),
                    ),
            ],
          ));
    });
  }
}
