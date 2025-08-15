import 'package:cashier_system/controller/buying/buying_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/screen_routes.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/view/buying/components/items_view_dropdown_widget.dart';
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
                Get.toNamed(AppRoute.itemsAddScreen);
              }),
          body: Container(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Expanded(
                    child: TableWidget(
                  allSelected: false,
                  flexes: const [1, 1, 2, 1, 2, 2, 2],
                  columns: const [
                    "",
                    TextRoutes.code,
                    TextRoutes.itemsName,
                    TextRoutes.purchaesPrice,
                    TextRoutes.qty,
                    TextRoutes.totalPrice,
                    TextRoutes.totalPriceDiscount
                  ],
                  rows: controller.purchaseRow.map((row) {
                    return [
                      const SizedBox.shrink(), // checkbox or empty

                      // ID
                      _customTextFields(
                        row.id.text,
                        row.id,
                        (value) => validInput(value!, 0, 10, "number"),
                        true,
                        (value) {
                          controller.handleFieldUpdate(
                            buyingPriceController: row.purchasePrice,
                            itemDiscountedTotalPricesController:
                                row.discountTotalPurchasePrice,
                            itemOriginalTotalPricesController:
                                row.totalPurchasePrice,
                            quantityController: row.itemsQTY,
                            updatedField: '',
                          );
                        },
                      ),

                      // Item Name Dropdown
                      ItemsViewDropdownWidget(
                        hinttext: TextRoutes.itemsName,
                        nameController: row.itemsName,
                        idController: row.id,
                        controllerPrice: row.purchasePrice,
                        controllerDiscountTotalPrice:
                            row.discountTotalPurchasePrice,
                        controllerTotalPrice: row.totalPurchasePrice,
                        data: controller.dropDownList,
                        onTap: () {},
                        passedIndex: 1,
                        valid: (value) {},
                        isNumber: false,
                      ),

                      // Purchase Price
                      _customTextFields(
                        row.purchasePrice.text,
                        row.purchasePrice,
                        (value) => validInput(value!, 0, 100, "real"),
                        true,
                        (value) {
                          controller.handleFieldUpdate(
                            buyingPriceController: row.purchasePrice,
                            itemDiscountedTotalPricesController:
                                row.discountTotalPurchasePrice,
                            itemOriginalTotalPricesController:
                                row.totalPurchasePrice,
                            quantityController: row.itemsQTY,
                            updatedField: 'buying',
                          );
                        },
                      ),

                      // Quantity with increment/decrement
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              double current =
                                  double.tryParse(row.itemsQTY.text) ?? 1.0;
                              row.itemsQTY.text =
                                  (current + 1).toStringAsFixed(2);
                              controller.handleFieldUpdate(
                                buyingPriceController: row.purchasePrice,
                                quantityController: row.itemsQTY,
                                itemOriginalTotalPricesController:
                                    row.totalPurchasePrice,
                                itemDiscountedTotalPricesController:
                                    row.discountTotalPurchasePrice,
                                updatedField: "qty",
                              );
                            },
                            icon: const Icon(Icons.add, color: Colors.teal),
                          ),
                          Expanded(
                            child: _customTextFields(
                              row.itemsQTY.text,
                              row.itemsQTY,
                              (value) =>
                                  validInput(value!, 0, 20, "realNumber"),
                              true,
                              (value) {
                                controller.handleFieldUpdate(
                                  buyingPriceController: row.purchasePrice,
                                  quantityController: row.itemsQTY,
                                  itemOriginalTotalPricesController:
                                      row.totalPurchasePrice,
                                  itemDiscountedTotalPricesController:
                                      row.discountTotalPurchasePrice,
                                  updatedField: "qty",
                                );
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              double current =
                                  double.tryParse(row.itemsQTY.text) ?? 1.0;
                              if (current > 1) {
                                row.itemsQTY.text =
                                    (current - 1).toStringAsFixed(2);
                                controller.handleFieldUpdate(
                                  buyingPriceController: row.purchasePrice,
                                  quantityController: row.itemsQTY,
                                  itemOriginalTotalPricesController:
                                      row.totalPurchasePrice,
                                  itemDiscountedTotalPricesController:
                                      row.discountTotalPurchasePrice,
                                  updatedField: "qty",
                                );
                              }
                            },
                            icon: const Icon(Icons.remove, color: Colors.red),
                          ),
                        ],
                      ),

                      // Total Price
                      _customTextFields(
                        row.totalPurchasePrice.text,
                        row.totalPurchasePrice,
                        (value) => validInput(value!, 0, 1000, "real"),
                        true,
                        (value) {
                          controller.handleFieldUpdate(
                            buyingPriceController: row.purchasePrice,
                            itemDiscountedTotalPricesController:
                                row.discountTotalPurchasePrice,
                            itemOriginalTotalPricesController:
                                row.totalPurchasePrice,
                            quantityController: row.itemsQTY,
                            updatedField: 'total',
                          );
                        },
                      ),

                      // Discounted Price
                      _customTextFields(
                        row.discountTotalPurchasePrice.text,
                        row.discountTotalPurchasePrice,
                        (value) => validInput(value!, 0, 1000, "real"),
                        true,
                        (value) {
                          controller.handleFieldUpdate(
                            buyingPriceController: row.purchasePrice,
                            itemDiscountedTotalPricesController:
                                row.discountTotalPurchasePrice,
                            itemOriginalTotalPricesController:
                                row.totalPurchasePrice,
                            quantityController: row.itemsQTY,
                            updatedField: 'discount',
                          );
                        },
                      ),
                      _customTextFields(
                        row.discountTotalPurchasePrice.text,
                        row.discountTotalPurchasePrice,
                        (value) => validInput(value!, 0, 1000, "real"),
                        true,
                        (value) {
                          controller.handleFieldUpdate(
                            buyingPriceController: row.purchasePrice,
                            itemDiscountedTotalPricesController:
                                row.discountTotalPurchasePrice,
                            itemOriginalTotalPricesController:
                                row.totalPurchasePrice,
                            quantityController: row.itemsQTY,
                            updatedField: 'discount',
                          );
                        },
                      ),
                    ];
                  }).toList(),
                )),
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: IconButton(
                    icon: const Icon(Icons.add_circle,
                        size: 30, color: Colors.green),
                    onPressed: () => controller.addRow(),
                  ),
                ),
              ],
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
    void Function(String)? onChanged) {
  return Form(
    child: TextFormField(
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
      readOnly: text == TextRoutes.totalPriceDiscount ? true : false,
      decoration: InputDecoration(
        errorStyle: bodyStyle.copyWith(color: Colors.red),
        hintText: text.tr,
        hintStyle: bodyStyle.copyWith(fontWeight: FontWeight.w300),
        border: InputBorder.none,
      ),
    ),
  );
}
