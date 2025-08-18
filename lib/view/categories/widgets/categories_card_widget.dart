// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'package:cashier_system/controller/catagories/catagories_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/dialogs/delete_dialog.dart';
import 'package:cashier_system/core/dialogs/show_form_dialog.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/view/categories/widgets/add_category_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

Widget categoriesCardWidget(
    CatagoriesController controller, int index, BuildContext context) {
  var dataItem = controller.data[index];
  final int itemsCount = dataItem.itemsCount ?? 0;
  final String? imagePath =
      myServices.sharedPreferences.getString("image_path");
  final String imageFilePath = "$imagePath/${dataItem.categoriesImage}";
  return GestureDetector(
    onTap: () {
      if ((dataItem.categoriesImage ?? "").isNotEmpty) {
        controller.file = File(
            "${myServices.sharedPreferences.getString('image_path')!}/${dataItem.categoriesImage}");
      }
      controller.catagoriesName?.text = dataItem.categoriesName ?? "";
      controller.catagoriesId?.text = dataItem.categoriesId.toString();
      showFormDialog(context,
          addText: TextRoutes.addCategories,
          editText: TextRoutes.editCategories,
          isUpdate: true,
          child: const AddCategoryForm(
            isUpdate: true,
          ));
    },
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primaryColor.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
              dataItem.categoriesName ?? TextRoutes.unknown,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: titleStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: black,
              ),
            ),
            verticalGap(6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "$itemsCount ${TextRoutes.items.tr}",
                style: bodyStyle.copyWith(
                  fontSize: 14,
                  color: primaryColor,
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  tooltip: TextRoutes.edit.tr,
                  onPressed: () {
                    if ((dataItem.categoriesImage ?? "").isNotEmpty) {
                      controller.file = File(
                          "${myServices.sharedPreferences.getString('image_path')!}/${dataItem.categoriesImage}");
                    }
                    controller.catagoriesName?.text =
                        dataItem.categoriesName ?? "";
                    controller.catagoriesId?.text =
                        dataItem.categoriesId.toString();
                    showFormDialog(context,
                        addText: TextRoutes.addCategories,
                        editText: TextRoutes.editCategories,
                        isUpdate: true,
                        child: const AddCategoryForm(
                          isUpdate: true,
                        ));
                  },
                ),
                itemsCount == 0
                    ? IconButton(
                        icon:
                            const Icon(Icons.delete_outline, color: Colors.red),
                        tooltip: TextRoutes.remove.tr,
                        onPressed: () {
                          showDeleteDialog(
                            context: context,
                            title: TextRoutes.remove.tr,
                            content: TextRoutes.sureRemoveData.tr,
                            onPressed: () async {
                              await controller.deleteCategoriesData(
                                  dataItem.categoriesId.toString());
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            },
                          );
                        },
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
