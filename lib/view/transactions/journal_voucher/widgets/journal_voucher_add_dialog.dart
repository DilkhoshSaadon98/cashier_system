import 'package:cashier_system/controller/transactions/journal_voucher_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/date_picker.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_divider.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/custom_text_field_widget.dart';
import 'package:cashier_system/data/model/account_model.dart';
import 'package:cashier_system/core/shared/drop_downs/transaction_accounts_dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JournalVoucherAddDialog extends StatelessWidget {
  const JournalVoucherAddDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JournalVoucherController>(
        init: JournalVoucherController(),
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: Get.width,
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CustomTextFieldWidget(
                        hinttext: TextRoutes.date,
                        labeltext: TextRoutes.date,
                        iconData: Icons.date_range,
                        controller: controller.dateController,
                        valid: (value) {
                          return null;
                        },
                        onTap: () {
                          selectDate(context, controller.dateController);
                        },
                        readOnly: true,
                        fieldColor: white,
                        borderColor: primaryColor,
                        isNumber: false),
                    verticalGap(),
                    CustomTextFieldWidget(
                        hinttext: TextRoutes.note,
                        labeltext: TextRoutes.note,
                        iconData: Icons.note,
                        controller: controller.generalNoteController,
                        valid: (value) {
                          return validInput(value!, 0, 500, "",
                              required: false);
                        },
                        fieldColor: white,
                        borderColor: primaryColor,
                        isNumber: false),
                    verticalGap(),
                    customDivider(),
                    Text(TextRoutes.voucherDetails.tr, style: titleStyle),
                    verticalGap(),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.journalRows.length,
                      itemBuilder: (context, index) {
                        final row = controller.journalRows[index];
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 250,
                                  child:
                                      CustomDropdownSearchWidget<AccountModel>(
                                    validator: (AccountModel? value) {
                                      if (value == null) {
                                        return validInput("", 0, 100, "");
                                      }
                                      return null;
                                    },
                                    label: TextRoutes.accountName,
                                    iconData: Icons.account_balance,
                                    items:
                                        controller.dropDownListSourceAccounts,
                                    selectedItem:
                                        controller.journalRows[index].account,
                                    borderColor: primaryColor,
                                    fieldColor: white,
                                    itemToString: (account) =>
                                        "${account.accountName} (${account.accountType})",
                                    onChanged: (val) {
                                      if (val != null) {
                                        controller.journalRows[index].account =
                                            val;
                                        controller.update();
                                      }
                                    },
                                  ),
                                ),
                                horizontalGap(10),
                                SizedBox(
                                  width: 200,
                                  child: CustomTextFieldWidget(
                                    hinttext: TextRoutes.debit,
                                    labeltext: TextRoutes.debit,
                                    iconData: Icons.money,
                                    controller: row.debitController,
                                    valid: (value) => validInput(
                                        value!, 0, 500, "realNumber",
                                        required: false),
                                    fieldColor: white,
                                    borderColor: primaryColor,
                                    isNumber: true,
                                  ),
                                ),
                                horizontalGap(10),
                                SizedBox(
                                  width: 200,
                                  child: CustomTextFieldWidget(
                                    hinttext: TextRoutes.credit,
                                    labeltext: TextRoutes.credit,
                                    iconData: Icons.money,
                                    controller: row.creditController,
                                    valid: (value) => validInput(
                                        value!, 0, 500, "realNumber",
                                        required: false),
                                    fieldColor: white,
                                    borderColor: primaryColor,
                                    isNumber: true,
                                  ),
                                ),
                                horizontalGap(10),
                                SizedBox(
                                  width: 250,
                                  child: CustomTextFieldWidget(
                                    hinttext: TextRoutes.note,
                                    labeltext: TextRoutes.note,
                                    iconData: Icons.money,
                                    controller: row.noteController,
                                    valid: (value) => validInput(
                                        value!, 0, 500, "",
                                        required: false),
                                    fieldColor: white,
                                    borderColor: primaryColor,
                                    isNumber: false,
                                  ),
                                ),
                                horizontalGap(10),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    controller.journalRows.removeAt(index);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    verticalGap(),
                    OutlinedButton.icon(
                      onPressed: () {
                        controller.addJournalRows();
                      },
                      icon: const Icon(Icons.add),
                      label: Text(
                        "إضافة صف",
                        style: bodyStyle,
                      ),
                    ),
                    verticalGap(),
                    ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(primaryColor)),
                      onPressed: () {
                        controller.addVoucherData(context);
                      },
                      child: Text(
                        TextRoutes.submit,
                        style: bodyStyle.copyWith(color: white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
