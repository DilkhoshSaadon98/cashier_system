import 'dart:io';
import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/controller/items/items_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/dialogs/show_form_dialog.dart';
import 'package:cashier_system/core/functions/show_popup_menu.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/custom_text_field_widget.dart';
import 'package:cashier_system/view/items/widget/custom_update_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomGridDataView extends StatelessWidget {
  const CustomGridDataView({super.key});

  int _calculateCrossAxisCount(double width) {
    if (width >= 500) return 4;
    if (width >= 300) return 3;
    if (width >= 200) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    Get.find<CashierController>();
    final imagePath =
        myServices.sharedPreferences.getString("image_path") ?? "";
    final CustomShowPopupMenu popupMenu = CustomShowPopupMenu();

    return GetBuilder<CashierController>(
      builder: (controller) {
        return Expanded(
          child: Container(
            decoration: const BoxDecoration(color: primaryColor),
            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
            child: Column(
              children: [
                //? Search For Categories Data:
                SizedBox(
                  height: 40.h,
                  child: CustomTextFieldWidget(
                    hinttext: TextRoutes.searchInCatagories,
                    labeltext: TextRoutes.searchInCatagories,
                    iconData: Icons.search,
                    valid: (value) => null,
                    borderColor: white,
                    fieldColor: primaryColor,
                    onChanged: (value) =>
                        controller.getCategoriesData(searchValue: value),
                    isNumber: false,
                  ),
                ),
                verticalGap(5),

                //? Categories Slider
                Container(
                  color: white,
                  height: 100.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.categoriesData.length,
                    itemBuilder: (context, index) {
                      final isSelected = controller.catNameController.text ==
                          controller.categoriesData[index].categoriesName;
                      return GestureDetector(
                        onTap: () {
                          controller.catNameController.text =
                              controller.categoriesData[index].categoriesName ??
                                  "";
                          controller.catID!.text = controller
                              .categoriesData[index].categoriesId
                              .toString();
                          controller.getItems(isInitialSearch: true);
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.symmetric(
                              vertical: 5.h, horizontal: 5.w),
                          padding: EdgeInsets.symmetric(
                              vertical: 5.h, horizontal: 5.w),
                          decoration: BoxDecoration(
                            color: isSelected ? secondColor : buttonColor,
                            borderRadius: BorderRadius.circular(constRadius),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (controller.categoriesData[index]
                                  .categoriesImage!.isNotEmpty)
                                Image.file(
                                    height: 60,
                                    width: 60,
                                    File(
                                        "$imagePath/${controller.categoriesData[index].categoriesImage}")),
                              Text(
                                controller
                                        .categoriesData[index].categoriesName ??
                                    "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: bodyStyle.copyWith(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                //? Search and GridView for Items:
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        height: 50.h,
                        alignment: Alignment.centerRight,
                        child: CustomTextFieldWidget(
                          hinttext: TextRoutes.searchItems,
                          labeltext: TextRoutes.searchItems,
                          iconData: Icons.search,
                          valid: (value) => null,
                          onChanged: (value) {
                            controller.itemsNameController.text = value;
                            controller.getItems(isInitialSearch: true);
                          },
                          borderColor: white,
                          fieldColor: primaryColor,
                          isNumber: false,
                        ),
                      ),

                      //? Items GridView:
                      Expanded(
                        child: Container(
                          color: white,
                          padding: const EdgeInsets.all(8.0),
                          child: controller.listDataSearch.isEmpty
                              ? Center(
                                  child: Text(TextRoutes.noData.tr,
                                      style: titleStyle))
                              : LayoutBuilder(
                                  builder: (context, constraints) {
                                    return GridView.builder(
                                        itemCount:
                                            controller.listDataSearch.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              _calculateCrossAxisCount(
                                                  constraints.maxWidth),
                                          crossAxisSpacing: 8.w,
                                          mainAxisSpacing: 8.h,
                                          childAspectRatio: 1.0,
                                        ),
                                        itemBuilder: (context, index) {
                                          final item =
                                              controller.listDataSearch[index];

                                          return GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            excludeFromSemantics: true,
                                            onTapDown:
                                                popupMenu.storeTapPosition,
                                            onLongPress: () async {
                                              ItemsViewController
                                                  itemsViewController = Get.put(
                                                      ItemsViewController());
                                              await controller
                                                  .getItemsById(item.itemsId!);
                                              itemsViewController
                                                  .passDataForUpdate(item);
                                              showFormDialog(context,
                                                  addText: TextRoutes.addItems,
                                                  editText: TextRoutes.editItem,
                                                  isUpdate: true,
                                                  onValue: (p0) {
                                                itemsViewController
                                                    .clearFileds();
                                                controller.getItems(
                                                    isInitialSearch: true);
                                              },
                                                  child:
                                                      const UpdateItemsWidget());
                                            },
                                            onSecondaryTap: () async {
                                              ItemsViewController
                                                  itemsViewController = Get.put(
                                                      ItemsViewController());
                                              await controller
                                                  .getItemsById(item.itemsId!);
                                              itemsViewController
                                                  .passDataForUpdate(item);
                                              showFormDialog(context,
                                                  addText: TextRoutes.addItems,
                                                  editText: TextRoutes.editItem,
                                                  isUpdate: true,
                                                  onValue: (p0) {
                                                itemsViewController
                                                    .clearFileds();
                                                controller.getItems(
                                                    isInitialSearch: true);
                                              },
                                                  child:
                                                      const UpdateItemsWidget());
                                            },
                                            onTap: () {
                                              controller.addItemsToCart(
                                                item.itemsId.toString(),
                                                controller.myServices
                                                    .systemSharedPreferences
                                                    .getString('cart_number')!,
                                              );
                                              controller.myServices
                                                  .systemSharedPreferences
                                                  .setBool(
                                                      "start_new_cart", false);
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  color: primaryColor
                                                      .withOpacity(.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          constRadius),
                                                ),
                                                alignment: Alignment.center,
                                                constraints: BoxConstraints(
                                                  maxWidth: 120.w,
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            constRadius),
                                                    border: Border.all(
                                                        width: 1,
                                                        color: primaryColor),
                                                    image: (item.itemsImage
                                                                .isNotEmpty &&
                                                            imagePath
                                                                .isNotEmpty)
                                                        ? DecorationImage(
                                                            image: FileImage(File(
                                                                "$imagePath/${item.itemsImage}")),
                                                            fit: BoxFit.fill,
                                                          )
                                                        : null,
                                                    color: primaryColor
                                                        .withOpacity(.3),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: (item.itemsImage
                                                              .isEmpty ||
                                                          imagePath.isEmpty)
                                                      ? Text(
                                                          item.itemsName,
                                                          style: bodyStyle
                                                              .copyWith(
                                                                  color: white),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.center,
                                                        )
                                                      : null,
                                                )),
                                          );
                                        });
                                  },
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
