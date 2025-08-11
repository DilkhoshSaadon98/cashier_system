import 'package:cashier_system/controller/reports/daily_reports_controller.dart';
import 'package:cashier_system/controller/reports/inventory_reports_controller.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/view/widgets/tables/table_cell.dart';
import 'package:cashier_system/view/widgets/tables/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InventoryValuationTable extends StatelessWidget {
  final InventoryReportsController controller;
  const InventoryValuationTable({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TableWidget(
      allSelected: controller.inventoryValuationReportsData.length ==
          controller.selectedInventoryValuation.length,
      onRowDoubleTap: (index) {
        var record = controller.inventorySummaryReportsData[index];
        controller.selectItem(
            controller.selectedInventoryValuation,
            record.invoiceNumber,
            controller.isSelected(controller.inventoryValuationReportsData,
                record.invoiceNumber));
      },
      verticalScrollController: controller.scrollControllers,
      onHeaderDoubleTap: (index) {
        controller.selectAllRows(controller.selectedInventoryValuation,
            controller.inventoryValuationReportsData);
      },
      columns: const [
        "",
        TextRoutes.invoiceNumber,
        TextRoutes.itemsName,
        TextRoutes.date,
        TextRoutes.unit,
        TextRoutes.sellingPrice,
        TextRoutes.totalItemsPrice,
        TextRoutes.costPrice,
        TextRoutes.totalCostPrice,
        TextRoutes.availableQTY,
        TextRoutes.purchasedQTY,
        TextRoutes.soldQTY,
        TextRoutes.returnPurchaseQTY,
        TextRoutes.returnSaleQTY,
      ],
      flexes: const [1, 1, 2, 1, 1, 1, 2, 1, 2, 1, 1, 1, 1, 1],
      rows: List.generate(controller.inventoryValuationReportsData.length,
          (index) {
        final record = controller.inventoryValuationReportsData[index];
        final isSelected = controller.isSelected(
            controller.inventoryValuationReportsData, record.invoiceNumber);
        return [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Checkbox(
                value: isSelected,
                onChanged: (checked) {
                  controller.selectItem(
                      controller.inventoryValuationReportsData,
                      record.invoiceNumber,
                      checked ?? false);
                }),
          ),
          tableCell(record.invoiceNumber.toString()),
          tableCell(record.itemName),
          tableCell(record.createDate),
          tableCell(record.unitName),
          tableCell(formattingNumbers(record.sellingPrice)),
          tableCell(formattingNumbers(
              record.quantityRemaining * record.sellingPrice)),
          tableCell(formattingNumbers(record.costPrice)),
          tableCell(
              formattingNumbers(record.quantityRemaining * record.costPrice)),
          tableCell(record.quantityRemaining.toString()),
          tableCell(record.quantityPurchased.toString()),
          tableCell(record.quantitySold.toString()),
          tableCell(record.quantityReturnPurchase.toString()),
          tableCell(record.quantityReturnSale.toString()),
          SizedBox(
            key: isSelected ? const ValueKey("selected") : null,
          ),
        ];
      }),
    );
  }
}
