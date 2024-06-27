import 'package:cashier_system/controller/buying/definition_buying_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/functions/calculate_fees.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/data/model/purchaes_model.dart';
import 'package:cashier_system/view/buying/components/buying_text_field.dart';
import 'package:flutter/material.dart';

class BuyingController extends DefinitionBuyingController {
  bool rowAdded = false;

  int totalInvoicePrice = 0;

  DataRow createRow() {
    GlobalKey<FormState> formKeyTotalPrice = GlobalKey<FormState>();
    GlobalKey<FormState> formKeyBuying = GlobalKey<FormState>();
    GlobalKey<FormState> formKeyQTY = GlobalKey<FormState>();
    GlobalKey<FormState> formKeyName = GlobalKey<FormState>();
    GlobalKey<FormState> formKeyCode = GlobalKey<FormState>();

    TextEditingController itemCodeController = TextEditingController();
    TextEditingController buyingPriceController = TextEditingController();
    TextEditingController quantityController = TextEditingController();
    TextEditingController itemNameController = TextEditingController();
    TextEditingController itemTotalPricesController = TextEditingController();

    itemCodeControllers.add(itemCodeController);
    buyingPriceControllers.add(buyingPriceController);
    quantityControllers.add(quantityController);
    itemNameControllers.add(itemNameController);
    itemTotalPriceControllers.add(itemTotalPricesController);

    formKeysTotalPrice.add(formKeyTotalPrice);
    formKeysBuying.add(formKeyBuying);
    formKeysQTY.add(formKeyQTY);
    formKeysName.add(formKeyName);
    formKeysCode.add(formKeyCode);

    rowAdded = false;

    update();

    return DataRow(cells: [
      DataCell(Form(
        key: formKeyCode,
        child: CustomTextFormFieldBuying(
          hinttext: "Items Code",
          valid: (value) {
            return validInput(value!, 0, 10, "number");
          },
          isNumber: true,
          onTap: () {},
          nameController: itemCodeController,
          idController: itemNameController,
          data: dropDownListCodes,
        ),
      )),
      DataCell(Form(
        key: formKeyName,
        child: CustomTextFormFieldBuying(
          hinttext: "Items Name",
          valid: (value) {
            return validInput(value!, 0, 10, "");
          },
          isNumber: false,
          nameController: itemNameController,
          idController: itemCodeController,
          data: dropDownList,
          onTap: () {},
        ),
      )),
      DataCell(Form(
        key: formKeyBuying,
        child: TextFormField(
          controller: buyingPriceController,
          textAlign: TextAlign.center,
          style: titleStyle,
          validator: (value) {
            return validInput(value!, 0, 20, "");
          },
          onChanged: (value) {
            handleFieldUpdate(
              buyingPriceController: buyingPriceController,
              quantityController: quantityController,
              itemTotalPricesController: itemTotalPricesController,
            );
          },
          decoration: InputDecoration(
            hintText: "Buying Price",
            errorStyle: bodyStyle.copyWith(
                overflow: TextOverflow.clip, color: Colors.red),
            hintStyle: bodyStyle,
            border: InputBorder.none,
          ),
          keyboardType: TextInputType.number,
        ),
      )),
      DataCell(Form(
        key: formKeyQTY,
        child: TextFormField(
          controller: quantityController,
          textAlign: TextAlign.center,
          validator: (value) {
            return validInput(value!, 0, 20, "number");
          },
          onChanged: (value) {
            handleFieldUpdate(
              buyingPriceController: buyingPriceController,
              quantityController: quantityController,
              itemTotalPricesController: itemTotalPricesController,
            );
          },
          style: titleStyle,
          decoration: InputDecoration(
              errorStyle: bodyStyle.copyWith(color: Colors.red),
              hintText: "QTY",
              hintStyle: bodyStyle,
              border: InputBorder.none),
          keyboardType: TextInputType.number,
        ),
      )),
      DataCell(Form(
        key: formKeyTotalPrice,
        child: TextFormField(
          controller: itemTotalPricesController,
          textAlign: TextAlign.center,
          style: titleStyle,
          validator: (value) {
            return validInput(value!, 0, 20, "");
          },
          onChanged: (value) {
            handleFieldUpdate(
              buyingPriceController: buyingPriceController,
              quantityController: quantityController,
              itemTotalPricesController: itemTotalPricesController,
            );
          },
          decoration: InputDecoration(
              errorStyle: bodyStyle.copyWith(color: Colors.red),
              hintText: "Total Price",
              hintStyle: bodyStyle,
              border: InputBorder.none),
        ),
      )),
    ]);
  }

  void handleFieldUpdate({
    required TextEditingController quantityController,
    required TextEditingController itemTotalPricesController,
    required TextEditingController buyingPriceController,
  }) {
    String quantity = quantityController.text;
    String totalPrice = itemTotalPricesController.text;

    if (totalPrice.isNotEmpty && quantity.isNotEmpty) {
      double result = int.parse(totalPrice) / int.parse(quantity);
      print(result);
      buyingPriceController.text = result.toStringAsFixed(2);
    }

    // if (!rowAdded && (quantity.isNotEmpty || totalPrice.isNotEmpty)) {
    //   rows.add(createRow());
    //   rowAdded = true;
    //   update();
    // }

    update();
  }

  Map<String, dynamic> data = {};
  int purchaseCounter = 0;

