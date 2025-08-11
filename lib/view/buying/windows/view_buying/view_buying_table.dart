import 'package:cashier_system/controller/buying/buying_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/dialogs/delete_dialog.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/functions/handle_data_function_mobile.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/buttons/custom_floating_button.dart';
import 'package:cashier_system/data/model/purchaes_model.dart';
import 'package:cashier_system/view/widgets/tables/table_cell.dart';
import 'package:cashier_system/view/widgets/tables/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ViewBuyingTable extends StatelessWidget {
  final bool? showBackButton;
  const ViewBuyingTable({super.key, this.showBackButton});

  @override
  Widget build(BuildContext context) {
    BuyingController controller = Get.put(BuyingController());
    void showDialogBox(PurchaseModel dataItem) {
      controller.customShowPopupMenu.showPopupMenu(
        context,
        [
          TextRoutes.view,
          TextRoutes.remove,
        ],
        [
          () {
            showPurchaseItemsDialog(context, dataItem);
          },
          () {
            showDeleteDialog(
                context: context,
                title: "",
                content: "",
                onPressed: () {
                  controller.removeData(dataItem.purchaseNumber!);
                  Navigator.pop(context);
                });
          }
        ],
      );
    }

    Widget buildCell(String text, var dataItem) => tableCell(
          text,
          onTap: () {
            showDialogBox(dataItem);
          },
          onSecondaryTap: () {
            showDialogBox(dataItem);
          },
          onTapDown: (value) =>
              controller.customShowPopupMenu.storeTapPosition(value),
        );
    return Scaffold(
      backgroundColor: white,
      appBar:
          customAppBarTitle(TextRoutes.viewPurchaes, showBackButton ?? false),
      floatingActionButton: customFloatingButton(
          controller.showBackToTopButton, controller.purchaseScrollControllers),
      body: GetBuilder<BuyingController>(
          init: BuyingController(),
          builder: (controller) {
            return SizedBox(
              width: Get.width,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo is ScrollUpdateNotification &&
                            scrollInfo.scrollDelta != null) {
                          if (scrollInfo.metrics.pixels ==
                                  scrollInfo.metrics.maxScrollExtent &&
                              scrollInfo.scrollDelta! > 0 &&
                              !controller.isLoading &&
                              scrollInfo.metrics.axis == Axis.vertical) {
                            controller.getPurchaseData();
                            return true;
                          }
                        }
                        return false;
                      },
                      child: checkDataMobile(
                        controller.purchaseData.length,
                        TableWidget(
                          allSelected: controller.selectedRows.length ==
                              controller.purchaseData.length,
                          columns: const [
                            " ",
                            TextRoutes.invoiceNumber,
                            TextRoutes.supplierName,
                            TextRoutes.totalPrice,
                            TextRoutes.discount,
                            TextRoutes.fees,
                            TextRoutes.date,
                            TextRoutes.paymentString,
                          ],
                          flexes: const [1, 1, 2, 2, 1, 1, 2, 1],
                          onRowDoubleTap: (index) {
                            final dataItem = controller.purchaseData[index];
                            final isSelected = controller.isSelected(
                                dataItem.purchaseId!, controller.selectedRows);
                            controller.selectItem(dataItem.purchaseId!,
                                !isSelected, controller.selectedRows);
                          },
                          onHeaderDoubleTap: (_) {
                            //   controller.selectAllRows();
                          },
                          verticalScrollController:
                              controller.purchaseScrollControllers,
                          showHeader: true,
                          rows: List.generate(controller.purchaseData.length,
                              (index) {
                            final record = controller.purchaseData[index];
                            final isSelected = controller.isSelected(
                                record.purchaseId!, controller.selectedRows);

                            return [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                child: Checkbox(
                                  value: isSelected,
                                  onChanged: (checked) {
                                    controller.selectItem(
                                        record.purchaseId!,
                                        checked ?? false,
                                        controller.selectedRows);
                                  },
                                ),
                              ),
                              buildCell(record.purchaseId.toString(), record),
                              buildCell(record.supplierName!, record),
                              buildCell(
                                  formattingNumbers(record.purchaseTotalPrice),
                                  record),
                              buildCell(
                                  formattingNumbers(record.purchaseDiscount),
                                  record),
                              buildCell(formattingNumbers(record.purchaseFees),
                                  record),
                              buildCell(record.purchaseDate!, record),
                              buildCell(record.purchasePayment!.tr, record),
                              SizedBox(
                                key: isSelected
                                    ? const ValueKey("selected")
                                    : null,
                              ),
                            ];
                          }),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

void showPurchaseItemsDialog(BuildContext context, PurchaseModel purchase) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(
          "${TextRoutes.purchaes.tr} ${TextRoutes.invoice.tr} ${purchase.purchaseNumber}"),
      content: SizedBox(
        width: double.minPositive,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...purchase.items!.map((item) => ListTile(
                  title: Text(
                    item.itemName,
                    style: titleStyle,
                  ),
                  subtitle: Text(
                    "${TextRoutes.qty}: ${item.quantity}",
                    style: bodyStyle,
                  ),
                  trailing: Text("${TextRoutes.price}:${item.price}",
                      style: bodyStyle),
                )),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(TextRoutes.close.tr),
        ),
      ],
    ),
  );
}
