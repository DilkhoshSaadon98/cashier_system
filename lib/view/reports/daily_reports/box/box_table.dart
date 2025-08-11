import 'package:cashier_system/controller/reports/daily_reports_controller.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/view/widgets/tables/table_cell.dart';
import 'package:cashier_system/view/widgets/tables/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BoxTable extends StatelessWidget {
  final DailyReportsController controller;
  const BoxTable({super.key, required this.controller});

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
          TextRoutes.voucherNo,
          TextRoutes.date,
          TextRoutes.transactionType,
          TextRoutes.note,
          TextRoutes.accountName,
          TextRoutes.credit,
          TextRoutes.debit,
        ],
        flexes: const [
          1,
          2,
          2,
          2,
          2,
          2,
          1,
          1,
        ],
        rows: List.generate(controller.boxData.length, (index) {
          final record = controller.boxData[index];
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
            tableCell(record.dateTime),
            tableCell(record.type),
            tableCell(record.note),
            tableCell(record.accountName),
            tableCell(formattingNumbers(record.credit)),
            tableCell(formattingNumbers(record.debit)),
            const SizedBox(
              // ignore: dead_code
              key: false ? ValueKey("selected") : null,
            ),
          ];
        }),
      ),
    );
  }
}
