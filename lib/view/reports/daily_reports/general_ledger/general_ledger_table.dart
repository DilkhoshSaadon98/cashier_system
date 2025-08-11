import 'package:cashier_system/controller/reports/daily_reports_controller.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/view/widgets/tables/table_cell.dart';
import 'package:cashier_system/view/widgets/tables/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GeneralLedgerTable extends StatelessWidget {
  final DailyReportsController controller;
  const GeneralLedgerTable({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TableWidget(
      allSelected: controller.generalLedger.length ==
          controller.selectedGeneralLedger.length,
      onRowDoubleTap: (index) {
        var record = controller.generalLedger[index];
        controller.selectItem(
            controller.selectedGeneralLedger,
            record.voucherNo,
            controller.isSelected(
                controller.selectedGeneralLedger, record.voucherNo));
      },
      verticalScrollController: controller.scrollControllers,
      onHeaderDoubleTap: (index) {
        controller.selectAllRows(
            controller.selectedGeneralLedger, controller.generalLedger);
      },
      columns: const [
        "",
        TextRoutes.code,
        TextRoutes.transactionType,
        TextRoutes.amount,
        TextRoutes.discount,
        TextRoutes.sourceAccount,
        TextRoutes.targetAccount,
        TextRoutes.date,
        TextRoutes.note,
      ],
      flexes: const [
        1,
        1,
        2,
        1,
        1,
        2,
        2,
        1,
        2,
      ],
      rows: List.generate(controller.generalLedger.length, (index) {
        final record = controller.generalLedger[index];
        final isSelected = controller.isSelected(
            controller.selectedGeneralLedger, record.voucherNo);
        return [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Checkbox(
                value: isSelected,
                onChanged: (checked) {
                  controller.selectItem(controller.selectedGeneralLedger,
                      record.voucherNo, checked ?? false);
                }),
          ),
          tableCell(record.voucherNo.toString()),
          tableCell(record.transactionType),
          tableCell(formattingNumbers(record.amount)),
          tableCell(formattingNumbers(record.discount ?? 0)),
          tableCell(record.sourceAccountName),
          tableCell(record.targetAccountName),
          tableCell(record.transactionDate.toString()),
          tableCell(record.description ?? ''),
          SizedBox(
            key: isSelected ? ValueKey("selected") : null,
          ),
        ];
      }),
    );
  }
}
