
import 'package:cashier_system/controller/reports/inventory_reports_controller.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/view/widgets/tables/table_cell.dart';
import 'package:cashier_system/view/widgets/tables/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class InventorySummaryTable extends StatelessWidget {
  final InventoryReportsController controller;
  const InventorySummaryTable({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TableWidget(
      allSelected: controller.inventorySummaryReportsData.length ==
          controller.selectedInventorySummary.length,
      onRowDoubleTap: (index) {
        var record = controller.inventorySummaryReportsData[index];
        controller.selectItem(
            controller.selectedInventorySummary,
            record.invoiceNumber,
            controller.isSelected(
                controller.selectedInventorySummary, record.invoiceNumber));
      },
      verticalScrollController: controller.scrollControllers,
      onHeaderDoubleTap: (index) {
        controller.selectAllRows(controller.selectedInventorySummary,
            controller.inventorySummaryReportsData);
      },
      columns: const [
        "",
        TextRoutes.invoiceNumber,
        TextRoutes.date,
        TextRoutes.itemsName,
        TextRoutes.unit,
        TextRoutes.quantity,
        TextRoutes.costPrice,
        TextRoutes.sellingPrice,
        TextRoutes.totalPrice,
        TextRoutes.note,
        TextRoutes.customerName,
      ],
      flexes: const [1, 1, 1, 2, 1, 1, 1, 1, 2, 2, 2],
      rows:
          List.generate(controller.inventorySummaryReportsData.length, (index) {
        final record = controller.inventorySummaryReportsData[index];
        final isSelected = controller.isSelected(
            controller.selectedInventorySummary, record.invoiceNumber);
        return [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Checkbox(
                value: isSelected,
                onChanged: (checked) {
                  controller.selectItem(controller.selectedInventorySummary,
                      record.invoiceNumber, checked ?? false);
                }),
          ),
          tableCell(record.invoiceNumber.toString()),
          tableCell(record.movementDate),
          tableCell(record.itemName),
          tableCell(record.unitName.toLowerCase().tr),
          tableCell(record.quantity.toString()),
          tableCell(formattingNumbers(record.costPrice)),
          tableCell(formattingNumbers(record.salePrice)),
          tableCell(formattingNumbers(record.salePrice * record.quantity)),
          tableCell(record.note),
          tableCell(record.accountName ?? TextRoutes.cashAgent.tr),
          SizedBox(
            key: isSelected ? ValueKey("selected") : null,
          ),
        ];
      }),
    );
  }
}
