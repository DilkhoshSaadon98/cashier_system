import 'dart:io';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/data/model/items_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/data/model/item_details_model.dart';
import 'package:cashier_system/view/items/widget/items_details_dialog.dart';
import 'package:cashier_system/controller/items/items_view_controller.dart';

class ItemsGridCardWidget extends StatelessWidget {
  final ItemsViewController controller;
  const ItemsGridCardWidget({super.key, required this.controller});

  int _calculateCrossAxisCount(double width) {
    if (width >= 1200) return 6;
    if (width >= 900) return 5;
    if (width >= 700) return 4;
    if (width >= 500) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GridView.builder(
            itemCount: controller.data.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _calculateCrossAxisCount(constraints.maxWidth),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 240,
            ),
            itemBuilder: (_, index) {
              var item = controller.data[index];
              final imagePath =
                  myServices.sharedPreferences.getString("image_path") ?? "";
              final imageFilePath = "$imagePath/${item.itemsImage}";

              return _buildItemCard(context, item, imageFilePath);
            },
          );
        },
      ),
    );
  }

  Widget _buildItemCard(
      BuildContext context, ItemsModel item, String imageFilePath) {
    return GestureDetector(
      onTap: () => _showDetails(context, item),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(2, 4),
              ),
            ],
            border: Border.all(color: primaryColor.withOpacity(0.1)),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Hero(
                      tag: "item_${item.itemsId}",
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: File(imageFilePath).existsSync()
                            ? Image.file(File(imageFilePath),
                                fit: BoxFit.contain)
                            : SvgPicture.asset(
                                AppImageAsset.itemsIcons,
                                fit: BoxFit.contain,
                                color: primaryColor,
                              ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      item.itemsName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: titleStyle.copyWith(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      formattingNumbers(item.itemsSellingPrice),
                      style: bodyStyle.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "${TextRoutes.itemsCount.tr}: ${item.itemsCount}",
                      style: bodyStyle.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.blue.shade50,
                  child: IconButton(
                    icon: const Icon(Icons.edit, size: 16, color: Colors.blue),
                    onPressed: () => controller.goUpdateItems(item),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, dynamic item) {
    showItemDetailsDialog(
      context: context,
      item: item,
      itemDetailsModel: ItemDetailsModel(itemId: item.itemsId),
      onDelete: () {},
      onEdit: () {
        Navigator.of(context).pop(false);
        controller.goUpdateItems(item);
      },
    );
  }
}
