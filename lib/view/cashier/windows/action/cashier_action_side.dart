import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/dialogs/snackbar_helper.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/view/cashier/windows/action/components/payment_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CashierActionSide extends StatelessWidget {
  const CashierActionSide({super.key});

  @override
  Widget build(BuildContext context) {
    CashierController controller = Get.put(CashierController());
    return ListView(
      children: [
        //! Cashier Header Title:
        CustomHeaderScreen(
          title: TextRoutes.cashier.tr,
          imagePath: AppImageAsset.cashierIcons,
        ),
        verticalGap(10.h),
        //! Cart Price Display:
        Container(
          width: Get.width,
          height: 100.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: secondColor,
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                TextRoutes.totalPrice.tr,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: titleStyle.copyWith(
                  color: primaryColor,
                  fontSize: 20.sp,
                ),
              ),
              GetBuilder<CashierController>(builder: (controller) {
                return Text(
                  formattingNumbers(controller.cartTotalPrice),
                  overflow: TextOverflow.clip,
                  maxLines: 1,
                  style: titleStyle.copyWith(
                    color: primaryColor,
                    fontSize: 25.sp,
                  ),
                );
              }),
            ],
          ),
        ),
        verticalGap(10.h),
        //! Payment Button
        SizedBox(
          height: 75.h,
          child: GestureDetector(
              onTap: () {
                if (controller.cartData.isNotEmpty) {
                  if (controller.cartData[0].cartCash == TextRoutes.cash ||
                      (controller.cartData[0].cartCash == TextRoutes.dept &&
                          controller.cartData[0].cartOwnerId!.isNotEmpty)) {
                    customPaymentDialog();
                  } else {
                    showErrorSnackBar(TextRoutes.deptPaymentSelectCustomer);
                    controller.buttonsDetails[9]
                        ['function'](controller.buttonsDetails[9]['title']);
                  }
                } else {
                  showErrorSnackBar(TextRoutes.emptyCart);
                }
              },
              child: Container(
                alignment: Alignment.center,
                width: Get.width,
                decoration: BoxDecoration(
                  color: const Color(0xffFFF5E4),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        TextRoutes.pay.tr,
                        style: titleStyle.copyWith(fontSize: 36),
                      ),
                      const SizedBox(
                        width: 100,
                      ),
                      SvgPicture.asset(
                        AppImageAsset.cashierIcons,
                        // ignore: deprecated_member_use
                        color: primaryColor,
                        width: 38,
                      ),
                    ],
                  ),
                ),
              )),
        ),
        verticalGap(),
        //! Payment Options
        SizedBox(
          height: 500.h,
          child: GetBuilder<CashierController>(builder: (controller) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.h,
                  crossAxisSpacing: 10.w,
                  mainAxisExtent: 45),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.buttonsDetails.length,
              itemBuilder: (context, index) {
                bool isHovered = controller.hoverStates[index];
                String title = controller.buttonsDetails[index]['title'];
                if (index == 11 && controller.cartData.isNotEmpty) {
                  title = controller.cartData[0].cartCash.tr;
                }
                return MouseRegion(
                  onEnter: (_) {
                    controller.setHoverState(index, true);
                  },
                  onExit: (_) {
                    controller.setHoverState(index, false);
                  },
                  child: Tooltip(
                    decoration: BoxDecoration(
                        color: primaryColor,
                        border: Border.all(width: 0.3, color: secondColor)),
                    waitDuration: const Duration(seconds: 2),
                    showDuration: const Duration(seconds: 2),
                    textAlign: TextAlign.center,
                    textStyle: bodyStyle.copyWith(color: white),
                    message: controller.buttonsDetails[index]['tool_tip'],
                    child: GestureDetector(
                      onLongPress: () {
                        final onLongPressCallback =
                            controller.buttonsDetails[index]['on_long_press'];
                        if (onLongPressCallback != null) {
                          onLongPressCallback();
                        }
                      },
                      onTap: () {
                        controller.buttonsDetails[index]['function'](
                            controller.buttonsDetails[index]['title']);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 50),
                        height: 60.h,
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        decoration: BoxDecoration(
                          color: !isHovered
                              ? buttonColor
                              : controller.buttonsDetails[index]['color'],
                          border: Border.all(color: white, width: 0.5),
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                title.tr,
                                maxLines: 1,
                                style: bodyStyle.copyWith(
                                  color: white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Icon(
                              controller.buttonsDetails[index]['icon'],
                              color: white,
                              size: 25,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
