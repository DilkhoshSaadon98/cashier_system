// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:cashier_system/controller/items/items_view_controller.dart';
import 'package:cashier_system/core/class/handling_data_view.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/dialogs/delete_dialog.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/buttons/custom_floating_button.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/data/model/item_details_model.dart';
import 'package:cashier_system/data/model/items_model.dart';
import 'package:cashier_system/view/items/widget/items_details_dialog.dart';
import 'package:cashier_system/view/widgets/tables/table_cell.dart';
import 'package:cashier_system/view/widgets/tables/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CustomShowItems extends StatelessWidget {
  const CustomShowItems({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ItemsViewController());
    int calculateCrossAxisCount(double width) {
      if (width >= 1000) return 5;
      if (width >= 700) return 4;
      if (width >= 500) return 3;
      if (width >= 300) return 2;
      return 1;
    }

    void showDialogBox(ItemsModel dataItem) {
      controller.customShowPopupMenu.showPopupMenu(
        context,
        [
          TextRoutes.edit,
          TextRoutes.remove,
          TextRoutes.showData,
          if (controller.showAddToCart!) TextRoutes.addToCart
        ],
        [
          () => controller.goUpdateItems(
                dataItem,
              ),
          () => showDeleteDialog(
                context: context,
                title: TextRoutes.warning,
                content: TextRoutes.sureRemoveData,
                onPressed: () {
                  // controller.deleteItems([dataItem.itemsId]);
                  // Navigator.of(context).pop(false);
                },
              ),
          () => showItemDetailsDialog(
              context: context,
              item: dataItem,
              itemDetailsModel: ItemDetailsModel(itemId: dataItem.itemsId!),
              onDelete: () {},
              onEdit: () {
                Navigator.of(context).pop(false);
                controller.goUpdateItems(
                  dataItem,
                );
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
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return GridView.builder(
                            itemCount: controller.data.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  calculateCrossAxisCount(constraints.maxWidth),
                              mainAxisExtent: 200,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                            ),
                            itemBuilder: (_, index) {
                              var dataItem = controller.data[index];
                              final String? imagePath = myServices
                                  .sharedPreferences
                                  .getString("image_path");
                              final String imageFilePath =
                                  "$imagePath/${dataItem.itemsImage}";
                              return GestureDetector(
                                onTap: () {
                                  showItemDetailsDialog(
                                      context: context,
                                      item: dataItem,
                                      itemDetailsModel:
                                          ItemDetailsModel(itemId: 1),
                                      onDelete: () {
                                        // showDeleteDialog(
                                        //     context: context,
                                        //     title: "",
                                        //     content: "",
                                        //     onPressed: () {});
                                      },
                                      onEdit: () {
                                        Navigator.of(context).pop(false);
                                        controller.goUpdateItems(
                                          dataItem,
                                        );
                                      });
                                },
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                          color: primaryColor.withOpacity(0.2)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 8,
                                          offset: const Offset(2, 4),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: IconButton(
                                            icon: const Icon(Icons.edit,
                                                color: Colors.blue),
                                            tooltip: TextRoutes.edit.tr,
                                            onPressed: () => controller
                                                .goUpdateItems(dataItem),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: IconButton(
                                              icon: const Icon(
                                                  Icons.remove_red_eye,
                                                  color: Colors.greenAccent),
                                              tooltip: TextRoutes.edit.tr,
                                              onPressed: () {
                                                showItemDetailsDialog(
                                                    context: context,
                                                    item: dataItem,
                                                    itemDetailsModel:
                                                        ItemDetailsModel(
                                                            itemId: 1),
                                                    onDelete: () {
                                                      // showDeleteDialog(
                                                      //     context: context,
                                                      //     title: "",
                                                      //     content: "",
                                                      //     onPressed: () {});
                                                    },
                                                    onEdit: () {
                                                      Navigator.of(context)
                                                          .pop(false);
                                                      controller.goUpdateItems(
                                                        dataItem,
                                                      );
                                                    });
                                              }),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            File(imageFilePath).existsSync()
                                                ? Image.file(
                                                    File(imageFilePath),
                                                    width: 50,
                                                    height: 50,
                                                    fit: BoxFit.contain,
                                                  )
                                                : SvgPicture.asset(
                                                    AppImageAsset.itemsIcons,
                                                    width: 50,
                                                    height: 50,
                                                    color: primaryColor,
                                                  ),
                                            verticalGap(10),
                                            Text(
                                              dataItem.itemsName,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: titleStyle.copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
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
                        TextRoutes.profits,
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
                        1,
                        1,
                        1,
                        1,
                        1,
                        1,
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
                          buildCell(item.unitName.toString(), item),
                          buildCell(
                              formattingNumbers((item.itemsSellingPrice) -
                                  (item.itemsBuyingPrice)),
                              item),
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
