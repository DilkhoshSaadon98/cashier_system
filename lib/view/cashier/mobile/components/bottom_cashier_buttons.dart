import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/dialogs/custom_snack_bar.dart';
import 'package:cashier_system/core/dialogs/snackbar_helper.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/view/cashier/mobile/components/custom_payment_dialog_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BottomCashierButtons extends StatelessWidget {
  const BottomCashierButtons({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CashierController());
    return GetBuilder<CashierController>(builder: (controller) {
      final buttonList = controller.buttonsDetails.sublist(1); // skip [0]

      return SizedBox(
        height: 200,
        child: Column(
          children: [
            Container(
              height: 45.h,
              margin: EdgeInsets.only(top: 5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Payment Button
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (controller.cartData.isNotEmpty) {
                          if ((controller.cartData[0].cartCash == "0" &&
                                  controller.cartData[0].usersName !=
                                      TextRoutes.cashAgent) ||
                              controller.cartData[0].cartCash == "1") {
                            customPaymentDialogMobile();
                          } else {
                            showErrorSnackBar(TextRoutes
                                .paymentIsDeptPleaseAddCustomerDetailsFirst);
                            controller.buttonsDetails[9]['function']!(
                                controller.buttonsDetails[9]['title']);
                          }
                        } else {
                          customSnackBar("Fail", "Empty cart");
                        }
                      },
                      child: Container(
                        height: 45.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 34, 101, 92),
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Payment".tr,
                              style: bodyStyle.copyWith(
                                fontSize: 14.sp,
                                color: white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Icon(Icons.payment, size: 30, color: white),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  // Second Button
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        controller.buttonsDetails[0]['function']!(
                            controller.buttonsDetails[0]['title']);
                      },
                      child: Container(
                        height: 45.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: secondColor,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              controller.buttonsDetails[0]['title']
                                  .toString()
                                  .tr,
                              style: bodyStyle.copyWith(
                                fontSize: 14.sp,
                                color: primaryColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Icon(Icons.pause,
                                size: 30, color: primaryColor),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: primaryColor,
                padding: EdgeInsets.all(5.w),
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: buttonList.length - 1,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 7.h,
                    crossAxisSpacing: 7.w,
                    mainAxisExtent: 45.h,
                  ),
                  itemBuilder: (context, index) {
                    final item = buttonList[index];

                    return InkWell(
                      onTap: () => item['function']!(item['title']),
                      onLongPress: item['on_long_press'],
                      child: Container(
                        height: 45.h,
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['title'].toString().tr,
                              style: bodyStyle.copyWith(
                                fontSize: 14.sp,
                                color: white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Icon(
                              item['icon'],
                              size: 30.sp,
                              color: white,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
