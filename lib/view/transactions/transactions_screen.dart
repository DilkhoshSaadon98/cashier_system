import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/constant/screen_routes.dart';
import 'package:cashier_system/core/dialogs/show_form_dialog.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/responsive/divide_screen_widget.dart';
import 'package:cashier_system/core/responsive/screen_builder.dart';
import 'package:cashier_system/core/shared/buttons/custom_button_widget.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/view/transactions/journal_voucher/widgets/journal_voucher_add_dialog.dart';
import 'package:cashier_system/view/transactions/opening_entry/widgets/opening_entry_dialog_form.dart';
import 'package:cashier_system/view/transactions/payment/widgets/transaction_payment_dialog_form_widget.dart';
import 'package:cashier_system/view/transactions/receipt/widgets/transaction_receipt_dialog_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map> data = [
      {
        'title': TextRoutes.receipts,
        'image': AppImageAsset.importIcons,
        'on_tap': () {
          Get.toNamed(AppRoute.transactionReceiptScreen);
        }
      },
      {
        'title': TextRoutes.payments,
        'image': AppImageAsset.exportIcons,
        'on_tap': () {
          Get.toNamed(AppRoute.transactionPaymentScreen);
        }
      },
      {
        'title': TextRoutes.journalVoucher,
        'image': AppImageAsset.journalVoucherIcons,
        'on_tap': () {
          Get.toNamed(AppRoute.journalVoucherScreen);
        }
      },
      {
        'title': TextRoutes.openingEntry,
        'image': AppImageAsset.openingEntryIcons,
        'on_tap': () {
          Get.toNamed(AppRoute.openingEntryScreen);
        }
      },
    ];
    return Scaffold(
      backgroundColor: white,
      body: ScreenBuilder(
        windows: DivideScreenWidget(
          showWidget: Center(
            child: SizedBox(
              width: 600.w,
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  return customItemsCard(data[index]);
                },
              ),
            ),
          ),
          actionWidget: Column(
            children: [
              const CustomHeaderScreen(
                imagePath: AppImageAsset.transactionIcons,
                title: TextRoutes.receiptAndPayments,
              ),
              verticalGap(),
              //? Add Receipt Account:
              customButtonWidget(() {
                showFormDialog(context,
                    isUpdate: false,
                    addText: TextRoutes.addAccount,
                    editText: TextRoutes.editAccount,
                    child: const TransactionReceiptDialogForm(
                      isUpdate: false,
                      isReceipt: true,
                    ));
              }, TextRoutes.addReceipt,
                  color: buttonColor,
                  textColor: white,
                  isSvg: true,
                  svgPath: AppImageAsset.importIcons),
              verticalGap(5),
              //? Add Payment Account:
              customButtonWidget(() {
                showFormDialog(context,
                    isUpdate: false,
                    addText: TextRoutes.addTransaction,
                    editText: TextRoutes.editTransaction,
                    child: const TransactionPaymentDialogFormWidget(
                      isUpdate: false,
                      isReceipt: true,
                    ));
              }, TextRoutes.addPayments,
                  color: buttonColor,
                  textColor: white,
                  isSvg: true,
                  svgPath: AppImageAsset.exportIcons),
              verticalGap(5),

              //? Add JournalVoucher Account:
              customButtonWidget(() {
                showFormDialog(context,
                    isUpdate: false,
                    addText: TextRoutes.addAccount,
                    editText: TextRoutes.editAccount,
                    child: const JournalVoucherAddDialog(
                        // isUpdate: false,
                        // isReceipt: false,
                        ));
              }, TextRoutes.journalVoucher,
                  color: buttonColor,
                  textColor: white,
                  isSvg: true,
                  svgPath: AppImageAsset.journalVoucherIcons),
              verticalGap(5),
              //? Add OpeningEntry Account:
              customButtonWidget(() {
                showFormDialog(context,
                    isUpdate: false,
                    addText: TextRoutes.addOpeningEntry,
                    editText: TextRoutes.editTransaction,
                    child: const OpeningEntryDialogForm(
                      isUpdate: false,
                      isReceipt: true,
                    ));
              }, TextRoutes.addOpeningEntry,
                  color: buttonColor,
                  textColor: white,
                  isSvg: true,
                  svgPath: AppImageAsset.openingEntryIcons),
              verticalGap(),
            ],
          ),
        ),
        mobile: Scaffold(
          appBar: customAppBarTitle(TextRoutes.receiptAndPayments, true),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SizedBox(
                width: 500.w,
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  itemBuilder: (context, index) {
                    return customItemsCard(data[index]);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget customItemsCard(Map data) {
    return InkWell(
      onTap: data['on_tap'],
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(12.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                data['image'],
                semanticsLabel: 'Icon',
                color: white,
                width: 75,
                height: 75,
              ),
              SizedBox(height: 10.h),
              Text(
                data['title'].toString().tr,
                textAlign: TextAlign.center,
                style: titleStyle.copyWith(
                  color: white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
