// ignore_for_file: deprecated_member_use

import 'package:cashier_system/controller/add_account_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/dialogs/show_form_dialog.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/responsive/divide_screen_widget.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/data/model/account_model.dart';
import 'package:cashier_system/view/add_account/components/show_add_account_dialog.dart';
import 'package:cashier_system/view/widgets/tables/table_cell.dart';
import 'package:cashier_system/view/widgets/tables/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddAccountScreenWindows extends StatelessWidget {
  const AddAccountScreenWindows({super.key});

  @override
  Widget build(BuildContext context) {
    return DivideScreenWidget(
        actionWidget: Column(
          children: [
            const CustomHeaderScreen(
              title: TextRoutes.accountingAccounts,
              imagePath: AppImageAsset.accountingSvg,
            ),
            verticalGap(),
          ],
        ),
        showWidget: Row(
          children: [
            GetBuilder<AddAccountController>(builder: (controller) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        width: Get.width,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: primaryColor.withOpacity(.5),
                            borderRadius: BorderRadius.circular(constRadius)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(TextRoutes.accountList.tr,
                                style: titleStyle.copyWith(color: white)),
                            horizontalGap(),
                            const Icon(
                              Icons.list,
                              color: white,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: controller.treeAccounts
                              .map((acc) => AccountTreeAccount(account: acc))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            //? Show Data Widget:
            Expanded(
                child: GetBuilder<AddAccountController>(builder: (controller) {
              return TableWidget(
                allSelected: false,
                columns: const [
                  " ",
                  TextRoutes.code,
                  TextRoutes.accountType,
                  TextRoutes.accountType,
                  TextRoutes.ballance,
                ],
                flexes: const [1, 1, 2, 1, 2],
                onRowDoubleTap: (index) {},
                onHeaderDoubleTap: (_) {
                  //  controller.selectAllRows();
                },
                //verticalScrollController: controller.scrollControllers,
                showHeader: true,
                rows: List.generate(controller.allAccountsData.length, (index) {
                  final account = controller.allAccountsData[index];
                  //      final isSelected = controller.isSelected(account.accountId!);

                  return [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Checkbox(
                        value: false,
                        onChanged: (checked) {
                          // controller.selectaccount(account.id, checked ?? false)
                        },
                      ),
                    ),
                    tableCell(account.accountId.toString()),
                    tableCell(account.accountName.toString().toLowerCase().tr),
                    tableCell(account.accountType.toString().toLowerCase().tr),
                    tableCell(formattingNumbers(account.accountBalance)),
                    const SizedBox(
                      // ignore: dead_code
                      key: false ? ValueKey("selected") : null,
                    ),
                  ];
                }),
              );
            }))
          ],
        ));
  }
}

class AccountTreeAccount extends StatelessWidget {
  final AccountModel account;
  final int depth;

  const AccountTreeAccount({
    super.key,
    required this.account,
    this.depth = 0,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddAccountController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(right: depth * 16.0),
          child: Row(
            children: [
              if (account.accountChildren.isNotEmpty)
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        account.isExpanded
                            ? Icons.expand_less
                            : Icons.expand_more,
                        color: Colors.orange,
                      ),
                      onPressed: () => controller.toggleExpanded(account),
                    ),
                    const Icon(
                      Icons.folder,
                      color: Colors.orange,
                    ),
                  ],
                )
              else
                const Icon(Icons.description, color: Colors.grey),
              horizontalGap(5),
              Row(
                children: [
                  Tooltip(
                    message: account.accountNote ?? "",
                    child: Text(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      account.accountName.toString().toLowerCase().tr,
                      style: account.isExpanded ? titleStyle : bodyStyle,
                    ),
                  ),
                  if (!account.accountChildren.isNotEmpty)
                    Tooltip(
                      message: account.accountNote ?? "",
                      child: Text(
                        "(${formattingNumbers(account.accountBalance)})",
                        style: account.isExpanded
                            ? titleStyle
                            : bodyStyle.copyWith(color: Colors.teal),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              if (account.accountChildren.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.add_box, color: Colors.green),
                  onPressed: () {
                    controller.clearAccountsFields();
                    controller.accountParentId = account.accountId.toString();
                    controller.accountTypeStr = account.accountType;
                    showFormDialog(context,
                        isUpdate: false,
                        addText: TextRoutes.addAccount,
                        editText: TextRoutes.editAccount,
                        child: const ShowAddAccountDialog(
                          isUpdate: false,
                        ));
                  },
                ),
              IconButton(
                icon: const Icon(Icons.edit_note_sharp, color: Colors.blue),
                onPressed: () {
                  controller.accountId = account.accountId.toString();
                  controller.accountCodeController.text =
                      account.accountCode.toString();
                  controller.accountNameController.text =
                      account.accountName ?? '';
                  controller.accountNoteController.text =
                      account.accountNote ?? '';
                  showFormDialog(context,
                      isUpdate: true,
                      addText: TextRoutes.addAccount,
                      editText: TextRoutes.editAccount,
                      child: const ShowAddAccountDialog(
                        isUpdate: true,
                      ));
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  controller.deleteAccountData(context, account.accountId!);
                },
              ),
              IconButton(
                icon: Icon(Icons.search, color: buttonColor),
                onPressed: () {
                  controller.searchAccountData(account.accountId.toString());
                },
              ),
            ],
          ),
        ),
        if (account.isExpanded)
          ...account.accountChildren.map((child) => AccountTreeAccount(
                account: child,
                depth: depth + 1,
              )),
      ],
    );
  }
}
