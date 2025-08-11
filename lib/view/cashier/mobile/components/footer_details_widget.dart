import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FooterDetailsWidget extends StatelessWidget {
  const FooterDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CashierController());
    return GetBuilder<CashierController>(builder: (controller) {
      return Column(
        children: [
          _buildFooterRow(
            controller: controller,
            //? Left text title
            leftText: controller.cashierFooter[0].tr,
            leftColor: buttonColor,
            leftCenterText: controller.cartItemsCount.toString(),
            centerColor: Colors.grey[200]!,

            //? Right text title
            rightText: controller.cashierFooter[1].tr,
            rightCenterText: controller.cartData.isNotEmpty
                ? controller.cartData[0].usersName.toString().tr
                : TextRoutes.cashAgent.tr,
            rightColor: buttonColor,
            rightTextColor: white,
          ),
          _buildFooterRow(
            controller: controller,
            //? Left text title
            leftText: controller.cashierFooter[2].tr,
            leftColor: buttonColor,
            leftCenterText: controller.maxInvoiceNumber.toString(),
            centerColor: white,
            //? Right text title
            rightText: controller.cashierFooter[3].tr,
            rightCenterText:
                "${controller.cartData.isEmpty ? 0 : controller.cartData[0].cartDiscount ?? 0}",
            rightColor: buttonColor,
            rightTextColor: white,
          ),
          _buildFooterRow(
            controller: controller,
            //? Left text title
            leftText: controller.cashierFooter[4].tr,
            leftColor: buttonColor,
            leftCenterText:
                "${controller.cartData.isEmpty ? 0 : controller.cartData[0].cartTax ?? 0}",
            centerColor: white,
            //? Right text title
            rightText: controller.cashierFooter[5].tr,
            rightCenterText:
                myServices.sharedPreferences.getString("admins_name") ??
                    "Admin",
            rightColor: buttonColor,
            rightTextColor: white,
          ),
        ],
      );
    });
  }

  Widget _buildFooterRow({
    required CashierController controller,
    required String leftText,
    required Color leftColor,
    required String leftCenterText,
    required Color centerColor,
    required String rightText,
    required String rightCenterText,
    required Color rightColor,
    Color rightTextColor = primaryColor,
  }) {
    return Container(
      height: 40,
      decoration: BoxDecoration(border: Border.all(color: primaryColor)),
      child: Row(
        children: [
          _buildFooterCell(text: leftText, color: leftColor, textColor: white),
          _buildFooterCell(text: leftCenterText, color: centerColor),
          _buildFooterCell(
              text: rightText, color: rightColor, textColor: rightTextColor),
          _buildFooterCell(
            text: rightCenterText,
            color: Colors.grey[200]!,
          ),
        ],
      ),
    );
  }

  Widget _buildFooterCell({
    required String text,
    required Color color,
    Color textColor = primaryColor,
  }) {
    return Expanded(
      child: Container(
        height: 50,
        alignment: Alignment.center,
        color: color,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Text(
          text,
          maxLines: 2,
          overflow: TextOverflow.clip,
          style: titleStyle.copyWith(color: textColor, fontSize: 12),
        ),
      ),
    );
  }
}
