import 'package:cashier_system/controller/transactions/transaction_payment_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/view/transactions/payment/widgets/transaction_payment_action_widget.dart';
import 'package:cashier_system/view/transactions/payment/widgets/transaction_payment_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionPaymentsScreenMobile extends StatelessWidget {
  const TransactionPaymentsScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TransactionPaymentController());
    return Scaffold(
      appBar: customAppBarTitle(TextRoutes.payments, true),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: buttonColor,
              child: TabBar(
                  dividerColor: primaryColor,
                  dividerHeight: 2,
                  unselectedLabelColor: white,
                  indicatorColor: secondColor2,
                  indicatorSize: TabBarIndicatorSize.tab,
                  automaticIndicatorColorAdjustment: true,
                  labelColor: secondColor,
                  tabs: [
                    Tab(
                      child: Text(
                        TextRoutes.search.tr,
                        style: titleStyle.copyWith(color: white),
                      ),
                    ),
                    Tab(
                      child: Text(
                        TextRoutes.showData.tr,
                        style: titleStyle.copyWith(color: white),
                      ),
                    ),
                  ]),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: TransactionPaymentActionWidget(
                      isMobile: true,
                    ),
                  ),
                  TransactionPaymentTableWidget()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