  void addItems(BuildContext context) async {
    int purchaseNumber = await generateUniquePurchaseNumber();
    if (formKey.currentState!.validate()) {
      bool allRowsInserted = true;
      var totalPrice = 0;
      for (int j = 0; j < itemTotalPriceControllers.length; j++) {
        totalPrice += int.parse(itemTotalPriceControllers[j].text);
      }
      for (int i = 0; i < itemCodeControllers.length; i++) {
        if (formKeysCode[i].currentState!.validate() &&
            formKeysName[i].currentState!.validate() &&
            formKeysBuying[i].currentState!.validate() &&
            formKeysQTY[i].currentState!.validate() &&
            formKeysTotalPrice[i].currentState!.validate()) {
          int purchasePrice = int.tryParse(buyingPriceControllers[i].text) ?? 0;
          int purchaseQuantity = int.tryParse(quantityControllers[i].text) ?? 0;
          String itemCode = itemCodeControllers[i].text.trim();
          print(purchasePrice);
          Map<String, dynamic> itemData = {
            'purchase_items_id': itemCode,
            'purchase_price': purchasePrice,
            'purchase_quantity': purchaseQuantity,
            'purchase_total_price': totalPrice,
            'purchase_number': purchaseNumber + 1,
            'purchase_date': currentTime,
            'purchase_discount': purchaseDiscountController!.text,
            'purchase_payment': paymentMethodNameController!.text,
            'purchase_supplier_id': supplierIdController!.text,
          };
          await sqlDb.insertData("tbl_purchase", itemData);
          itemCodeControllers[i].clear();
          buyingPriceControllers[i].clear();
          quantityControllers[i].clear();
          itemNameControllers[i].clear();
          itemTotalPriceControllers[i].clear();
        } else {
          allRowsInserted = false;
        }
      }

      if (allRowsInserted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All items inserted successfully'),
            duration: Duration(seconds: 2),
          ),
        );
        getPurchaseData();
        rows.clear();
      }
    }
  }

  List<dynamic> res = [];

  void calculateDiscount() {
    if (formKey.currentState!.validate()) {
      for (int i = 0; i < rows.length; i++) {
        if (formKeysTotalPrice[i].currentState!.validate()) {
          double total = 0;
          for (int j = 0; j < itemTotalPriceControllers.length; j++) {
            print(itemTotalPriceControllers[j].text);
            total += double.parse(itemTotalPriceControllers[j].text);
          }
          buyingPriceControllers[i].text = (calculateFees(
                  int.parse(purchaseDiscountController!.text),
                  5,
                  itemTotalPriceControllers)[i])
              .toStringAsFixed(2);
        }
      }
    }
    update();
  }

  void orderringDate(String group) async {
    var response = await sqlDb.getData(
        "SELECT * FROM purchaseView GROUP BY purchase_date ORDER BY $group ");
    purchaseData.clear();
    List responsedata = response ?? [];
    purchaseData.addAll(responsedata.map((e) => PurchaseModel.fromJson(e)));
    update();
  }

  void getPurchaseData() async {
    String? purchaseId;
    String? purchaseTotalPrice;
    String? itemsDate;
    String? supplierName;
    String? purchasePayment;
    String? groupBy;

    if (purchaseIdController!.text.isNotEmpty) {
      purchaseId = purchaseIdController!.text;
    }
    if (purchaseTotalPriceController!.text.isNotEmpty) {
      purchaseTotalPrice = purchaseTotalPriceController!.text;
    }
    if (purchaseDateController!.text.isNotEmpty) {
      itemsDate = purchaseDateController!.text;
    }
    if (purchaseSupplierNameController!.text.isNotEmpty) {
      supplierName = purchaseSupplierNameController!.text;
    }
    if (purchasePaymentMethodController!.text.isNotEmpty) {
      purchasePayment = purchasePaymentMethodController!.text;
    }
    if (groupByNameController!.text.isNotEmpty) {
      groupBy = groupByNameController!.text;
    }
    var response = await buyingClass.searchItemsData(
        itemsDate: itemsDate,
        purchaseTotalPrice: purchaseTotalPrice,
        purchaseId: purchaseId,
        supplierName: supplierName,
        purchasePayment: purchasePayment,
        groupBy: groupBy);
    if (response['status'] == "success") {
      purchaseData.clear();
      List responsedata = response['data'] ?? [];
      purchaseData.addAll(responsedata.map((e) => PurchaseModel.fromJson(e)));
      purchaseIdController!.clear();
      purchaseTotalPriceController!.clear();
      purchaseDateController!.clear();
      purchaseSupplierNameController!.clear();
      purchasePaymentMethodController!.clear();
    }
    update();
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

    getItems();
    getCodes();
    getUsers();
    getPurchaseData();
    rows.add(createRow());
    super.onInit();
  }

  @override
  void onClose() {
    //! Dispose controllers for adding items
    purchaseTotalPriceController?.dispose();
    itemsSellingPriceController?.dispose();
    itemsBuyingPriceController?.dispose();
    purchaseDateController?.dispose();
    itemsIdController?.dispose();
    groupByIdController?.dispose();
    groupByNameController?.dispose();

    //! Dispose controllers for viewing items
    itemCodeController?.dispose();
    buyingPriceController?.dispose();
    quantityController?.dispose();
    sellingPriceController?.dispose();
    itemNameController?.dispose();
    supplierNameController?.dispose();
    supplierIdController?.dispose();
    paymentMethodNameController?.dispose();
    paymentMethodIdController?.dispose();
    purchaseDiscountController?.dispose();
    totalPriceController?.dispose();

    super.onClose();
  }
}
