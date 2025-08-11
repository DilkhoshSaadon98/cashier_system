import 'package:cashier_system/controller/transactions/transaction_payment_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/functions/handle_data_function.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/buttons/custom_floating_button.dart';
import 'package:cashier_system/view/widgets/tables/table_cell.dart';
import 'package:cashier_system/view/widgets/tables/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ClientSuppliersTableWidget extends StatelessWidget {
  final bool? showBackButton;
  const ClientSuppliersTableWidget({super.key, this.showBackButton});

  @override
  Widget build(BuildContext context) {
    TransactionPaymentController controller =
        Get.put(TransactionPaymentController());

    Widget buildCell(String text, var dataTransaction) => tableCell(
          text,
          onTap: () {},
          onSecondaryTap: () {},
          onTapDown: (value) =>
              controller.customShowPopupMenu.storeTapPosition(value),
        );

    return GetBuilder<TransactionPaymentController>(builder: (_) {
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
                controller.getPaymentTransactionData();
              }
              return false;
            },
            child: checkData(
              controller.transactionPaymentData,
              TableWidget(
                allSelected: controller.selectedRows.length ==
                    controller.transactionPaymentData.length,
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
                      controller.transactionPaymentData[index];
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
                rows: List.generate(controller.transactionPaymentData.length,
                    (index) {
                  final transaction = controller.transactionPaymentData[index];
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
                    buildCell(
                        transaction.transactionNumber.toString(), transaction),
                    buildCell(transaction.sourceAccountName, transaction),
                    buildCell(transaction.targetAccountName, transaction),
                    buildCell(formattingNumbers(transaction.transactionAmount),
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
            ),
          ),
        ),
      );
    });
  }
}
