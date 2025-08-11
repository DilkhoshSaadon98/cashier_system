import 'package:cashier_system/controller/reports/daily_reports_controller.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/view/widgets/tables/table_cell.dart';
import 'package:cashier_system/view/widgets/tables/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TrialBalanceTable extends StatelessWidget {
  final DailyReportsController controller;
  const TrialBalanceTable({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      alignment: Alignment.center,
      child: TableWidget(
        allSelected: false,
        onRowDoubleTap: (index) {
          // var item = controller.cartData[index];
          // controller.selectItem(
          //     item.itemsId!, !controller.isSelected(item.itemsId!));
        },
        verticalScrollController: controller.scrollControllers,
        onHeaderDoubleTap: (index) {
          // => controller.selectAllRows()
        },
        columns: const [
          "",
          TextRoutes.code,
          TextRoutes.accountName,
          TextRoutes.ballance,
          TextRoutes.credit,
          TextRoutes.debit,
        ],
        flexes: const [
          1,
          1,
          2,
          2,
          2,
          2,
        ],
        rows: List.generate(controller.trialBalance.length, (index) {
          final record = controller.trialBalance[index];
          return [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Checkbox(
                  value: false,
                  onChanged: (checked) {
                    //  controller.selectItem(item.itemsId!, checked ?? false),
                  }),
            ),
            tableCell(record.accountId.toString()),
            tableCell(record.accountName),
            tableCell(formattingNumbers(record.balance)),
            tableCell(formattingNumbers(record.credit ?? 0)),
            tableCell(formattingNumbers(record.debit)),
            SizedBox(
              key: false ? const ValueKey("selected") : null,
            ),
          ];
        }),
      ),
    );
  }
}
