// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/dialogs/snackbar_helper.dart';
import 'package:cashier_system/core/functions/show_popup_menu.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/drop_downs/drop_down_menu.dart';
import 'package:cashier_system/data/model/items_model.dart';
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
    Timer? debounce;
    void showDialogOption(int itemsId) {
      popupMenu.showPopupMenu(context, [
        TextRoutes.remove,
        //    TextRoutes.view,
      ], [
        () => controller.deleteCartItem([itemsId]),
        // () async {
        //   await controller.getItemsById(itemsId);
        // }
      ]);
    }

    Widget buildTableCell(String text, int id) {
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
                item.itemsId, !controller.isSelected(item.cartItemsId));
          },
          onHeaderDoubleTap: (index) => controller.selectAllRows(),
          columns: const [
            "",
            TextRoutes.itemsName,
            TextRoutes.price,
            TextRoutes.qty,
            TextRoutes.totalPrice,
            TextRoutes.unit,
            TextRoutes.stack,
            TextRoutes.code,
            TextRoutes.note,
          ],
          flexes: const [1, 2, 1, 1, 2, 2, 1, 1, 2],
          rows: List.generate(controller.cartData.length, (index) {
            final item = controller.cartData[index];
            final isSelected = controller.isSelected(item.cartItemsId);
            final isGift = item.cartItemGift == 1;

            final price = item.cartItemsPrice == 0.0
                ? item.itemsSellingPrice
                : item.cartItemsPrice;

            final total = controller.totalItemsPrice(
              price,
              item.cartItemsCount,
              item.cartItemDiscount.toInt(),
            );
            final unitItems = {
              item.mainUnitName,
              ...item.altUnits.map((u) => u.unitName),
            }.where((u) => u.isNotEmpty).toList();
            return [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Checkbox(
                  value: isSelected,
                  onChanged: (checked) =>
                      controller.selectItem(item.cartItemsId, checked ?? false),
                ),
              ),
              buildTableCell(item.itemsName, item.cartItemsId),
              buildTableCell(price.toString(), item.cartItemsId),
              tableCellChangeNumber(
                onValueChanged: (p0) {
                  if (debounce?.isActive ?? false) debounce!.cancel();

                  debounce = Timer(const Duration(milliseconds: 500), () {
                    final safeValue = (p0.toString().trim().isEmpty) ? 1 : p0;

                    controller.updateItemQuantity(
                        [item.cartItemsId], safeValue.toString());
                  });
                },
                item.cartItemsCount.toString(),
                onTapAdd: () {
                  if (item.itemCount < item.cartItemsCount && showDialogOnce) {
                    showErrorSnackBar(TextRoutes.emptyStock);
                    showDialogOnce = false;
                  }
                  controller.cartItemIncrease(
                    item.cartItemsCount,
                    item.cartItemsId,
                  );
                },
                onTapRemove: () {
                  controller.cartItemDecrease(
                    item.cartItemsCount,
                    item.cartItemsId,
                  );
                },
              ),
              buildTableCell(total.toString(), item.cartItemsId),
              DropDownMenu(
                showBorder: false,
                selectedValue: item.selectedUnitName!,
                items: unitItems,
                onChanged: (newUnit) {
                  if (newUnit == null) return;

                  AltUnit selectedUnit;

                  if (newUnit == item.mainUnitName) {
                    // Selected the main unit
                    selectedUnit = AltUnit(
                      unitId: 0,
                      price: item.itemsSellingPrice,
                      unitName: item.mainUnitName,
                      unitFactor: item.unitFactor,
                    );
                  } else {
                    // Selected one of the alt units
                    selectedUnit = item.altUnits.firstWhere(
                        (u) => u.unitName == newUnit,
                        orElse: () => AltUnit(
                            unitId: 0,
                            price: item.itemsSellingPrice,
                            unitName: item.mainUnitName,
                            unitFactor: item.unitFactor));
                  }

                  // Update item details
                  controller.updateItemDetails(
                    item.cartItemsId,
                    item.cartNumber,
                    selectedUnit.price,
                    selectedUnit.unitName,
                    selectedUnit.unitFactor,
                  );
                },
              ),
              buildTableCell(item.itemCount.toString(), item.cartItemsId),
              buildTableCell(item.cartItemsId.toString(), item.cartItemsId),
              buildTableCell(
                  item.cartNote ?? TextRoutes.noData.tr, item.cartItemsId),
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
