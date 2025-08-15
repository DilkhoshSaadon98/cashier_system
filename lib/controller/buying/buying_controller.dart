import 'package:cashier_system/controller/buying/definition_buying_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/core/dialogs/snackbar_helper.dart';
import 'package:cashier_system/core/functions/calculate_discount.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/data/model/purchaes_model.dart';
import 'package:cashier_system/view/buying/components/items_view_dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class BuyingController extends DefinitionBuyingController {
  //? Scroll initialize:
  void initScrolls() {
    purchaseScrollControllers.addListener(() {
      bool shouldShow = purchaseScrollControllers.offset > 20;
      if (showBackToTopButton != shouldShow) {
        showBackToTopButton = shouldShow;
        update();
      }

      if (purchaseScrollControllers.position.pixels >=
          purchaseScrollControllers.position.maxScrollExtent) {
        if (!isLoading) {
          getPurchaseData();
        }
      }
    });
  }

//? Add New rows :
  void addNewRow() {
    rowIndexCounter = rows.length;
    rows.add(createRow(rowIndexCounter));
    update();
  }

//? create rows;
  List<Widget> createRow(int index) {
    changeShowSaveButton(false);
    TextEditingController itemDiscountedTotalPricesController =
        TextEditingController();
    TextEditingController itemOriginalTotalPricesController =
        TextEditingController();
    GlobalKey<FormState> formKeyTotalPrice = GlobalKey<FormState>();
    GlobalKey<FormState> formKeyOriginalTotalPrice = GlobalKey<FormState>();
    GlobalKey<FormState> formKeyBuying = GlobalKey<FormState>();
    GlobalKey<FormState> formKeyQTY = GlobalKey<FormState>();
    GlobalKey<FormState> formKeyName = GlobalKey<FormState>();
    GlobalKey<FormState> formKeyCode = GlobalKey<FormState>();

    TextEditingController itemCodeController = TextEditingController();
    TextEditingController buyingPriceController = TextEditingController();
    TextEditingController quantityController =
        TextEditingController(text: '1.0');
    TextEditingController itemNameController = TextEditingController();

    // Add controllers and form keys to respective lists
    itemCodeControllers.add(itemCodeController);
    buyingPriceControllers.add(buyingPriceController);
    quantityControllers.add(quantityController);
    itemNameControllers.add(itemNameController);
    itemOriginalTotalPriceControllers.add(itemOriginalTotalPricesController);
    itemDiscountedTotalPriceControllers
        .add(itemDiscountedTotalPricesController);

    formKeysOriginalTotalPrice.add(formKeyOriginalTotalPrice);
    formKeysDiscountTotalPrice.add(formKeyTotalPrice);
    formKeysBuying.add(formKeyBuying);
    formKeysQTY.add(formKeyQTY);
    formKeysName.add(formKeyName);
    formKeysCode.add(formKeyCode);

    rowAdded = false;
    quantityController.text = "1";
    update();

    return [
      IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () {
          if (index < rows.length &&
              index < itemCodeControllers.length &&
              index < buyingPriceControllers.length &&
              index < quantityControllers.length &&
              index < itemNameControllers.length &&
              index < itemOriginalTotalPriceControllers.length &&
              index < itemDiscountedTotalPriceControllers.length &&
              index < formKeysOriginalTotalPrice.length &&
              index < formKeysDiscountTotalPrice.length &&
              index < formKeysBuying.length &&
              index < formKeysQTY.length &&
              index < formKeysName.length &&
              index < formKeysCode.length) {
            rows.removeAt(index);
            itemCodeControllers.removeAt(index);
            buyingPriceControllers.removeAt(index);
            quantityControllers.removeAt(index);
            itemNameControllers.removeAt(index);
            itemOriginalTotalPriceControllers.removeAt(index);
            itemDiscountedTotalPriceControllers.removeAt(index);

            formKeysOriginalTotalPrice.removeAt(index);
            formKeysDiscountTotalPrice.removeAt(index);
            formKeysBuying.removeAt(index);
            formKeysQTY.removeAt(index);
            formKeysName.removeAt(index);
            formKeysCode.removeAt(index);

            if (rows.isEmpty) {
              rowAdded = false;
              addNewRow();
            }

            update();
          } else {
            showErrorSnackBar(TextRoutes.failDeleteData);
          }
        },
      ),
      //* Item Code
      Form(
        key: formKeyCode,
        child: ItemsViewDropdownWidget(
          hinttext: TextRoutes.code,
          valid: (value) {
            return validInput(value!, 0, 100, "number");
          },
          isNumber: true,
          onTap: () {},
          idController: itemCodeController,
          nameController: itemNameController,
          controllerPrice: buyingPriceController,
          controllerDiscountTotalPrice: itemDiscountedTotalPricesController,
          controllerTotalPrice: itemOriginalTotalPricesController,
          data: dropDownList,
          passedIndex: index,
        ),
      ),
      //* Item Name
      Form(
        key: formKeyName,
        child: ItemsViewDropdownWidget(
          hinttext: TextRoutes.itemsName,
          valid: (value) {
            return validInput(value!, 0, 1000, "");
          },
          isNumber: false,
          nameController: itemNameController,
          idController: itemCodeController,
          controllerPrice: buyingPriceController,
          controllerDiscountTotalPrice: itemDiscountedTotalPricesController,
          controllerTotalPrice: itemOriginalTotalPricesController,
          data: dropDownList,
          onTap: () {},
          passedIndex: index,
        ),
      ),
      //* Item Purchase Price
      _customTextFields(
          TextRoutes.purchaesPrice,
          formKeyBuying,
          buyingPriceController,
          (value) {
            return validInput(value!, 0, 100, "realNumber");
          },
          true,
          (value) {
            handleFieldUpdate(
              buyingPriceController: buyingPriceController,
              quantityController: quantityController,
              itemOriginalTotalPricesController:
                  itemOriginalTotalPricesController,
              itemDiscountedTotalPricesController:
                  itemDiscountedTotalPricesController,
              updatedField: "buying",
              index: index,
            );
          }),

      //* Item QTY
      Row(
        children: [
          Expanded(
            child: IconButton(
              onPressed: () {
                double currentQuantity =
                    double.tryParse(quantityController.text) ?? 1.0;
                quantityController.text =
                    (currentQuantity + 1).toStringAsFixed(2);
                handleFieldUpdate(
                  buyingPriceController: buyingPriceController,
                  quantityController: quantityController,
                  itemOriginalTotalPricesController:
                      itemOriginalTotalPricesController,
                  itemDiscountedTotalPricesController:
                      itemDiscountedTotalPricesController,
                  updatedField: "qty",
                  index: index,
                );
              },
              icon: const Icon(
                Icons.add,
                color: Colors.teal,
              ),
            ),
          ),
          Expanded(
            child: _customTextFields(
              TextRoutes.qty,
              formKeyQTY,
              quantityController,
              (value) => validInput(value!, 0, 20, "realNumber"),
              true,
              (value) {
                handleFieldUpdate(
                  buyingPriceController: buyingPriceController,
                  quantityController: quantityController,
                  itemOriginalTotalPricesController:
                      itemOriginalTotalPricesController,
                  itemDiscountedTotalPricesController:
                      itemDiscountedTotalPricesController,
                  updatedField: "qty",
                  index: index,
                );
              },
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: () {
                double currentQuantity =
                    double.tryParse(quantityController.text) ?? 1.0;
                if (currentQuantity > 1) {
                  quantityController.text =
                      (currentQuantity - 1).toStringAsFixed(2);
                  handleFieldUpdate(
                    buyingPriceController: buyingPriceController,
                    quantityController: quantityController,
                    itemOriginalTotalPricesController:
                        itemOriginalTotalPricesController,
                    itemDiscountedTotalPricesController:
                        itemDiscountedTotalPricesController,
                    updatedField: "qty",
                    index: index,
                  );
                }
              },
              icon: const Icon(
                Icons.remove,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),

      //* Item Original Price
      _customTextFields(
          TextRoutes.totalItemsPrice,
          formKeyOriginalTotalPrice,
          itemOriginalTotalPricesController,
          (value) {
            return validInput(value!, 0, 20, "");
          },
          true,
          (value) {
            handleFieldUpdate(
              buyingPriceController: buyingPriceController,
              quantityController: quantityController,
              itemOriginalTotalPricesController:
                  itemOriginalTotalPricesController,
              itemDiscountedTotalPricesController:
                  itemDiscountedTotalPricesController,
              updatedField: "total",
              index: index,
            );
          }),

      //* Item Discount Total Price
      _customTextFields(
          TextRoutes.totalPriceDiscount,
          formKeyTotalPrice,
          itemDiscountedTotalPricesController,
          (value) {
            return validInput(value!, 0, 100, "realNumber");
          },
          true,
          (value) {
            handleFieldUpdate(
              buyingPriceController: buyingPriceController,
              quantityController: quantityController,
              itemOriginalTotalPricesController:
                  itemOriginalTotalPricesController,
              itemDiscountedTotalPricesController:
                  itemDiscountedTotalPricesController,
              updatedField: "total",
              index: index,
            );
          }),

      Container()
    ];
  }

  //? Handling Item Selection:
  void onItemSelected(
      TextEditingController selectedItemPrice,
      TextEditingController itemOriginalTotalPricesController,
      TextEditingController itemDiscountedTotalPricesController,
      int index) {
    handleFieldUpdate(
      buyingPriceController: selectedItemPrice,
      quantityController: quantityController,
      itemOriginalTotalPricesController: itemOriginalTotalPricesController,
      itemDiscountedTotalPricesController: itemDiscountedTotalPricesController,
      updatedField: "buying",
      index: index,
    );
    update();
  }

  void handleFieldUpdate({
    TextEditingController? quantityController,
    TextEditingController? itemOriginalTotalPricesController,
    TextEditingController? itemDiscountedTotalPricesController,
    TextEditingController? buyingPriceController,
    String? updatedField,
    int? index,
  }) {
    changeShowSaveButton(false);
    // Safety: Make sure index is valid
    if (index == null || index < 0 || index >= rows.length) return;

    // Auto-add new row if on last input row
    if (!rowAdded && index == rows.length - 1) {
      rowAdded = true;
      addNewRow();
    } else if (index == rows.length - 2) {
      rowAdded = false;
    }

    // Parse values safely
    double quantity = double.tryParse(quantityController?.text ?? '') ?? 1;
    double originalTotalPrice =
        double.tryParse(itemOriginalTotalPricesController?.text ?? '') ?? 0.0;
    double buyingPrice =
        double.tryParse(buyingPriceController?.text ?? '') ?? 0.0;

    // Field logic
    if (updatedField == "total") {
      if (quantity > 0) {
        double result = originalTotalPrice / quantity;
        buyingPriceController?.text = result.toStringAsFixed(2);
        itemDiscountedTotalPricesController?.text =
            originalTotalPrice.toStringAsFixed(2);
      }
    } else if (updatedField == "buying") {
      if (quantity > 0) {
        double result = buyingPrice * quantity;
        itemOriginalTotalPricesController?.text = result.toStringAsFixed(2);
        itemDiscountedTotalPricesController?.text = result.toStringAsFixed(2);
      }
    } else if (updatedField == "qty") {
      if (buyingPrice > 0) {
        double result = buyingPrice * quantity;
        itemOriginalTotalPricesController?.text = result.toStringAsFixed(2);
      }
    }

    update();
  }

//? Calculate total Purchase Price:
  double totalPurchaseCalculatedPrice = 0.0;
  void calculateTotalPrice() {
    removeEmptyRows();
    totalPurchaseCalculatedPrice = 0.0;
    for (int i = 0; i < itemDiscountedTotalPriceControllers.length; i++) {
      totalPurchaseCalculatedPrice =
          double.tryParse(itemDiscountedTotalPriceControllers[i].text)! +
              totalPurchaseCalculatedPrice;
    }
    update();
  }

//? Remove Empty Rows:
  void removeEmptyRows() {
    try {
      for (int i = rows.length - 1; i >= 0; i--) {
        if (buyingPriceControllers[i].text.isEmpty ||
            itemOriginalTotalPriceControllers[i].text.isEmpty) {
          rows.removeAt(i);
          buyingPriceControllers.removeAt(i);
          quantityControllers.removeAt(i);
          itemOriginalTotalPriceControllers.removeAt(i);
          itemDiscountedTotalPriceControllers.removeAt(i);
          itemCodeControllers.removeAt(i);
          itemNameControllers.removeAt(i);
        }
      }
    } catch (e) {
      showErrorDialog(e.toString(), title: "Error", message: "");
    } finally {
      update();
    }
  }

  bool showSaveButton = false;
  changeShowSaveButton(bool value) {
    showSaveButton = value;
  }

//? Calculate Price After Discount And Fees :
  void calculatePrice() {
    try {
      removeEmptyRows();
      double total = 0.0;

      // Calculate the total from the original prices
      for (int j = 0; j < itemOriginalTotalPriceControllers.length; j++) {
        total +=
            double.tryParse(itemOriginalTotalPriceControllers[j].text) ?? 0.0;
      }

      for (int i = 0; i < rows.length; i++) {
        double originalPrice =
            double.tryParse(itemOriginalTotalPriceControllers[i].text) ?? 0.0;

        double discount = 0.0;
        double fees = 0.0;

        // Check if discount is provided and calculate it
        if (purchaseDiscountController.text.isNotEmpty) {
          discount = calculateFeesAndDiscountFunction(
              int.parse(purchaseDiscountController.text),
              total,
              itemOriginalTotalPriceControllers)[i];
        }

        // Check if fees are provided and calculate it
        if (purchaseFeesController.text.isNotEmpty) {
          fees = calculateFeesAndDiscountFunction(
              int.parse(purchaseFeesController.text),
              total,
              itemOriginalTotalPriceControllers)[i];
        }

        double finalPrice = originalPrice - discount + fees;

        itemDiscountedTotalPriceControllers[i].text =
            finalPrice.toStringAsFixed(2);
      }
      changeShowSaveButton(true);
      calculateTotalPrice();
    } catch (e) {
      showErrorDialog(e.toString(), title: "Error", message: "");
    } finally {
      update();
    }
  }

//? Add Purchase Data :
  void addItems(BuildContext context) async {
    try {
      calculatePrice();
      removeEmptyRows();

      if (formKey.currentState!.validate()) {
        int purchaseNumber = await generateUniquePurchaseNumber();

        bool allRowsValid = true;
        for (int i = 0; i < itemCodeControllers.length; i++) {
          if (!(formKeysName[i].currentState!.validate() &&
              formKeysCode[i].currentState!.validate() &&
              formKeysBuying[i].currentState!.validate() &&
              formKeysQTY[i].currentState!.validate() &&
              formKeysOriginalTotalPrice[i].currentState!.validate())) {
            allRowsValid = false;
            break;
          }
        }

        if (!allRowsValid) {
          showErrorSnackBar(TextRoutes.formValidationFailed);
          return;
        }

        double totalPrice = totalPurchaseCalculatedPrice;
        double purchaseDiscount =
            double.tryParse(purchaseDiscountController.text) ?? 0.0;
        double purchaseFees =
            double.tryParse(purchaseFeesController.text) ?? 0.0;
        //?
        int sourceAccountId;
        int targetAccountId = 10; // حساب المخزون

        if (paymentMethod == TextRoutes.cash) {
          sourceAccountId = 7; // الصندوق (مدين)
        } else if (paymentMethod == TextRoutes.dept) {
          sourceAccountId = 10; // المخزون (مدين)
          targetAccountId = 20; // الموردين (دائن)
        } else {
          showErrorSnackBar(TextRoutes.failAddData);
          return;
        }

        Map<String, dynamic> transactionData = {
          'transaction_type': 'purchase',
          'transaction_date': currentTime,
          'transaction_amount': totalPrice,
          'transaction_note':
              "فاتورة مشتريات للمورد ${supplierNameController.text}",
          'transaction_discount': purchaseDiscount,
          'source_account_id': sourceAccountId,
          'target_account_id': targetAccountId,
        };

        await sqlDb.insertData("tbl_transactions", transactionData);

        // الآن نضيف كل صنف في جدول الشراء ونحدث المخزون
        for (int i = itemCodeControllers.length - 1; i >= 0; i--) {
          double purchasePrice =
              double.tryParse(buyingPriceControllers[i].text) ?? 0.0;
          int purchaseQuantity = int.tryParse(quantityControllers[i].text) ?? 0;
          String itemCode = itemCodeControllers[i].text.trim();

          // بيانات الشراء لكل صنف
          Map<String, dynamic> itemData = {
            'purchase_items_id': itemCode,
            'purchase_price': purchasePrice,
            'purchase_quantity': purchaseQuantity,
            'purchase_total_price': purchasePrice * purchaseQuantity,
            'purchase_number': purchaseNumber + 1,
            'purchase_date': currentTime,
            'purchase_discount': purchaseDiscount,
            'purchase_fees': purchaseFees,
            'purchase_payment': paymentMethod,
            'purchase_supplier_id': supplierIdController.text,
          };

          int response = await sqlDb.insertData("tbl_purchase", itemData);

          if (response > 0) {
            // تحديث كمية المخزون في جدول الأصناف
            Database? myDb = await sqlDb.db;
            await myDb!.rawUpdate(
              "UPDATE tbl_items SET item_count = item_count - $purchaseQuantity WHERE item_id = $itemCode",
            );
            // إضافة حركة مخزون (purchase)
            Map<String, dynamic> inventoryMovementData = {
              'item_id': int.parse(itemCode),
              'movement_type': 'purchase',
              'quantity': purchaseQuantity,
              'cost_price': purchasePrice,
              'movement_date': currentTime,
              'note': 'شراء صنف رقم $itemCode',
              'account_id': targetAccountId,
              'sale_price': 0.0,
            };
            await sqlDb.insertData(
                "tbl_inventory_movements", inventoryMovementData);
          }
        }

        showSuccessSnackBar(TextRoutes.dataAddedSuccess);

        getPurchaseData(isInitialSearch: true);
        selectedSection = TextRoutes.view;
        rows.clear();
      } else {
        showErrorSnackBar(TextRoutes.failAddData);
      }
    } catch (e) {
      showErrorDialog(e.toString(), message: TextRoutes.anErrorOccurred);
    } finally {
      update();
    }
  }

//? Get Purchase Data:
  Future<void> getPurchaseData({bool isInitialSearch = false}) async {
    if (isLoading) return;

    try {
      if (isInitialSearch) {
        currentPage = 0;
        purchaseData.clear();
        hasMoreData = true;
      }

      isLoading = true;

      String? purchaseId;
      String? purchaseTotalPrice;
      String? itemsDate;
      String? supplierName;
      String? purchasePayment;
      String? orderBy;

      if (purchaseIdController.text.isNotEmpty) {
        purchaseId = purchaseIdController.text;
      }
      if (purchaseTotalPriceController.text.isNotEmpty) {
        purchaseTotalPrice = purchaseTotalPriceController.text;
      }
      if (purchaseDateController.text.isNotEmpty) {
        itemsDate = purchaseDateController.text;
      }
      if (purchaseSupplierNameController.text.isNotEmpty) {
        supplierName = purchaseSupplierNameController.text;
      }
      if (purchasePaymentMethodController.text.isNotEmpty) {
        purchasePayment = purchasePaymentMethodController.text;
      }
      if (groupByIdController.text.isNotEmpty) {
        orderBy = groupByIdController.text;
      }

      final response = await buyingClass.getData(
        itemsDate: itemsDate,
        purchaseTotalPrice: purchaseTotalPrice,
        purchaseId: purchaseId,
        supplierName: supplierName,
        purchasePayment: purchasePayment,
        orderBy: orderBy ?? "purchase_date",
        limit: itemsPerPage,
        offset: currentPage * itemsPerPage,
      );

      if (response['status'] == "success") {
        List rawList = response['data'] ?? [];
        if (rawList.isNotEmpty) {
          currentPage++;

          // Group by purchase_number
          Map<int, List<Map<String, dynamic>>> groupedData = {};

          for (var item in rawList) {
            int number = item['purchase_number'];
            groupedData.putIfAbsent(number, () => []).add(item);
          }

          // Build PurchaseModel for each group
          final List<PurchaseModel> newData = groupedData.entries.map((entry) {
            final items = entry.value;

            final first = items.first;

            return PurchaseModel(
              purchaseId: first['purchase_id'],
              purchaseItemsId: first['purchase_items_id'],
              purchasePrice: (first['purchase_price'] as num).toDouble(),
              purchaseQuantity: first['purchase_quantity'],
              purchaseTotalPrice:
                  (first['purchase_total_price'] as num).toDouble(),
              purchasePayment: first['purchase_payment'],
              purchaseSupplierId: first['purchase_supplier_id'],
              purchaseDiscount: (first['purchase_discount'] as num).toDouble(),
              purchaseDate: first['purchase_date'],
              purchaseNumber: first['purchase_number'],
              purchaseFees: (first['purchase_fees'] as num).toDouble(),
              supplierName: first['supplier_name'],
              itemName: first['item_name'],
              supplierAddress: first['supplier_address'] ?? '',
              supplierPhone: first['supplier_phone'] ?? '',
              items: items.map((e) => PurchaseItem.fromJson(e)).toList(),
            );
          }).toList();

          purchaseData.addAll(newData);
        } else {
          hasMoreData = false;
        }
      } else {
        showErrorDialog(
          "",
          title: "Error",
          message: "Failed to fetch purchase data.",
        );
      }
    } catch (e) {
      showErrorDialog(
        e.toString(),
        title: "Error",
        message: "Error during fetch purchase data",
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  removeData(int purchaseNumber) async {
    int response = await sqlDb.deleteData(
        "tbl_purchase", 'purchase_number = $purchaseNumber');
    if (response > 0) {
      showSuccessSnackBar(TextRoutes.dataDeletedSuccess);
      getPurchaseData(isInitialSearch: true);
    } else {
      showErrorSnackBar(TextRoutes.failDeleteData);
    }
  }

  List<TextEditingController?> itemsController = [];

  @override
  void onInit() {
    //! Initialize controllers for adding items
    purchaseTotalPriceController = TextEditingController();
    itemsBuyingPriceController = TextEditingController();
    purchaseDateController = TextEditingController();
    itemsIdController = TextEditingController();
    groupByIdController = TextEditingController();
    groupByNameController = TextEditingController();

    //! Initialize controllers for viewing items
    itemCodeController = TextEditingController();
    buyingPriceController = TextEditingController();
    quantityController = TextEditingController();
    itemNameController = TextEditingController();
    supplierNameController = TextEditingController();
    supplierIdController = TextEditingController();
    paymentMethodNameController = TextEditingController();
    paymentMethodIdController = TextEditingController();
    purchaseDiscountController = TextEditingController();
    purchaseFeesController = TextEditingController();
    totalPriceController = TextEditingController();
    purchaseIdController = TextEditingController();
    purchaseTotalPriceController = TextEditingController();
    purchaseDateController = TextEditingController();
    purchaseSupplierNameController = TextEditingController();
    purchasePaymentMethodController = TextEditingController();

    itemsController = [
      purchaseIdController,
      purchaseTotalPriceController,
      purchaseDateController,
      purchaseSupplierNameController,
      purchasePaymentMethodController
    ];

    getUsers();
    getItems();
    getPurchaseData(isInitialSearch: true);
    rowIndexCounter = 0;
    rows.add(createRow(rowIndexCounter));
    super.onInit();
  }

  @override
  void dispose() {
    //! Dispose individual controllers
    itemsNameController.dispose();
    itemsSellingPriceController.dispose();
    itemsBuyingPriceController.dispose();
    purchaseDateController.dispose();
    itemsIdController.dispose();
    groupByIdController.dispose();
    groupByNameController.dispose();
    purchaseIdController.dispose();
    purchaseTotalPriceController.dispose();
    purchaseSupplierNameController.dispose();
    purchasePaymentMethodController.dispose();

    //! Dispose Buy Items controllers
    itemCodeController.dispose();
    buyingPriceController.dispose();
    quantityController.dispose();
    sellingPriceController.dispose();
    itemNameController.dispose();
    supplierNameController.dispose();
    supplierIdController.dispose();
    paymentMethodNameController.dispose();
    paymentMethodIdController.dispose();
    purchaseDiscountController.dispose();
    purchaseFeesController.dispose();
    totalPriceController.dispose();

    //! Dispose list controllers
    for (var controller in itemCodeControllers) {
      controller.dispose();
    }
    for (var controller in itemTypeControllers) {
      controller.dispose();
    }
    for (var controller in buyingPriceControllers) {
      controller.dispose();
    }
    for (var controller in discountBuyingPriceControllers) {
      controller.dispose();
    }
    for (var controller in quantityControllers) {
      controller.dispose();
    }
    for (var controller in sellingPriceControllers) {
      controller.dispose();
    }
    for (var controller in itemNameControllers) {
      controller.dispose();
    }
    for (var controller in itemOriginalTotalPriceControllers) {
      controller.dispose();
    }
    for (var controller in itemDiscountedTotalPriceControllers) {
      controller.dispose();
    }

    //! Dispose global keys if necessary (though typically not required for GlobalKey)
    formKey = GlobalKey<FormState>();
    formKeysCode = [];
    formKeysName = [];
    formKeysBuying = [];
    formKeysBuyingDiscount = [];
    formKeysQTY = [];
    formKeysOriginalTotalPrice = [];
    formKeysDiscountTotalPrice = [];

    super.dispose();
  }

  List<PurchaseRowModel> purchaseRow = [];
  void addRow() {
    purchaseRow.add(PurchaseRowModel(
      id: TextEditingController(text: ""),
      itemsName: TextEditingController(text: ""),
      itemsType: TextEditingController(text: ""),
      itemsQTY: TextEditingController(text: "0"),
      purchasePrice: TextEditingController(text: "0"),
      totalPurchasePrice: TextEditingController(text: "0"),
      discountTotalPurchasePrice: TextEditingController(text: "0"),
    ));
    update();
  }
}

Widget _customTextFields(
    String text,
    GlobalKey<FormState> formState,
    TextEditingController controller,
    String? Function(String?)? validator,
    bool isNumber,
    void Function(String)? onChanged) {
  return Form(
    key: formState,
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

class PurchaseRowModel {
  TextEditingController id;
  TextEditingController itemsName;
  TextEditingController itemsType;
  TextEditingController itemsQTY;
  TextEditingController purchasePrice;
  TextEditingController totalPurchasePrice;
  TextEditingController discountTotalPurchasePrice;

  PurchaseRowModel({
    required this.id,
    required this.itemsName,
    required this.itemsType,
    required this.itemsQTY,
    required this.purchasePrice,
    required this.totalPurchasePrice,
    required this.discountTotalPurchasePrice,
  });
}
