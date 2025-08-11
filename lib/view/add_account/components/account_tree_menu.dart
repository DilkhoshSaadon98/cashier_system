import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/data/model/locale/account_menu_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';

class AccountTreeItem extends StatelessWidget {
  final AccountMenuModel account;
  final int depth;
  final void Function(AccountMenuModel)? onAdd;
  final void Function(AccountMenuModel)? onEdit;
  final void Function(AccountMenuModel)? onDelete;

  const AccountTreeItem({
    super.key,
    required this.account,
    this.depth = 0,
    this.onAdd,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: depth * 16.0),
          child: SizedBox(
            width: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (account.children.isNotEmpty)
                  const Icon(Icons.folder, color: Colors.orange)
                else
                  const Icon(Icons.description, color: Colors.grey),
                horizontalGap(),
                Text(
                  account.name.tr,
                  style: titleStyle,
                ),
                IconButton(
                  icon: Icon(Icons.add_circle, color: Colors.green),
                  onPressed: () => onAdd?.call(account),
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => onEdit?.call(account),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => onDelete?.call(account),
                ),
              ],
            ),
          ),
        ),
        ...account.children.map((child) => AccountTreeItem(
              account: child,
              depth: depth + 1,
              onAdd: onAdd,
              onEdit: onEdit,
              onDelete: onDelete,
            )),
      ],
    );
  }
}
