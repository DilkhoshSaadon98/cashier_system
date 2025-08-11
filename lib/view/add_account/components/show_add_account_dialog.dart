import 'package:cashier_system/controller/add_account_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/custom_text_field_widget.dart';
import 'package:cashier_system/view/categories/widgets/add_category_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ShowAddAccountDialog extends StatelessWidget {
  final bool isUpdate;
  const ShowAddAccountDialog({
    required this.isUpdate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GetBuilder<AddAccountController>(
          init: AddAccountController(),
          autoRemove: false,
          builder: (controller) {
            return Form(
              key: controller.formState,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      children: [
                        CustomTextFieldWidget(
                          hinttext: TextRoutes.accountName,
                          labeltext: TextRoutes.accountName,
                          iconData: Icons.category,
                          controller: controller.accountNameController,
                          valid: (value) => validInput(value ?? '', 0, 100, "",
                              required: true),
                          fieldColor: white,
                          borderColor: primaryColor,
                          isNumber: false,
                        ),
                        verticalGap(),
                        CustomTextFieldWidget(
                          hinttext: TextRoutes.accountCode,
                          labeltext: TextRoutes.accountCode,
                          iconData: Icons.category,
                          controller: controller.accountCodeController,
                          valid: (value) => validInput(
                              value ?? '', 0, 100, "code",
                              required: false),
                          fieldColor: white,
                          borderColor: primaryColor,
                          isNumber: false,
                        ),
                        verticalGap(),
                        CustomTextFieldWidget(
                          hinttext: TextRoutes.note,
                          labeltext: TextRoutes.note,
                          iconData: Icons.category,
                          controller: controller.accountNoteController,
                          valid: (value) => validInput(value ?? '', 0, 1000, "",
                              required: false),
                          fieldColor: white,
                          borderColor: primaryColor,
                          isNumber: false,
                        ),
                      ],
                    ),
                    verticalGap(15),
                    dialogButtonWidget(
                      context,
                      () async {
                        isUpdate
                            ? await controller.updateAccountData(context)
                            : await controller.addAccountsData(context);
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
