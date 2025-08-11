import 'package:cashier_system/controller/reports/billing_profits_controller.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/view/widgets/tables/table_cell.dart';
import 'package:cashier_system/view/widgets/tables/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BillingProfitsTable extends StatelessWidget {
  final BillingProfitsController controller;
  const BillingProfitsTable({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TableWidget(
      allSelected: controller.billingInvoicesData.length ==
          controller.selectedBillingInvoicesData.length,
      onRowDoubleTap: (index) {
        var record = controller.billingInvoicesData[index];
        controller.selectItem(
            controller.selectedBillingInvoicesData,
            record.invoiceId,
            controller.isSelected(
                controller.selectedBillingInvoicesData, record.invoiceId));
      },
      verticalScrollController: controller.scrollControllers,
      onHeaderDoubleTap: (index) {
        controller.selectAllRows(controller.selectedBillingInvoicesData,
            controller.billingInvoicesData);
      },
      columns: const [
        "",
        TextRoutes.invoiceNumber,
        TextRoutes.customerName,
        TextRoutes.date,
        TextRoutes.discount,
        TextRoutes.tax,
        TextRoutes.invoiceAmount,
        TextRoutes.invoiceCost,
        TextRoutes.invoiceProfit,
      ],
      flexes: const [1, 1, 2, 2, 1, 1, 1, 1, 2],
      rows: List.generate(controller.billingInvoicesData.length, (index) {
        final record = controller.billingInvoicesData[index];
        final isSelected = controller.isSelected(
            controller.selectedBillingInvoicesData, record.invoiceId);
        return [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Checkbox(
                value: isSelected,
                onChanged: (checked) {
                  controller.selectItem(controller.selectedBillingInvoicesData,
                      record.invoiceId, checked ?? false);
                }),
          ),
          tableCell(record.invoiceId.toString()),
          tableCell(record.accountName ?? TextRoutes.cashAgent.tr),
          tableCell(record.invoiceCreatedDate),
          tableCell(formattingNumbers(record.invoiceDiscount)),
          tableCell(formattingNumbers(record.invoiceTax)),
          tableCell(formattingNumbers(record.invoicePrice)),
          tableCell(formattingNumbers(record.invoiceCost)),
          tableCell(formattingNumbers(record.invoiceProfit)),
          SizedBox(
            key: isSelected ? const ValueKey("selected") : null,
          ),
        ];
      }),
    );
  }
}
