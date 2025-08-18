import 'package:cashier_system/controller/buying/buying_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/dialogs/show_form_dialog.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/drop_downs/drop_down_menu.dart';
import 'package:cashier_system/core/shared/drop_downs/items_drop_down_search.dart';
import 'package:cashier_system/data/model/items_model.dart';
import 'package:cashier_system/view/items/widget/custom_add_items.dart';
import 'package:cashier_system/view/widgets/tables/table_cell.dart';
import 'package:cashier_system/view/widgets/tables/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddBuyingTable extends StatelessWidget {
  const AddBuyingTable({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(BuyingController());
    return GetBuilder<BuyingController>(builder: (controller) {
      return Scaffold(
          backgroundColor: white,
          appBar: customAppBarTitle(TextRoutes.purchaesItems),
          floatingActionButton: FloatingActionButton.extended(
              shape: const CircleBorder(),
              backgroundColor: primaryColor,
              label: const Icon(
                Icons.add,
                color: secondColor,
              ),
              onPressed: () {
                showFormDialog(context,
                    addText: TextRoutes.addItems,
                    editText: TextRoutes.editItem,
                    isUpdate: false,
                    child: const AddItems());
              }),
          body: Container(
            alignment: Alignment.topCenter,
            child: Form(
              key: controller.itemsFormKey,
              child: Column(
                children: [
                  Flexible(
                    child: TableWidget(
                      allSelected: true,
                      flexes: const [1, 1, 2, 1, 2, 2, 2, 2],
                      columns: const [
                        "",
                        TextRoutes.code,
                        TextRoutes.itemsName,
                        TextRoutes.purchaesPrice,
                        TextRoutes.qty,
                        TextRoutes.totalPrice,
                        TextRoutes.purchaesPriceDiscount,
                        TextRoutes.type,
                      ],
                      rows: controller.purchaseRow.asMap().entries.map((entry) {
                        final index = entry.key;
                        final row = entry.value;
                        final unitItems = [
                          if (row.itemsModel?.baseUnitName.isNotEmpty ?? false)
                            row.itemsModel!.baseUnitName,
                          ...?row.itemsModel?.altUnits
                              .where((u) => u.unitName.isNotEmpty)
                              .map((u) => u.unitName),
                        ].toList();
                        return [
                          IconButton(
                            onPressed: () => controller.removeRow(index),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                          tableCell("${index + 1}"),
                          ItemsDropDownSearch<ItemsModel>(
                            selectedItem: row.itemsModel,
                            iconData: Icons.data_array,
                            label: TextRoutes.itemName,
                            items: controller.itemsData,
                            itemToString: (p0) => p0.itemsName,
                            onChanged: (value) {
                              row.itemsModel = value;
                              row.id = value!.itemsId;
                              row.itemsQTYController.text = "1.0";

                              // Default purchase price
                              row.purchasePrice = value.itemsBuyingPrice;
                              row.purchasePriceController.text =
                                  value.itemsBuyingPrice.toString();
                              row.totalPurchasePriceController.text =
                                  value.itemsBuyingPrice.toString();
                              row.discountTotalPurchasePriceController.text =
                                  value.itemsBuyingPrice.toString();

                              // Default the selected unit to base unit if not set
                              row.itemsType ??= value.baseUnitName;

                              // Calculate factor
                              double factor = 1.0;
                              if (row.itemsType != value.baseUnitName) {
                                final altUnit = value.altUnits.firstWhere(
                                  (u) => u.unitName == row.itemsType,
                                  orElse: () => AltUnit(
                                    unitId: value.mainUnitId,
                                    unitName: value.baseUnitName,
                                    price: value.itemsBuyingPrice,
                                    unitFactor: 1.0,
                                    barcode: "",
                                  ),
                                );
                                factor = altUnit.unitFactor;
                              }

                              row.factorController.text = factor.toString();

                              controller.update();
                            },
                            borderColor: primaryColor,
                            fieldColor: white,
                            validator: (value) {
                              return validInput(value!.itemsName, 0, 100, "");
                            },
                            searchFields: (item) => [
                              item.itemsName,
                              item.itemsId.toString(),
                              item.itemsBarcode.toString(),
                            ],
                          ),

                          //! Purchase Price
                          _customTextFields(
                            row.purchasePriceController.text,
                            row.purchasePriceController,
                            (value) => validInput(value!, 0, 100, "real"),
                            true,
                            (value) {
                              updatePurchaseFields(
                                qtyController: row.itemsQTYController,
                                purchasePriceController:
                                    row.purchasePriceController,
                                totalPriceController:
                                    row.totalPurchasePriceController,
                                updatedField: 'purchasePrice',
                              );
                            },
                          ),

                          //! Quantity (+/-)
                          Row(
                            children: [
                              InkWell(
                                onDoubleTap: () {
                                  double current = double.tryParse(
                                          row.itemsQTYController.text) ??
                                      1.0;
                                  row.itemsQTYController.text =
                                      (current + 1).toStringAsFixed(2);
                                  updatePurchaseFields(
                                    qtyController: row.itemsQTYController,
                                    purchasePriceController:
                                        row.purchasePriceController,
                                    totalPriceController:
                                        row.totalPurchasePriceController,
                                    updatedField: 'qty',
                                  );
                                },
                                child: IconButton(
                                  onPressed: () {
                                    double current = double.tryParse(
                                            row.itemsQTYController.text) ??
                                        1.0;
                                    row.itemsQTYController.text =
                                        (current + 1).toStringAsFixed(2);
                                    updatePurchaseFields(
                                      qtyController: row.itemsQTYController,
                                      purchasePriceController:
                                          row.purchasePriceController,
                                      totalPriceController:
                                          row.totalPurchasePriceController,
                                      updatedField: 'qty',
                                    );
                                  },
                                  icon:
                                      const Icon(Icons.add, color: Colors.teal),
                                ),
                              ),
                              Expanded(
                                child: _customTextFields(
                                  row.itemsQTYController.text.isEmpty
                                      ? "1.0"
                                      : row.itemsQTYController.text,
                                  row.itemsQTYController,
                                  (value) => validInput(value!, 0, 20, "real"),
                                  true,
                                  (value) {
                                    updatePurchaseFields(
                                      qtyController: row.itemsQTYController,
                                      purchasePriceController:
                                          row.purchasePriceController,
                                      totalPriceController:
                                          row.totalPurchasePriceController,
                                      updatedField: 'qty',
                                    );
                                  },
                                ),
                              ),
                              InkWell(
                                onDoubleTap: () {
                                  double current = double.tryParse(
                                          row.itemsQTYController.text) ??
                                      1.0;
                                  if (current > 1) {
                                    row.itemsQTYController.text =
                                        (current - 1).toStringAsFixed(2);
                                    updatePurchaseFields(
                                      qtyController: row.itemsQTYController,
                                      purchasePriceController:
                                          row.purchasePriceController,
                                      totalPriceController:
                                          row.totalPurchasePriceController,
                                      updatedField: 'qty',
                                    );
                                  }
                                },
                                child: IconButton(
                                  onPressed: () {
                                    double current = double.tryParse(
                                            row.itemsQTYController.text) ??
                                        1.0;
                                    if (current > 1) {
                                      row.itemsQTYController.text =
                                          (current - 1).toStringAsFixed(2);
                                      updatePurchaseFields(
                                        qtyController: row.itemsQTYController,
                                        purchasePriceController:
                                            row.purchasePriceController,
                                        totalPriceController:
                                            row.totalPurchasePriceController,
                                        updatedField: 'qty',
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.remove,
                                      color: Colors.red),
                                ),
                              ),
                            ],
                          ),

                          //! Total Price
                          _customTextFields(
                            row.totalPurchasePriceController.text,
                            row.totalPurchasePriceController,
                            (value) => validInput(value!, 0, 100, "real"),
                            true,
                            (value) {
                              updatePurchaseFields(
                                qtyController: row.itemsQTYController,
                                purchasePriceController:
                                    row.purchasePriceController,
                                totalPriceController:
                                    row.totalPurchasePriceController,
                                updatedField: 'totalPrice',
                              );
                            },
                          ),

                          //! Discounted Price
                          _customTextFields(
                              row.discountTotalPurchasePriceController.text,
                              row.discountTotalPurchasePriceController,
                              (value) => validInput(value!, 0, 1000, "real",
                                  required: false),
                              true,
                              (value) {},
                              readOnly: true),
                          //! UNits
                          DropDownMenu(
                            showBorder: false,
                            selectedValue: row.itemsType ??
                                (row.itemsModel?.baseUnitName ?? ''),
                            items: unitItems,
                            onChanged: (newUnit) {
                              row.itemsType = newUnit;
                              double factor = 1.0;

                              if (row.itemsModel != null &&
                                  row.itemsType !=
                                      row.itemsModel!.baseUnitName) {
                                factor = row.itemsModel!.altUnits
                                    .where((value) {
                                      return value.unitName == newUnit;
                                    })
                                    .first
                                    .unitFactor;
                              }
                              row.factorController.text = factor.toString();
                              controller.update();
                            },
                          ),
                          const SizedBox()
                        ];
                      }).toList()
                        ..add([
                          IconButton(
                            icon: const Icon(Icons.add_circle,
                                size: 30, color: Colors.green),
                            onPressed: () => controller.addRow(),
                          ),
                          const SizedBox(),
                        ]),
                    ),
                  ),
                ],
              ),
            ),
          ));
    });
  }
}

Widget _customTextFields(
    String text,
    TextEditingController controller,
    String? Function(String?)? validator,
    bool isNumber,
    void Function(String)? onChanged,
    {bool? readOnly = false}) {
  return TextFormField(
    controller: controller,
    textAlign: TextAlign.center,
    textAlignVertical: TextAlignVertical.center,
    style: bodyStyle.copyWith(
      fontWeight: FontWeight.w200,
      overflow: TextOverflow.clip,
    ),
    validator: validator,
    keyboardType: isNumber
        ? const TextInputType.numberWithOptions(decimal: true)
        : TextInputType.text,
    inputFormatters: isNumber
        ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))]
        : [],
    onChanged: onChanged,
    readOnly: readOnly!,
    decoration: InputDecoration(
      errorStyle: bodyStyle.copyWith(color: Colors.red),
      hintText: text.tr,
      hintStyle: bodyStyle.copyWith(fontWeight: FontWeight.w300),
      border: InputBorder.none,
    ),
  );
}
