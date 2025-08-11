import 'package:cashier_system/controller/items/items_view_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_divider.dart';
import 'package:cashier_system/core/shared/custom_text_field_widget.dart';
import 'package:cashier_system/core/shared/drop_downs/custom_drop_down_search.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/drop_downs/sort_drop_down.dart';
import 'package:cashier_system/view/items/widget/items_button_actions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class MobileActionWidget extends StatelessWidget {
  const MobileActionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ItemsViewController>(
        init: ItemsViewController(),
        builder: (controller) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(TextRoutes.totalItemsNumber.tr, style: bodyStyle),
                      Text(controller.totalItemsCount.toString(),
                          style: bodyStyle),
                    ],
                  ),
                  customDivider(primaryColor),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(TextRoutes.totalItemsPrice.tr, style: bodyStyle),
                      Text(formattingNumbers(controller.totalItemsPrice),
                          style: bodyStyle),
                    ],
                  ),
                  customDivider(primaryColor),
                  verticalGap(5),
                  SortDropdown(
                    selectedValue: controller.selectedSortField,
                    items: controller.sortFields,
                    onChanged: controller.changeSortField,
                    contentColor: white,
                    fieldColor: primaryColor,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        controller.sortAscending
                            ? TextRoutes.sortAsc
                            : TextRoutes.sortDesc,
                        style: titleStyle,
                      ),
                      IconButton(
                        icon: Icon(
                          controller.sortAscending
                              ? FontAwesomeIcons.arrowDownAZ
                              : FontAwesomeIcons.arrowDownZA,
                          color: primaryColor,
                        ),
                        onPressed: controller.toggleSortOrder,
                      ),
                    ],
                  ),
                  Text(
                    TextRoutes.searchBy.tr,
                    style: titleStyle.copyWith(),
                  ),
                  verticalGap(5),
                  ListView.builder(
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
                        return Column(
                          children: [
                            CustomDropDownSearch(
                              iconData: Icons.layers_outlined,
                              title: TextRoutes.chooseCategories.tr,
                              listData: controller.dropDownListCategories,
                              contrllerName: ctrl,
                              contrllerId: controller.catIdController,
                              color: primaryColor,
                              fieldColor: white,
                              valid: (value) {
                                return validInput(value!, 0, 100, valid);
                              },
                            ),
                            verticalGap(10),
                          ],
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
                              onTapIcon: fields['on_tap'],
                              suffixIconData: fields['suffix_icon'],
                              readOnly: readOnly,
                              fieldColor: white,
                              borderColor: primaryColor,
                              isNumber: false,
                            ),
                            verticalGap(10),
                          ],
                        );
                      }
                    },
                  ),
                  verticalGap(40),
                ],
              ),
              itemsActionButtonsWidget(controller, context, white)
            ],
          );
        });
  }
}

class InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const InfoRow({required this.title, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: titleStyle.copyWith(color: primaryColor),
        ),
        Text(
          value,
          style: titleStyle.copyWith(color: primaryColor),
        ),
      ],
    );
  }
}
