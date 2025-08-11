import 'package:cashier_system/controller/items/items_view_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/responsive/divide_screen_widget.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/custom_divider.dart';
import 'package:cashier_system/core/shared/custom_text_field_widget.dart';
import 'package:cashier_system/core/shared/drop_downs/custom_drop_down_search.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/drop_downs/sort_drop_down.dart';
import 'package:cashier_system/view/items/widget/custom_show_items.dart';
import 'package:cashier_system/view/items/widget/items_button_actions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../core/constant/color.dart';

class ItemsViewScreenWindows extends StatelessWidget {
  const ItemsViewScreenWindows({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ItemsViewController());
    return Scaffold(
      body: GetBuilder<ItemsViewController>(builder: (controller) {
        return DivideScreenWidget(
          showWidget: Scaffold(
              appBar: customAppBarTitle(TextRoutes.items),
              body: const CustomShowItems()),
          actionWidget: SizedBox(
            height: Get.height,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ListView(
                  children: [
                    const CustomHeaderScreen(
                      showBackButton: true,
                      imagePath: AppImageAsset.itemsIcons,
                      title: TextRoutes.items,
                    ),
                    verticalGap(5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          TextRoutes.totalItemsNumber.tr,
                          style: bodyStyle.copyWith(color: white),
                        ),
                        Text(
                          controller.totalItemsCount.toString(),
                          style: bodyStyle.copyWith(color: white),
                        ),
                      ],
                    ),
                    customDivider(white),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          TextRoutes.totalItemsPrice.tr,
                          style: bodyStyle.copyWith(color: white),
                        ),
                        Text(
                          formattingNumbers(controller.totalItemsPrice),
                          style: bodyStyle.copyWith(color: white),
                        ),
                      ],
                    ),
                    customDivider(white),
                    Text(
                      TextRoutes.sortBy.tr,
                      style: bodyStyle.copyWith(color: white),
                    ),
                    verticalGap(5),
                    SortDropdown(
                      selectedValue: controller.selectedSortField,
                      items: controller.sortFields,
                      onChanged: controller.changeSortField,
                      contentColor: primaryColor,
                      fieldColor: white,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.sortAscending
                              ? TextRoutes.sortAsc
                              : TextRoutes.sortDesc,
                          style: bodyStyle.copyWith(color: white),
                        ),
                        IconButton(
                          icon: Icon(
                            controller.sortAscending
                                ? FontAwesomeIcons.arrowDownAZ
                                : FontAwesomeIcons.arrowDownZA,
                            color: white,
                          ),
                          onPressed: controller.toggleSortOrder,
                          tooltip: controller.sortAscending
                              ? TextRoutes.sortAsc
                              : TextRoutes.sortDesc,
                        ),
                      ],
                    ),
                    Text(
                      TextRoutes.searchBy.tr,
                      style: bodyStyle.copyWith(color: white),
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
                              return Column(
                                children: [
                                  CustomDropDownSearch(
                                    iconData: Icons.layers_outlined,
                                    title: TextRoutes.chooseCategories.tr,
                                    listData: controller.dropDownListCategories,
                                    contrllerName: ctrl,
                                    contrllerId: controller.catIdController,
                                    color: white,
                                    fieldColor: primaryColor,
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
                                    fieldColor: primaryColor,
                                    borderColor: white,
                                    isNumber: valid == 'number' ||
                                            valid == 'realNumber'
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
                itemsActionButtonsWidget(controller, context, primaryColor)
              ],
            ),
          ),
        );
      }),
    );
  }
}
