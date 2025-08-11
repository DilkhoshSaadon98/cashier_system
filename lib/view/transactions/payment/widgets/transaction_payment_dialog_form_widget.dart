import 'package:cashier_system/controller/transactions/transaction_payment_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/custom_text_field_widget.dart';
import 'package:cashier_system/data/model/account_model.dart';
import 'package:cashier_system/view/categories/widgets/add_category_form.dart';
import 'package:cashier_system/view/transactions/components/transaction_accounts_dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionPaymentDialogFormWidget extends StatelessWidget {
  final bool isUpdate, isReceipt;
  const TransactionPaymentDialogFormWidget({
    required this.isUpdate,
    super.key,
    required this.isReceipt,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(TransactionPaymentController());
    return SingleChildScrollView(
      child: GetBuilder<TransactionPaymentController>(
          autoRemove: false,
          builder: (controller) {
            return Form(
              key: controller.formState,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...List.generate(controller.addTransactionDataFields.length,
                        (index) {
                      final field = controller.addTransactionDataFields[index];
                      final title = field['title'];
                      var fieldController = field['controller'];
                      final icon = field['icon'];
                      final required = field['required'];
                      if (title == TextRoutes.sourceAccount ||
                          title == TextRoutes.targetAccount) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          child:
                              TransactionAccountsDropdownWidget<AccountModel>(
                            iconData: icon,
                            items: controller.dropDownListSourceAccounts,
                            label: title,
                            onChanged: (value) {
                              if (value != null) {
                                if (fieldController is AccountModel?) {
                                  if (title == TextRoutes.sourceAccount) {
                                    controller.selectedSourceAccountId =
                                        value.accountId;
                                  } else {
                                    controller.selectedTargetAccountId =
                                        value.accountId;
                                  }
                                  fieldController = value;
                                }
                                controller.update();
                              }
                            },
                            selectedItem: fieldController,
                            borderColor: primaryColor,
                            fieldColor: white,
                            itemToString: (p0) {
                              return p0.accountName!;
                            },
                          ),
                        );
                      }
                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: CustomTextFieldWidget(
                          borderColor: primaryColor,
                          fieldColor: white,
                          hinttext: title,
                          iconData: icon,
                          labeltext: title,
                          isNumber: true,
                          controller: fieldController,
                          onTap: () {
                            field['on_tap']?.call(context, fieldController);
                          },
                          valid: (value) {
                            return validInput(value!, 0, 1000, "",
                                required: required);
                          },
                        ),
                      );
                    }),
                    verticalGap(15),
                    dialogButtonWidget(
                      context,
                      () async {
                        isUpdate
                            ? controller.updateReceiptTransactionDatas()
                            : controller.addPaymentTransactionDatas(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
