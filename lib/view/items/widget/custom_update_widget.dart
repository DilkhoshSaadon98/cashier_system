import 'package:cashier_system/controller/items/items_update_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/buttons/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_text_field_widget.dart';
import 'package:cashier_system/core/shared/drop_downs/custom_drop_down_search.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/drop_downs/drop_down_menu.dart';
import 'package:cashier_system/data/source/locale/units_data.dart';
import 'package:cashier_system/view/items/widget/upload_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UpdateItemsWidget extends StatelessWidget {
  const UpdateItemsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ItemsUpdateController());

    return Form(
      key: controller.formState,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Upload Section
                  GetBuilder<ItemsUpdateController>(builder: (controller) {
                    return UploadImage(
                        file: controller.file,
                        onRemove: () {
                          controller.removeFile();
                        },
                        onTap: () {
                          controller.choseFile();
                        });
                  }),
                  verticalGap(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        GetBuilder<ItemsUpdateController>(builder: (context) {
                      final unitNames =
                          unitsMap.values.map((u) => u.name).toList();

                      final Map<String, Unit> nameToUnit = {
                        for (var entry in unitsMap.entries)
                          entry.value.name: entry.value
                      };
                      final fields = controller.itemsInputFieldsData;
                      return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: fields.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: Get.width > 800 ? 2 : 1,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            mainAxisExtent: 55.h,
                          ),
                          itemBuilder: (_, index) {
                            final field = fields[index];
                            final title = field['title'];
                            final readOnly = field['read_only'];
                            final onTap = field['on_tap'];
                            final icon = field['icon'];
                            final valid = field['valid'];
                            final fieldController = field['controller'];
                            bool fieldRequired = field['required'];
                            if (title == TextRoutes.chooseCategories) {
                              return CustomDropDownSearch(
                                iconData: Icons.layers_outlined,
                                title: TextRoutes.chooseCategories.tr,
                                listData: controller.dropDownListCategories,
                                contrllerName: controller.catNameController,
                                contrllerId: controller.catIdController,
                                color: primaryColor,
                                fieldColor: white,
                                valid: (value) => validInput(
                                    value ?? '', 0, 1000, valid,
                                    required: fieldRequired),
                              );
                            } else if (title == TextRoutes.baseUnit) {
                              //? Units Name:
                              return Row(
                                children: [
                                  Expanded(
                                    child: DropDownMenu(
                                      selectedValue: controller
                                          .itemsUnitBaseController.text,
                                      items: unitNames,
                                      onChanged: (value) {
                                        controller.itemsUnitBaseController
                                            .text = value ?? 'Milligram';

                                        // get Unit from name
                                        final selectedUnit = nameToUnit[value];
                                        if (selectedUnit != null) {
                                          controller.itemsUnitAltController
                                              .text = selectedUnit.baseUnit;
                                          controller
                                                  .itemsUnitConversionController
                                                  .text =
                                              selectedUnit.conversionFactor
                                                  .toString();
                                        } else {
                                          controller
                                              .itemsUnitAltController.text = '';
                                        }
                                        controller.calculateTotalQty();
                                        controller.update();
                                      },
                                    ),
                                  ),
                                  horizontalGap(5),
                                  Expanded(
                                    child: CustomTextFieldWidget(
                                        hinttext: TextRoutes.alternativeUnit,
                                        labeltext: TextRoutes.alternativeUnit,
                                        iconData: Icons.ad_units_sharp,
                                        valid: (value) {
                                          return validInput(value!, 0, 10, "");
                                        },
                                        fieldColor: white,
                                        borderColor: primaryColor,
                                        readOnly: true,
                                        controller:
                                            controller.itemsUnitAltController,
                                        isNumber: false),
                                  ),
                                  horizontalGap(5),
                                  Expanded(
                                    child: CustomTextFieldWidget(
                                        hinttext: TextRoutes.unitsConvert,
                                        labeltext: TextRoutes.unitsConvert,
                                        iconData: Icons.type_specimen,
                                        valid: (value) {
                                          return validInput(
                                              value!, 0, 10, "realNumber");
                                        },
                                        onChanged: (value) {
                                          controller.calculateTotalQty();
                                        },
                                        fieldColor: white,
                                        borderColor: primaryColor,
                                        readOnly: false,
                                        controller: controller
                                            .itemsUnitConversionController,
                                        isNumber: true),
                                  ),
                                ],
                              );
                            } else if (title == TextRoutes.baseUnitQuantity) {
                              //? Units Counts:
                              return Container(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  spacing: 5,
                                  children: [
                                    Expanded(
                                      child: CustomTextFieldWidget(
                                        onTapIcon: onTap,
                                        readOnly: readOnly,
                                        suffixIconData: fields[index]
                                            ['suffix_icon'],
                                        hinttext: title,
                                        labeltext: title,
                                        iconData: icon,
                                        onChanged: (value) {
                                          controller.calculateTotalQty();
                                        },
                                        controller: fieldController,
                                        valid: (value) => validInput(
                                          value ?? '',
                                          0,
                                          500,
                                          valid,
                                          required: false,
                                        ),
                                        fieldColor: white,
                                        borderColor: primaryColor,
                                        isNumber: valid == 'number' ||
                                            valid == 'realNumber',
                                      ),
                                    ),
                                    Expanded(
                                      child: CustomTextFieldWidget(
                                        onTapIcon: onTap,
                                        readOnly: true,
                                        suffixIconData: fields[index]
                                            ['suffix_icon'],
                                        hinttext:
                                            TextRoutes.alternativeUnitQuantity,
                                        labeltext:
                                            TextRoutes.alternativeUnitQuantity,
                                        iconData: icon,
                                        controller:
                                            controller.itemsAltQtyController,
                                        valid: (value) => validInput(
                                          value ?? '',
                                          0,
                                          100,
                                          "realNumber",
                                          required: false,
                                        ),
                                        fieldColor: white,
                                        borderColor: primaryColor,
                                        isNumber: true,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return CustomTextFieldWidget(
                                onChanged: field['on_changed'],
                                onTapIcon: onTap,
                                readOnly: readOnly,
                                suffixIconData: fields[index]['suffix_icon'],
                                hinttext: title,
                                labeltext: title,
                                iconData: icon,
                                controller: fieldController,
                                valid: (value) => validInput(
                                    value ?? '', 0, 500, valid,
                                    required: fieldRequired),
                                fieldColor: white,
                                borderColor: primaryColor,
                                isNumber:
                                    valid == 'number' || valid == 'realNumber'
                                        ? true
                                        : false,
                              );
                            }
                          });
                    }),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Add Button
          SizedBox(
            width: double.infinity,
            child: customButtonGlobal(
              () {
                if (controller.formState.currentState!.validate()) {
                  controller.updateItems();
                }
              },
              TextRoutes.submit.tr,
              Icons.edit,
              buttonColor,
              Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
