import 'package:cashier_system/controller/transactions/transaction_receipt_controller.dart';
import 'package:cashier_system/core/class/handling_data_view.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/dialogs/delete_dialog.dart';
import 'package:cashier_system/core/dialogs/show_form_dialog.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/buttons/custom_floating_button.dart';
import 'package:cashier_system/data/model/account_model.dart';
import 'package:cashier_system/data/model/transaction_model.dart';
import 'package:cashier_system/view/transactions/receipt/widgets/transaction_receipt_dialog_form.dart';
import 'package:cashier_system/view/widgets/tables/table_cell.dart';
import 'package:cashier_system/view/widgets/tables/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TransactionReceiptTableWidget extends StatelessWidget {
  final bool? showBackButton;
  const TransactionReceiptTableWidget({super.key, this.showBackButton});

  @override
  Widget build(BuildContext context) {
    TransactionReceiptController controller =
        Get.put(TransactionReceiptController());
    void showDialogBox(TransactionModel dataItem) {
      controller.customShowPopupMenu.showPopupMenu(
        context,
        [
          TextRoutes.edit,
          TextRoutes.remove,
        ],
        [
          () {
            controller.selectedSourceAccount = AccountModel(
              accountId: dataItem.sourceAccountId,
              accountName: dataItem.sourceAccountName,
            );

            controller.selectedTargetAccount = AccountModel(
              accountId: dataItem.targetAccountId,
              accountName: dataItem.targetAccountName,
            );
            controller.idController = dataItem.transactionId;
            controller.selectedTargetAccountId = dataItem.targetAccountId;
            controller.selectedSourceAccountId = dataItem.sourceAccountId;

            controller.noteController.text = dataItem.transactionNote ?? '';
            controller.amountController.text =
                dataItem.transactionAmount.toString();
            controller.discountController.text =
                dataItem.transactionDiscount.toString();
            controller.dateController.text = dataItem.transactionDate;

            showFormDialog(
              context,
              isUpdate: true,
              addText: TextRoutes.addAccount,
              editText: TextRoutes.editAccount,
              child: const TransactionReceiptDialogForm(
                isUpdate: true,
                isReceipt: true,
              ),
            );
          },
          () => showDeleteDialog(
                context: context,
                title: TextRoutes.warning,
                content: TextRoutes.sureRemoveData,
                onPressed: () {
                  controller
                      .removeReceiptTransactionDatas([dataItem.transactionId]);
                  Navigator.of(context).pop();
                },
              ),
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

    return GetBuilder<TransactionReceiptController>(builder: (_) {
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
                  controller.getReceiptTransactionData();
                }
                return false;
              },
              child: HandlingDataView(
                statusRequest: controller.statusRequest,
                child: TableWidget(
                  allSelected: controller.selectedRows.length ==
                      controller.transactionReceiptData.length,
                  columns: const [
                    " ",
                    TextRoutes.code,
                    TextRoutes.transactionNumber,
                    TextRoutes.sourceAccount,
                    TextRoutes.targetAccount,
                    TextRoutes.amount,
                    TextRoutes.discount,
                    TextRoutes.sourceAccountType,
                    TextRoutes.targetAccountType,
                    TextRoutes.date,
                    TextRoutes.note,
                  ],
                  flexes: const [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2],
                  onRowDoubleTap: (index) {
                    final dataTransaction =
                        controller.transactionReceiptData[index];
                    final isSelected =
                        controller.isSelected(dataTransaction.transactionId);
                    controller.selectData(
                        dataTransaction.transactionId, !isSelected);
                  },
                  onHeaderDoubleTap: (_) {
                    controller.selectAllRows();
                  },
                  verticalScrollController: controller.scrollControllers,
                  showHeader: true,
                  rows: List.generate(controller.transactionReceiptData.length,
                      (index) {
                    final transaction =
                        controller.transactionReceiptData[index];
                    final isSelected =
                        controller.isSelected(transaction.transactionId);

                    return [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Checkbox(
                          value: isSelected,
                          onChanged: (checked) {
                            controller.selectData(
                                transaction.transactionId, checked ?? false);
                          },
                        ),
                      ),
                      buildCell(
                          transaction.transactionId.toString(), transaction),
                      buildCell(transaction.transactionNumber, transaction),
                      buildCell(transaction.sourceAccountName, transaction),
                      buildCell(transaction.targetAccountName, transaction),
                      buildCell(
                          formattingNumbers(transaction.transactionAmount),
                          transaction),
                      buildCell(
                          formattingNumbers(transaction.transactionDiscount),
                          transaction),
                      buildCell(transaction.sourceAccountType.tr, transaction),
                      buildCell(transaction.targetAccountType.tr, transaction),
                      buildCell(transaction.transactionDate, transaction),
                      buildCell(transaction.transactionNote ?? '', transaction),
                      SizedBox(
                        key: isSelected ? const ValueKey("selected") : null,
                      ),
                    ];
                  }),
                ),
              )),
        ),
      );
    });
  }
}
