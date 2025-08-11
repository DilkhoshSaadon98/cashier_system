// ignore_for_file: deprecated_member_use

import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/screen_routes.dart';
import 'package:cashier_system/core/dialogs/snackbar_helper.dart';
import 'package:cashier_system/core/functions/show_popup_menu.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/view/widgets/tables/table_cell.dart';
import 'package:cashier_system/view/widgets/tables/table_cell_change_number.dart';
import 'package:cashier_system/view/widgets/tables/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CashierTableRows extends StatelessWidget {
  const CashierTableRows({super.key});

  @override
  Widget build(BuildContext context) {
    final CustomShowPopupMenu popupMenu = CustomShowPopupMenu();
    final controller = Get.put(CashierController());
    bool showDialogOnce = true;

    void showDialogOption(String itemsId) {
      popupMenu.showPopupMenu(context, [
        TextRoutes.edit,
        TextRoutes.remove,
        TextRoutes.view,
      ], [
        () async {
          await controller.getItemsById(itemsId);
          Get.toNamed(AppRoute.itemsUpdateScreen, arguments: {
            "itemsModel": controller.dataItem[0],
            "screen_route": AppRoute.cashierScreen,
            'show_back': true
          });
        },
        () => controller.deleteCartItem([itemsId]),
        () async {
          await controller.getItemsById(itemsId);
        }
      ]);
    }

    Widget buildTableCell(String text, String id) {
      return tableCell(
        text,
        onTapDown: popupMenu.storeTapPosition,
        onTap: () => showDialogOption(id),
        onSecondaryTap: () => showDialogOption(id),
      );
    }

    return GetBuilder<CashierController>(builder: (controller) {
      final isNewCart =
          myServices.sharedPreferences.getBool("start_new_cart") ?? false;

      if (isNewCart || controller.cartData.isEmpty) {
        return Container(
          alignment: Alignment.center,
          color: white,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  TextRoutes.pleaseChooseItemsOrScanningABarcode.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: titleStyle.copyWith(fontSize: 20.sp),
                ),
              ),
              SizedBox(width: 10.w),
              Icon(Icons.qr_code_2, size: 24.sp),
            ],
          ),
        );
      }

      return Container(
        width: Get.width,
        color: white,
        alignment: Alignment.topCenter,
        child: TableWidget(
          allSelected:
              controller.selectedRows.length == controller.cartData.length,
          onRowDoubleTap: (index) {
            var item = controller.cartData[index];
            controller.selectItem(
                item.itemsId!, !controller.isSelected(item.itemsId!));
          },
          onHeaderDoubleTap: (index) => controller.selectAllRows(),
          columns: const [
            "",
            TextRoutes.itemsName,
            TextRoutes.price,
            TextRoutes.qty,
            TextRoutes.totalPrice,
            TextRoutes.stack,
            TextRoutes.code,
          ],
          flexes: const [1, 2, 1, 2, 2, 1, 1],
          rows: List.generate(controller.cartData.length, (index) {
            final item = controller.cartData[index];
            final isSelected = controller.isSelected(item.itemsId!);
            final isGift = item.cartItemGift == 1;

            final price = item.cartItemsPrice == 0.0
                ? item.itemsSellingPrice 
                : item.cartItemsPrice ;

            final total = controller.totalItemsPrice(
              price,
              item.cartItemsCount ,
              item.cartItemDiscount.toInt() ,
            );

            return [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Checkbox(
                  value: isSelected,
                  onChanged: (checked) =>
                      controller.selectItem(item.itemsId!, checked ?? false),
                ),
              ),
              buildTableCell(item.itemsName ?? "", item.itemsId.toString()),
              buildTableCell(price.toString(), item.itemsId.toString()),
              tableCellChangeNumber(
                item.cartItemsCount.toString(),
                onTapAdd: () {
                  if ((item.itemCount ?? 0) < (item.cartItemsCount ?? 0) &&
                      showDialogOnce) {
                    showErrorSnackBar(TextRoutes.emptyStock);
                    showDialogOnce = false;
                  }
                  controller.cartItemIncrease(
                    item.cartItemsCount!,
                    item.itemsId.toString(),
                  );
                },
                onTapRemove: () {
                  controller.cartItemDecrease(
                    item.cartItemsCount!,
                    item.itemsId.toString(),
                  );
                },
              ),
              buildTableCell(total.toString(), item.itemsId.toString()),
              buildTableCell(
                  item.itemCount.toString(), item.itemsId.toString()),
              buildTableCell(item.itemsId.toString(), item.itemsId.toString()),
              SizedBox(
                key: isSelected
                    ? const ValueKey("selected")
                    : isGift
                        ? const ValueKey("gift")
                        : null,
              ),
            ];
          }),
        ),
      );
    });
  }
}
