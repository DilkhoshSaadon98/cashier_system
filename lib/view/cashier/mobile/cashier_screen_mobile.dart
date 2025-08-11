import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/change_direction.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/view/cashier/mobile/components/bottom_cashier_buttons.dart';
import 'package:cashier_system/view/cashier/mobile/components/footer_details_widget.dart';
import 'package:cashier_system/view/cashier/mobile/components/pending_carts_mobile.dart';
import 'package:cashier_system/view/cashier/mobile/components/search_widget_mobile.dart';
import 'package:cashier_system/view/cashier/mobile/components/table_widget.dart';
import 'package:cashier_system/view/cashier/windows/action/components/export_pdf_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CashierScreenMobile extends StatelessWidget {
  const CashierScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    CashierController controller = Get.put(CashierController());
    return Scaffold(
      backgroundColor: primaryColor,
      body: GestureDetector(
        onTap: () {
          if (controller.isExpanded) {
            controller.isExpanded = false;
            controller.update();
          }
        },
        child: SafeArea(
            child: Container(
          padding: const EdgeInsets.only(left: 10, right: 5),
          height: Get.height,
          alignment: Alignment.topCenter,
          child: Stack(
            alignment: screenDirection() != TextDirection.rtl
                ? Alignment.bottomRight
                : Alignment.bottomLeft,
            children: [
              Column(
                children: [
                  //! Pending Carts List:
                  GetBuilder<CashierController>(builder: (controller) {
                    return const PendingCartsMobile();
                  }),
                  GetBuilder<CashierController>(builder: (controller) {
                    return const SearchWidgetMobile();
                  }),
                  Expanded(
                    child: GetBuilder<CashierController>(builder: (controller) {
                      return const CustomTableWidgetMobile();
                    }),
                  ),
                  verticalGap(5),
                  Container(height: 120, child: const FooterDetailsWidget()),
                  //! Buttons Fields:
                  Container(child: const BottomCashierButtons())
                ],
              ),
              GetBuilder<CashierController>(builder: (controller) {
                return Visibility(
                  visible: controller.isExpanded,
                  child: Positioned(
                    bottom: 55,
                    child: SingleChildScrollView(
                      child: Container(
                          color: primaryColor,
                          width: Get.width / 2.1,
                          height: 650.h,
                          alignment: Alignment.bottomCenter,
                          child: ListView.builder(
                              itemCount: controller.buttonsDetails.length - 3,
                              itemBuilder: (context, index) {
                                int newIndex = index + 2;
                                return GestureDetector(
                                  onLongPress: index == 11
                                      ? () {
                                          customExportPDF();
                                        }
                                      : () {},
                                  onTap: () {
                                    controller.buttonsDetails[newIndex]
                                            ['function'](
                                        controller.buttonsDetails[newIndex]
                                            ['title']);
                                    controller.expandContainer();
                                  },
                                  child: Container(
                                    height: 50,
                                    width: Get.width,
                                    margin: const EdgeInsets.all(5),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: buttonColor,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          controller.buttonsDetails[newIndex]
                                              ['icon'],
                                          size: 25,
                                          color: white,
                                        ),
                                        Text(
                                          controller.buttonsDetails[newIndex]
                                                  ['title']
                                              .toString()
                                              .tr,
                                          style: bodyStyle.copyWith(
                                              fontSize: 12,
                                              color: white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })),
                    ),
                  ),
                );
              })
            ],
          ),
        )),
      ),
    );
  }
}
