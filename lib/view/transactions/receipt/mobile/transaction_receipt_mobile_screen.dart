import 'package:cashier_system/controller/transactions/transaction_receipt_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/view/transactions/receipt/widgets/transaction_receipt_action_widget.dart';
import 'package:cashier_system/view/transactions/receipt/widgets/transaction_receipt_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionReceiptMobileScreen extends StatelessWidget {
  const TransactionReceiptMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TransactionReceiptController());
    return Scaffold(
      appBar: customAppBarTitle(TextRoutes.receipts, true),
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
                    child: TransactionReceiptActionWidget(
                      isMobile: true,
                    ),
                  ),
                  TransactionReceiptTableWidget()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
