import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/constant/routes.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/responsive/responisve_text_body.dart';
import 'package:cashier_system/core/responsive/responsive_icons.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/view/cashier/components/right_side/components/payment_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CashierRightSideScreen extends StatelessWidget {
  const CashierRightSideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CashierController());
    return GetBuilder<CashierController>(builder: (controller) {
      return Expanded(
        flex: Get.width < 950 ? 1 : 2,
        child: Container(
          color: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            children: [
              //! Cashier Header Title:
              CustomHeaderScreen(
                  title: 'Cashier'.tr,
                  imagePath: AppImageAsset.cashierIcons,
                  root: () {
                    Get.offAndToNamed(AppRoute.cashierScreen);
                  }),
              customSizedBox(10),
              //! Cart Price Display:
              Expanded(
                flex: 3,
                child: Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: const Color(0xffFF204E),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Total Price'.tr,
                        style: titleStyle.copyWith(color: white, fontSize: 26),
                      ),
                      Text(
                        formattingNumbers(controller.cartTotalPrice),
                        style: titleStyle.copyWith(color: white, fontSize: 30),
                      ),
                    ],
                  ),
                ),
              ),
              customSizedBox(10),
              //! Payment Button
              Expanded(
                flex: 2,
                child: GestureDetector(
                    onTap: () {
                      customPaymentDialog();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'PAY'.tr,
                            style: titleStyle.copyWith(
                                color: primaryColor, fontSize: 36),
                          ),
                          SvgPicture.asset(
                            AppImageAsset.cashierIcons,
                            // ignore: deprecated_member_use
                            color: primaryColor,
                            width: 38,
                          ),
                        ],
                      ),
                    )),
              ),
              customSizedBox(10),
              //! Payment
              Expanded(
                flex: 11,
                child: GetBuilder<CashierController>(builder: (controller) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: Get.width > 950 ? 2 : 1,
                      mainAxisSpacing: 10,
                      childAspectRatio: Get.width > 600 ? 3.h : 3.5.h,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: controller.buttonsDetails.length,
                    itemBuilder: (context, index) {
                      bool isHovered = controller.hoverStates[index];
                      String title;
                      if (index == 10 && controller.cartData.isNotEmpty) {
                        if (controller.cartData[0].cartCash == "1") {
                          title = "Cash Payment".tr;
                        } else {
                          title = "Dept Payment".tr;
                        }
                      } else {
                        title = controller.buttonsDetails[index]['title'];
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
                              color: white,
                              border:
                                  Border.all(width: .3, color: secondColor)),
                          showDuration: const Duration(seconds: 2),
                          waitDuration: const Duration(seconds: 2),
                          exitDuration: const Duration(seconds: 2),
                          textAlign: TextAlign.center,
                          textStyle: bodyStyle.copyWith(),
                          message: controller.buttonsDetails[index]['tool_tip'],
                          child: GestureDetector(
                            onTap: () {
                              controller.buttonsDetails[index]['function'](
                                  controller.buttonsDetails[index]['title']);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 100),
                              height: 55,
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              decoration: BoxDecoration(
                                color: !isHovered
                                    ? primaryColor // controller.buttonsDetails[index]['color']
                                    : controller.buttonsDetails[index]['color'],
                                border: Border.all(color: white, width: .8),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      title.tr,
                                      style: bodyStyle.copyWith(
                                        color: white,
                                        fontSize: responsivefontSize(Get.width),
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    controller.buttonsDetails[index]['icon'],
                                    color: white,
                                    size: responsiveIconSize(Get.width),
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
          ),
        ),
      );
    });
  }
}
