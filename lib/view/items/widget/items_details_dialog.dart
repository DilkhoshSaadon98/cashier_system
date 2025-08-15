import 'dart:io';

import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/data/model/item_details_model.dart';
import 'package:cashier_system/data/model/items_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ItemDetailContent extends StatelessWidget {
  final ItemsModel item;
  final ItemDetailsModel? itemDetailsModel;

  const ItemDetailContent({
    super.key,
    required this.item,
    this.itemDetailsModel,
  });

  @override
  Widget build(BuildContext context) {
    final String? imagePath =
        myServices.sharedPreferences.getString("image_path");
    final String imageFilePath = "$imagePath/${item.itemsImage}";

    return SizedBox(
      width: 320.w,
      height: Get.height / 2,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(imageFilePath),
            const SizedBox(height: 10),
            _buildDetailRow(TextRoutes.code.tr, item.itemsId.toString()),
            _buildDetailRow(TextRoutes.itemsName.tr, item.itemsName),
            _buildDetailRow(TextRoutes.barcode.tr, item.itemsBarcode),
            _buildDetailRow(TextRoutes.itemsDesc.tr, item.itemsDescription),
            _buildDetailRow(TextRoutes.categoriesName.tr, item.categoriesName),
            _buildDetailRow(TextRoutes.qty.tr, item.itemsBaseQty.toString()),
            _buildDetailRow(TextRoutes.baseUnit.tr, item.baseUnitName),
            _buildDetailRow(
                TextRoutes.price.tr, formattingNumbers(item.itemsSellingPrice)),
            _buildDetailRow(TextRoutes.buyingPrice.tr,
                formattingNumbers(item.itemsBuyingPrice)),
            _buildDetailRow(TextRoutes.wholesalePrice.tr,
                formattingNumbers(item.itemsWholesalePrice)),
            _buildDetailRow(TextRoutes.costPrice.tr,
                formattingNumbers(item.itemsCostPrice)),
            _buildDetailRow(
                TextRoutes.productionDate.tr, item.productionDate ?? "-"),
            _buildDetailRow(TextRoutes.expiryDate.tr, item.expiryDate ?? "-"),
            _buildDetailRow(
                TextRoutes.createDate.tr, item.itemsCreateDate ?? "-"),
            const Divider(color: primaryColor),
            Text(TextRoutes.itemDetails.tr, style: titleStyle),
            if (itemDetailsModel != null) ...[
              _buildDetailRow(TextRoutes.soldQuantity.tr,
                  itemDetailsModel!.soldQuantity.toString()),
              _buildDetailRow(TextRoutes.lastPurchasePrice.tr,
                  formattingNumbers(itemDetailsModel!.lastPurchasePrice)),
              _buildDetailRow(TextRoutes.currentStock.tr,
                  itemDetailsModel!.currentStock.toString()),
              _buildDetailRow(
                  TextRoutes.lastSupplier.tr, itemDetailsModel!.lastSupplier),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(String filePath) {
    return Container(
      width: Get.width,
      height: 150.h,
      alignment: Alignment.center,
      child: File(filePath).existsSync()
          ? Image.file(
              File(filePath),
              width: 100.w,
              height: 100.h,
              fit: BoxFit.contain,
            )
          : const Icon(Icons.broken_image_outlined, size: 50),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$label:",
              style: titleStyle.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value,
              style: bodyStyle,
            ),
          ),
        ],
      ),
    );
  }
}

void showItemDetailsDialog({
  required BuildContext context,
  required ItemsModel item,
  required ItemDetailsModel? itemDetailsModel,
  required VoidCallback onEdit,
  required VoidCallback onDelete,
}) {
  Get.defaultDialog(
    title: TextRoutes.items.tr,
    titleStyle: titleStyle.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
    content: ItemDetailContent(
      item: item,
      itemDetailsModel: itemDetailsModel,
    ),
    actions: [_buildActionButtons(onEdit, onDelete)],
  );
}

Widget _buildActionButtons(VoidCallback onEdit, VoidCallback onDelete) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      ElevatedButton.icon(
        onPressed: onEdit,
        icon: const Icon(Icons.edit, color: Colors.white),
        label: Text(TextRoutes.edit.tr,
            style: bodyStyle.copyWith(color: Colors.white)),
        style: ElevatedButton.styleFrom(backgroundColor: thirdColor),
      ),
      ElevatedButton.icon(
        onPressed: onDelete,
        icon: const Icon(Icons.remove, color: Colors.white),
        label: Text(TextRoutes.remove.tr,
            style: bodyStyle.copyWith(color: Colors.white)),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      ),
    ],
  );
}
