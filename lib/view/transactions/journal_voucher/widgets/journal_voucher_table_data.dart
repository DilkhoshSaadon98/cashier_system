import 'package:cashier_system/controller/transactions/journal_voucher_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/dialogs/delete_dialog.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/functions/handle_data_function.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/buttons/custom_floating_button.dart';
import 'package:cashier_system/data/model/journal_voucher_model.dart';
import 'package:cashier_system/view/widgets/tables/table_cell.dart';
import 'package:cashier_system/view/widgets/tables/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JournalVoucherTableData extends StatelessWidget {
  const JournalVoucherTableData({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    JournalVoucherController controller = Get.put(JournalVoucherController());
    void showDialogBox(JournalVoucherModel dataItem) {
      controller.customShowPopupMenu.showPopupMenu(
        context,
        [
          TextRoutes.remove,
          TextRoutes.view,
        ],
        [
          () => showDeleteDialog(
                context: context,
                title: TextRoutes.warning,
                content: TextRoutes.sureRemoveData,
                onPressed: () {
                  // controller.deleteItems([dataItem.itemsId]);
                  // Navigator.of(context).pop(false);
                },
              ),
          () => controller.viewVoucherLines(dataItem.voucherId),
        ],
      );
    }

    Widget buildCell(String text, var dataTransaction) => tableCell(
          text,
          onTap: () {
            showDialogBox(dataTransaction);
          },
          onSecondaryTap: () {
            showDialogBox(dataTransaction);
          },
          onTapDown: (value) =>
              controller.customShowPopupMenu.storeTapPosition(value),
        );

    return GetBuilder<JournalVoucherController>(builder: (_) {
      return Scaffold(
        floatingActionButton: customFloatingButton(
            controller.showBackToTopButton, controller.scrollControllers!),
        body: Container(
          color: white,
          alignment: Alignment.topCenter,
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo is ScrollUpdateNotification &&
                  scrollInfo.scrollDelta != null &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent &&
                  scrollInfo.scrollDelta! > 0 &&
                  !controller.isLoading &&
                  scrollInfo.metrics.axis == Axis.vertical) {
                controller.fetchVoucherData();
              }
              return false;
            },
            child: checkData(
                controller.journalVoucherData,
                TableWidget(
                  allSelected: controller.selectedRows.length ==
                      controller.journalVoucherData.length,
                  columns: const [
                    " ",
                    TextRoutes.code,
                    TextRoutes.voucherNumber,
                    TextRoutes.date,
                    TextRoutes.note,
                    TextRoutes.debit,
                    TextRoutes.credit,
                  ],
                  flexes: const [1, 1, 2, 2, 3, 2, 2],
                  onRowDoubleTap: (index) {
                    final data = controller.journalVoucherData[index];
                    final isSelected = controller.isSelected(data.voucherId);
                    controller.selectData(data.voucherId, !isSelected);
                  },
                  onHeaderDoubleTap: (_) => controller.selectAllRows(),
                  verticalScrollController: controller.scrollControllers,
                  showHeader: true,
                  rows: List.generate(controller.journalVoucherData.length,
                      (index) {
                    final voucher = controller.journalVoucherData[index];
                    final isSelected = controller.isSelected(voucher.voucherId);

                    return [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Checkbox(
                          value: isSelected,
                          onChanged: (checked) {
                            controller.selectData(
                                voucher.voucherId, checked ?? false);
                          },
                        ),
                      ),
                      buildCell(voucher.voucherId.toString(), voucher),
                      buildCell(voucher.voucherNumber.toString(), voucher),
                      buildCell(voucher.voucherDate, voucher),
                      buildCell(voucher.voucherNote, voucher),
                      buildCell(
                          formattingNumbers(voucher.totalCredit), voucher),
                      buildCell(
                          formattingNumbers(voucher.totalCredit), voucher),
                      buildCell(
                          formattingNumbers(voucher.totalCredit), voucher),
                    ];
                  }),
                )),
          ),
        ),
      );
    });
  }
}
