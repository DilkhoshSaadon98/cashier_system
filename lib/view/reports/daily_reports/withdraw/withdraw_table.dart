import 'package:cashier_system/controller/reports/daily_reports_controller.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/view/widgets/tables/table_cell.dart';
import 'package:cashier_system/view/widgets/tables/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WithdrawTable extends StatelessWidget {
  final DailyReportsController controller;
  const WithdrawTable({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TableWidget(
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
        TextRoutes.customerName,
        TextRoutes.transactionType,
        TextRoutes.credit,
        TextRoutes.debit,
        TextRoutes.ballance,
        TextRoutes.date,
        TextRoutes.note,
      ],
      flexes: const [
        1,
        1,
        2,
        1,
        1,
        1,
        1,
        1,
        2,
      ],
      rows: List.generate(controller.customerData.length, (index) {
        final record = controller.customerData[index];
        return [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Checkbox(
                value: false,
                onChanged: (checked) {
                  //  controller.selectItem(item.itemsId!, checked ?? false),
                }),
          ),
          tableCell(record.voucherNo.toString()),
          tableCell(record.accountName),
          tableCell(record.type),
          tableCell(formattingNumbers(record.credit)),
          tableCell(formattingNumbers(record.debit)),
          tableCell(formattingNumbers(record.transactionAmount)),
          tableCell(record.dateTime.toString()),
          tableCell(record.note),
          const SizedBox(
            key: false ? ValueKey("selected") : null,
          ),
        ];
      }),
    );
  }
}
