import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_divider.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';

class AccountMenuModel {
  final String name;
  final double balance;
  final List<AccountMenuModel> children;

  AccountMenuModel({
    required this.name,
    required this.balance,
    this.children = const [],
  });
}

class AccountTreeItem extends StatelessWidget {
  final AccountMenuModel account;
  final int depth;

  const AccountTreeItem({
    super.key,
    required this.account,
    this.depth = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: depth * 16.0, top: 4, bottom: 4),
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (account.children.isNotEmpty)
                      const Icon(Icons.folder, color: Colors.orange)
                    else
                      const Icon(Icons.file_open, color: Colors.grey),
                    horizontalGap(),
                    Text(account.name.tr, style: bodyStyle),
                  ],
                ),
                horizontalGap(25),
                Text(
                  formattingNumbers(account.balance),
                  style: bodyStyle,
                ),
              ],
            ),
          ),
        ),
        ...account.children.map((child) => AccountTreeItem(
              account: child,
              depth: depth + 1,
            )),
      ],
    );
  }
}

class BalanceSheetView extends StatelessWidget {
  final List<AccountMenuModel> rootAccounts;
  const BalanceSheetView({super.key, required this.rootAccounts});

  @override
  Widget build(BuildContext context) {
    double getTotalBalance(List<AccountMenuModel> accounts) {
      return accounts.fold(0.0, (sum, acc) => sum + acc.balance);
    }

    final totalBalance = getTotalBalance(rootAccounts);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rootAccounts.map((account) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(constRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.name.tr,
                      style: titleStyle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    customDivider(),
                    AccountTreeItem(account: account),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: buttonColor,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 15,
            children: [
              Text(
                TextRoutes.totalBallance.tr,
                style: titleStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                formattingNumbers(totalBalance),
                style: titleStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
