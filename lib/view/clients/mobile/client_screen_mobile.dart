import 'package:cashier_system/controller/transactions/transaction_payment_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/view/clients/widgets/client_action_widget.dart';
import 'package:cashier_system/view/clients/widgets/client_customers_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientScreenMobile extends StatelessWidget {
  const ClientScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TransactionPaymentController());
    return Scaffold(
      appBar: customAppBarTitle(TextRoutes.clientsAccounts, true),
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
            Expanded(
              child: TabBarView(
                children: [
                  Container(
                    color: white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: const ClientActionWidget(
                      isMobile: true,
                    ),
                  ),
                  const CustomerClientTableWidget()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
