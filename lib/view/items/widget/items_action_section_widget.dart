import 'package:cashier_system/controller/items/items_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/dialogs/delete_dialog.dart';
import 'package:cashier_system/core/dialogs/show_form_dialog.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/buttons/screen_action_buttons.dart';
import 'package:cashier_system/core/shared/custom_divider.dart';
import 'package:cashier_system/core/shared/custom_text_field_widget.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/drop_downs/sort_drop_down.dart';
import 'package:cashier_system/core/shared/drop_downs/transaction_accounts_dropdown_widget.dart';
import 'package:cashier_system/data/model/categories_model.dart';
import 'package:cashier_system/view/items/widget/custom_add_items.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../core/constant/color.dart';

class ItemsActionSectionWidget extends StatelessWidget {
  final ItemsViewController controller;
  final bool isMobile;
  const ItemsActionSectionWidget({
    super.key,
    required this.controller,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    Color backColor = isMobile ? white : primaryColor;
    Color textColor = isMobile ? primaryColor : white;
    return SizedBox(
      height: Get.height,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView(
            children: [
              if (!isMobile) ...[
                const CustomHeaderScreen(
                  showBackButton: true,
                  imagePath: AppImageAsset.itemsIcons,
                  title: TextRoutes.items,
                ),
                verticalGap(5),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    TextRoutes.totalItemsNumber.tr,
                    style: bodyStyle.copyWith(color: textColor),
                  ),
                  Text(
                    controller.totalItemsCount.toString(),
                    style: bodyStyle.copyWith(color: textColor),
                  ),
                ],
              ),
              customDivider(textColor),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    TextRoutes.totalItemsPrice.tr,
                    style: bodyStyle.copyWith(color: textColor),
                  ),
                  Text(
                    formattingNumbers(controller.totalItemsPrice),
                    style: bodyStyle.copyWith(color: textColor),
                  ),
                ],
              ),
              customDivider(textColor),
              Text(
                TextRoutes.sortBy.tr,
                style: bodyStyle.copyWith(color: textColor),
              ),
              verticalGap(5),
              SortDropdown(
                selectedValue: controller.selectedSortField,
                items: controller.sortFields,
                onChanged: controller.changeSortField,
                contentColor: white,
                fieldColor: sortFieldColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.sortAscending
                        ? TextRoutes.sortAsc.tr
                        : TextRoutes.sortDesc.tr,
                    style: bodyStyle.copyWith(color: textColor),
                  ),
                  IconButton(
                    icon: Icon(
                      controller.sortAscending
                          ? FontAwesomeIcons.arrowDownAZ
                          : FontAwesomeIcons.arrowDownZA,
                      color: textColor,
                    ),
                    onPressed: controller.toggleSortOrder,
                    tooltip: controller.sortAscending
                        ? TextRoutes.sortAsc
                        : TextRoutes.sortDesc,
                  ),
                ],
              ),
              customDivider(),
              Text(
                TextRoutes.searchBy.tr,
                style: bodyStyle.copyWith(color: textColor),
              ),
              verticalGap(5),
              FocusTraversalGroup(
                policy: WidgetOrderTraversalPolicy(),
                child: Form(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.searchFields.length,
                    itemBuilder: (context, index) {
                      final fields = controller.searchFields[index];
                      final title = fields['title'];
                      final icon = fields['icon'];
                      final readOnly = fields['read_only'];
                      final valid = fields['valid'];
                      final ctrl = fields['controller'];
                      if (title == TextRoutes.chooseCategories) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: CustomDropdownSearchWidget<CategoriesModel>(
                            iconData: Icons.layers_outlined,
                            label: TextRoutes.chooseCategories.tr,
                            items: controller.dropDownListCategoriesData,
                            borderColor: textColor,
                            fieldColor: backColor,
                            itemToString: (p0) {
                              return p0.categoriesName!;
                            },
                            validator: (value) {
                              if (value != null) {
                                return validInput(
                                  value.categoriesName!,
                                  0,
                                  1000,
                                  valid,
                                );
                              }
                              return validInput("", 0, 1000, valid);
                            },
                            selectedItem: controller.selectedCat,
                            onChanged: (value) {
                              if (value != null) {
                                controller.selectedCatId = value.categoriesId;
                                controller.selectedCat = value;
                              }
                            },
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            CustomTextFieldWidget(
                              controller: ctrl,
                              hinttext: title,
                              labeltext: title,
                              iconData: icon,
                              valid: (value) {
                                return validInput(value!, 0, 100, valid);
                              },
                              onTap: fields['on_tap'],
                              readOnly: readOnly,
                              fieldColor: backColor,
                              borderColor: textColor,
                              isNumber:
                                  valid == 'number' || valid == 'realNumber'
                                      ? true
                                      : false,
                            ),
                            verticalGap(10),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
              verticalGap(40),
            ],
          ),
          screenActionButtonWidget(context, backColor: backColor,
              onPressedAdd: () {
            showFormDialog(context,
                addText: TextRoutes.addItems,
                editText: TextRoutes.editItem,
                isUpdate: false,
                child: const AddItems());
          }, onPressedClear: () {
            controller.clearSearchFileds();
          }, onPressedPrint: () {
            controller.printData();
          }, onPressedRemove: () {
            showDeleteDialog(
                context: context,
                title: "",
                content: "",
                onPressed: () {
                  controller.deleteItems(controller.selectedItems);
                  Get.back();
                });
          }, onPressedSearch: () {
            controller.getItemsData(isInitialSearch: true);
          }, onPressedGrid: () {
            controller.changeLayout();
          })
        ],
      ),
    );
  }
}
