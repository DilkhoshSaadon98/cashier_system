import 'package:cashier_system/controller/items/items_controller.dart';
import 'package:cashier_system/core/class/handling_data_view.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/dialogs/delete_dialog.dart';
import 'package:cashier_system/core/dialogs/show_form_dialog.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/buttons/custom_floating_button.dart';
import 'package:cashier_system/data/model/item_details_model.dart';
import 'package:cashier_system/data/model/items_model.dart';
import 'package:cashier_system/view/items/widget/custom_update_widget.dart';
import 'package:cashier_system/view/items/widget/items_details_dialog.dart';
import 'package:cashier_system/view/items/widget/items_grid_card_widget.dart';
import 'package:cashier_system/view/widgets/tables/table_cell.dart';
import 'package:cashier_system/view/widgets/tables/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomShowItems extends StatelessWidget {
  const CustomShowItems({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ItemsViewController());

    void showDialogBox(ItemsModel dataItem) {
      controller.customShowPopupMenu.showPopupMenu(
        context,
        [
          TextRoutes.edit,
          TextRoutes.remove,
          TextRoutes.view,
          if (controller.showAddToCart!) TextRoutes.addToCart
        ],
        [
          () {
            controller.passDataForUpdate(dataItem);
            showFormDialog(context,
                addText: TextRoutes.addItems,
                editText: TextRoutes.editItem,
                isUpdate: true, onValue: (p0) {
              controller.clearFileds();
            }, child: const UpdateItemsWidget());
          },
          () => showDeleteDialog(
                context: context,
                title: TextRoutes.warning,
                content: TextRoutes.sureRemoveData,
                onPressed: () {
                  controller.deleteItems([dataItem.itemsId!]);
                  Get.back();
                },
              ),
          () => showItemDetailsDialog(
              context: context,
              item: dataItem,
              itemDetailsModel: ItemDetailsModel(itemId: dataItem.itemsId!),
              onDelete: () {
                controller.deleteItems([dataItem.itemsId!]);
                Get.back();
              },
              onEdit: () {
                Navigator.of(context).pop(false);
                showFormDialog(context,
                    addText: TextRoutes.addItems,
                    editText: TextRoutes.editItem,
                    isUpdate: true, onValue: (p0) {
                  controller.clearFileds();
                }, child: const UpdateItemsWidget());
              }),
          if (controller.showAddToCart!)
            () => controller.addItemsToCart(controller.selectedItems.isEmpty
                ? [dataItem.itemsId!]
                : controller.selectedItems),
        ],
      );
    }

    Widget buildCell(String text, var dataItem) => tableCell(
          text,
          onTap: () {
            showDialogBox(dataItem);
            controller.getItemDetailsData(dataItem.itemsId.toString());
          },
          onSecondaryTap: () {
            showDialogBox(dataItem);
            controller.getItemDetailsData(dataItem.itemsId.toString());
          },
          onTapDown: (value) =>
              controller.customShowPopupMenu.storeTapPosition(value),
        );

    return GetBuilder<ItemsViewController>(builder: (_) {
      return Scaffold(
        floatingActionButton: customFloatingButton(
            controller.showBackToTopButton, controller.scrollControllers!),
        body: Container(
          color: white,
          alignment: Alignment.topCenter,
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo is ScrollUpdateNotification &&
                  scrollInfo.scrollDelta != null &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent &&
                  scrollInfo.scrollDelta! > 0 &&
                  !controller.isLoading &&
                  scrollInfo.metrics.axis == Axis.vertical) {
                controller.getItemsData();
              }
              return false;
            },
            child: HandlingDataView(
              statusRequest: controller.statusRequest,
              child: controller.layoutDisplay
                  ? ItemsGridCardWidget(
                      controller: controller,
                    )
                  : TableWidget(
                      allSelected: controller.selectedItems.length ==
                          controller.data.length,
                      columns: const [
                        " ",
                        TextRoutes.code,
                        TextRoutes.itemsName,
                        TextRoutes.quantity,
                        TextRoutes.unit,
                        TextRoutes.sellingPrice,
                        TextRoutes.buyingPrice,
                        TextRoutes.costPrice,
                        TextRoutes.wholesalePrice,
                        TextRoutes.barcode,
                        TextRoutes.categories,
                        TextRoutes.explain,
                        TextRoutes.createDate,
                        TextRoutes.productionDate,
                        TextRoutes.expireDate,
                      ],
                      flexes: const [
                        1,
                        1,
                        2,
                        1,
                        1,
                        2,
                        2,
                        2,
                        2,
                        2,
                        2,
                        2,
                        2,
                        2,
                        2,
                        2
                      ],
                      onRowDoubleTap: (index) {
                        final dataItem = controller.data[index];
                        final isSelected =
                            controller.isSelected(dataItem.itemsId!);
                        controller.selectItem(dataItem.itemsId!, !isSelected);
                      },
                      onHeaderDoubleTap: (_) {
                        controller.selectAllRows();
                      },
                      verticalScrollController: controller.scrollControllers,
                      showHeader: true,
                      rows: List.generate(controller.data.length, (index) {
                        final item = controller.data[index];
                        final isSelected = controller.isSelected(item.itemsId!);
                        // final unitList = [
                        //   item.baseUnitName,
                        //   ...item.altUnits.map((u) => u.unitName),
                        // ].toSet().toList(); // Removes duplicates
                        return [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Checkbox(
                              value: isSelected,
                              onChanged: (checked) => controller.selectItem(
                                  item.itemsId!, checked ?? false),
                            ),
                          ),
                          buildCell(item.itemsId?.toString() ?? '', item),
                          buildCell(item.itemsName, item),
                          buildCell(item.itemsBaseQty.toString(), item),
                          buildCell(item.baseUnitName.toString(), item),
                          // DropDownMenu(
                          //   showBorder: false,
                          //   selectedValue: item.baseUnitName,
                          //   items: unitList,
                          //   onChanged: (String? newUnitName) {
                          //     if (newUnitName == null) return;

                          //     // Find the selected unit from main or alt units
                          //     AltUnit selectedUnit;
                          //     if (newUnitName == item.baseUnitName) {
                          //       selectedUnit = AltUnit(
                          //         unitId: item.mainUnitId,
                          //         unitName: item.baseUnitName,
                          //         price: item.itemsSellingPrice,
                          //         barcode: item.itemsBarcode,
                          //       );
                          //     } else {
                          //       selectedUnit = item.altUnits.firstWhere(
                          //           (u) => u.unitName == newUnitName);
                          //     }
                          //     controller.updateItemDetails(
                          //         item.itemsId!,
                          //         selectedUnit.barcode,
                          //         selectedUnit.price,
                          //         selectedUnit.unitName);
                          //   },
                          //   fieldColor: Colors.transparent,
                          //   contentColor: Colors.black,
                          // ),
                          buildCell(
                              formattingNumbers(item.itemsSellingPrice), item),
                          buildCell(
                              formattingNumbers(item.itemsBuyingPrice), item),
                          buildCell(
                              formattingNumbers(item.itemsCostPrice), item),
                          buildCell(formattingNumbers(item.itemsWholesalePrice),
                              item),
                          buildCell(item.itemsBarcode, item),
                          buildCell(item.categoriesName, item),
                          buildCell(item.itemsDescription, item),
                          buildCell(item.itemsCreateDate!, item),
                          buildCell(item.productionDate ?? "", item),
                          buildCell(item.expiryDate ?? "", item),
                          SizedBox(
                            key: isSelected ? const ValueKey("selected") : null,
                          ),
                        ];
                      }),
                    ),
            ),
          ),
        ),
      );
    });
  }
}
