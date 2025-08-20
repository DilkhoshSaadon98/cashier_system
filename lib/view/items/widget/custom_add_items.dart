import 'package:cashier_system/controller/items/items_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/buttons/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/custom_text_field_widget.dart';
import 'package:cashier_system/core/shared/drop_downs/transaction_accounts_dropdown_widget.dart';
import 'package:cashier_system/data/model/categories_model.dart';
import 'package:cashier_system/data/model/units_model.dart';
import 'package:cashier_system/view/items/widget/upload_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddItems extends StatelessWidget {
  const AddItems({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ItemsViewController());

    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: Form(
        key: controller.formState,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: controller.scrollController,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Upload Section
                      GetBuilder<ItemsViewController>(builder: (controller) {
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
                            GetBuilder<ItemsViewController>(builder: (context) {
                          final fields = controller.itemsInputFieldsData;
                          return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: fields.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: Get.width > 800
                                    ? 3
                                    : Get.width > 600
                                        ? 2
                                        : 1,
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
                                  return CustomDropdownSearchWidget<
                                      CategoriesModel>(
                                    iconData: Icons.layers_outlined,
                                    label: TextRoutes.chooseCategories.tr,
                                    items:
                                        controller.dropDownListCategoriesData,
                                    borderColor: primaryColor,
                                    itemToString: (p0) {
                                      return p0.categoriesName!;
                                    },
                                    fieldColor: white,
                                    validator: (value) {
                                      if (value != null) {
                                        return validInput(value.categoriesName!,
                                            0, 1000, valid,
                                            required: fieldRequired);
                                      }
                                      return validInput("", 0, 1000, valid,
                                          required: fieldRequired);
                                    },
                                    selectedItem: controller.selectedCat,
                                    onChanged: (value) {
                                      if (value != null) {
                                        controller.selectedCatId =
                                            value.categoriesId;
                                        controller.selectedCat = value;
                                      }
                                    },
                                  );
                                } else if (title == TextRoutes.baseUnit) {
                                  return CustomDropdownSearchWidget<UnitModel>(
                                    label: title,
                                    iconData: Icons.type_specimen,
                                    items: controller.unitsDropDownData,
                                    selectedItem: controller.selectedUnitData,
                                    borderColor: primaryColor,
                                    itemToString: (p0) {
                                      return "${p0.unitBaseName?.tr} = ${p0.factor}";
                                    },
                                    validator: (p0) {
                                      return validInput(
                                          p0!.unitBaseName!, 0, 100, "",
                                          required: false);
                                    },
                                    onChanged: (value) {
                                      if (value != null) {
                                        controller.selectedUnitId =
                                            value.unitId;
                                        controller.selectedUnitFactor =
                                            value.factor;
                                        controller.selectedUnitData = value;
                                      }

                                      controller.rows.clear();
                                    },
                                    fieldColor: white,
                                  );
                                } else {
                                  return CustomTextFieldWidget(
                                    onChanged: field['on_changed'],
                                    onTapIcon: onTap,
                                    readOnly: readOnly,
                                    suffixIconData: fields[index]
                                        ['suffix_icon'],
                                    hinttext: title,
                                    labeltext: title,
                                    iconData: icon,
                                    controller: fieldController,
                                    valid: (value) => validInput(
                                        value ?? '', 0, 500, valid,
                                        required: fieldRequired),
                                    fieldColor: white,
                                    borderColor: primaryColor,
                                    isNumber: valid == 'number' ||
                                            valid == 'realNumber'
                                        ? true
                                        : false,
                                  );
                                }
                              });
                        }),
                      ),

                      verticalGap(),
                      GetBuilder<ItemsViewController>(
                        builder: (controller) {
                          if (controller.rows.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return Column(
                            children:
                                List.generate(controller.rows.length, (index) {
                              final row = controller.rows[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 300,
                                        child: CustomDropdownSearchWidget<
                                            UnitModel>(
                                          selectedItem: row.conversionUnit,
                                          iconData: Icons.data_array,
                                          label: TextRoutes.unitsConvert,
                                          items: controller.unitsDropDownData,
                                          itemToString: (p0) {
                                            return "${p0.unitBaseName!.tr} = ${p0.factor}";
                                          },
                                          onChanged: (value) {
                                            final basePrice = double.tryParse(
                                                    controller
                                                        .itemsSellingPriceController
                                                        .text) ??
                                                0.0;
                                            double factor =
                                                value!.factor!.toDouble();
                                            row.unitId = value.unitId;
                                            row.conversionFactorController
                                                .text = factor.toString();

                                            row.sellingPrice =
                                                basePrice * factor;
                                            row.sellingPriceController.text =
                                                row.sellingPrice.toString();
                                            controller.update();
                                          },
                                          borderColor: primaryColor,
                                          fieldColor: white,
                                        ),
                                      ),
                                      horizontalGap(5),
                                      SizedBox(
                                        width: 300,
                                        child: CustomTextFieldWidget(
                                          controller: row.barcodeController,
                                          hinttext: TextRoutes.barcode,
                                          labeltext: TextRoutes.barcode,
                                          iconData: Icons.barcode_reader,
                                          isNumber: true,
                                          valid: (value) {
                                            return validInput(
                                                value!, 0, 10, 'number',
                                                required: false);
                                          },
                                          onTapIcon: () async {
                                            String newBarcode = await controller
                                                .generateRandomBarcode();
                                            row.barcode = newBarcode;
                                            row.barcodeController.text =
                                                newBarcode;
                                            controller.update();
                                          },
                                          suffixIconData: Icons.change_circle,
                                          fieldColor: white,
                                          borderColor: primaryColor,
                                          onChanged: (val) => row.barcode = val,
                                        ),
                                      ),
                                      horizontalGap(5),
                                      SizedBox(
                                        width: 300,
                                        child: CustomTextFieldWidget(
                                          hinttext: TextRoutes.unitsConvert,
                                          labeltext: TextRoutes.unitsConvert,
                                          iconData: Icons.money,
                                          isNumber: true,
                                          valid: (value) {
                                            return validInput(
                                                value!, 0, 10, 'realNumber',
                                                required: false);
                                          },
                                          fieldColor: white,
                                          readOnly: true,
                                          borderColor: primaryColor,
                                          controller:
                                              row.conversionFactorController,
                                          onChanged: (val) =>
                                              row.conversionFactor =
                                                  double.tryParse(val) ?? 0.0,
                                        ),
                                      ),
                                      horizontalGap(5),
                                      SizedBox(
                                        width: 300,
                                        child: CustomTextFieldWidget(
                                          hinttext: TextRoutes.sellingPrice,
                                          labeltext: TextRoutes.sellingPrice,
                                          iconData: Icons.money,
                                          isNumber: true,
                                          valid: (value) {
                                            return validInput(
                                                value!, 0, 10, 'realNumber',
                                                required: false);
                                          },
                                          fieldColor: white,
                                          borderColor: primaryColor,
                                          controller:
                                              row.sellingPriceController,
                                          onChanged: (val) => row.sellingPrice =
                                              double.tryParse(val),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle,
                                            color: Colors.red),
                                        onPressed: () =>
                                            controller.removeRow(index),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          style: const ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.teal)),
                          icon: const Icon(Icons.add_circle, color: white),
                          label: Text(
                            TextRoutes.addUnits.tr,
                            style: titleStyle.copyWith(color: white),
                          ),
                          onPressed: controller.addRow,
                        ),
                      ),
                    ]),
              ),
            ),
            verticalGap(),
            // Add Button
            SizedBox(
              width: double.infinity,
              child: customButtonGlobal(
                () {
                  controller.addItems();
                },
                TextRoutes.addItems.tr,
                Icons.add,
                buttonColor,
                Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
