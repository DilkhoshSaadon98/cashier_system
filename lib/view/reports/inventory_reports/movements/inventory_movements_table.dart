import 'package:cashier_system/controller/reports/inventory_reports_controller.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/view/widgets/tables/table_cell.dart';
import 'package:cashier_system/view/widgets/tables/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InventoryMovementsTable extends StatelessWidget {
  final InventoryReportsController controller;
  const InventoryMovementsTable({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TableWidget(
      allSelected: controller.selectedInventoryMovements.length ==
          controller.inventoryMovementsReportsData.length,
      onRowDoubleTap: (index) {
        var record = controller.inventoryMovementsReportsData[index];
        final isSelected = controller.isSelected(
            controller.selectedInventoryMovements, record.invoiceNumber);
        controller.selectItem(controller.selectedInventoryMovements,
            record.invoiceNumber, isSelected);
      },
      verticalScrollController: controller.scrollControllers,
      onHeaderDoubleTap: (index) {
        controller.selectAllRows(controller.selectedInventoryMovements,
            controller.inventoryMovementsReportsData);
      },
      columns: const [
        "",
        TextRoutes.invoiceNumber,
        TextRoutes.itemsName,
        TextRoutes.date,
        TextRoutes.unit,
        TextRoutes.sellingPrice,
        TextRoutes.totalItemsPrice,
        TextRoutes.availableQTY,
        TextRoutes.purchasedQTY,
        TextRoutes.soldQTY,
        TextRoutes.returnPurchaseQTY,
        TextRoutes.returnSaleQTY,
      ],
      flexes: const [1, 1, 2, 1, 1, 1, 2, 1, 1, 1, 1, 1],
      rows: List.generate(controller.inventoryMovementsReportsData.length,
          (index) {
        final record = controller.inventoryMovementsReportsData[index];
        final isSelected = controller.isSelected(
            controller.selectedInventoryMovements, record.invoiceNumber);
        return [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Checkbox(
                value: isSelected,
                onChanged: (checked) {
                  controller.selectItem(
                      controller.selectedInventoryMovements,
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
          tableCell(record.quantityRemaining.toString()),
          tableCell(record.quantityPurchased.toString()),
          tableCell(record.quantitySold.toString()),
          tableCell(record.quantityReturnPurchase.toString()),
          tableCell(record.quantityReturnSale.toString()),
          SizedBox(
            key: isSelected ? ValueKey("selected") : null,
          ),
        ];
      }),
    );
  }
}
