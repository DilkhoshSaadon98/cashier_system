import 'package:cashier_system/controller/transactions/transaction_receipt_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/custom_text_field_widget.dart';
import 'package:cashier_system/view/categories/widgets/add_category_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddUsersAccountDialog extends StatelessWidget {
  final bool isUpdate;
  final List<Map<String, dynamic>> data;
  final Key? formState;
  final void Function()? onPressed;
  const AddUsersAccountDialog({
    super.key,
    required this.isUpdate,
    required this.data,
    this.formState,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(TransactionReceiptController());
    return SingleChildScrollView(
        child: Form(
      key: formState,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...List.generate(data.length, (index) {
              final field = data[index];
              final title = field['title'];
              final fieldController = field['controller'];
              final icon = field['icon'];
              final required = field['required'];
              // if (title == TextRoutes.sourceAccount ||
              //     title == TextRoutes.targetAccount) {
              //   return Container(
              //     margin: const EdgeInsets.only(bottom: 15),
              //     child: TransactionDropDownReceiptAccounts(
              //         borderColor: primaryColor,
              //         fieldColor: white,
              //         selectedAccount: fieldController,
              //         iconData: icon,
              //         label: title,
              //         isSource: field['source']),
              //   );
              // }
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: CustomTextFieldWidget(
                  borderColor: primaryColor,
                  fieldColor: white,
                  hinttext: title,
                  iconData: icon,
                  labeltext: title,
                  isNumber: false,
                  controller: fieldController,
                  onTap: () {
                    field['on_tap']?.call(context, fieldController);
                  },
                  valid: (value) {
                    return validInput(value!, 0, 1000, "", required: required);
                  },
                ),
              );
            }),
            verticalGap(15),
            dialogButtonWidget(
              context,
              onPressed,
            ),
          ],
        ),
      ),
    ));
  }
}
