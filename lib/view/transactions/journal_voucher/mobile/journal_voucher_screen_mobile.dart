import 'package:cashier_system/controller/transactions/journal_voucher_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/view/transactions/journal_voucher/widgets/journal_voucher_action_widget.dart';
import 'package:cashier_system/view/transactions/journal_voucher/widgets/journal_voucher_table_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JournalVoucherScreenMobile extends StatelessWidget {
  const JournalVoucherScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(JournalVoucherController());
    return Scaffold(
      appBar: customAppBarTitle(TextRoutes.journalVoucher, true),
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
                    child: JournalVoucherActionWidget(
                      isMobile: true,
                    ),
                  ),
                  JournalVoucherTableData()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
