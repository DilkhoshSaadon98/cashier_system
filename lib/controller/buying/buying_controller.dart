import 'package:cashier_system/controller/buying/definition_buying_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/functions/calculate_fees.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/data/model/purchaes_model.dart';
import 'package:cashier_system/view/buying/components/buying_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyingController extends DefinitionBuyingController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<GlobalKey<FormState>> formKeysCode = [];
  List<GlobalKey<FormState>> formKeysName = [];
  List<GlobalKey<FormState>> formKeysBuying = [];
  List<GlobalKey<FormState>> formKeysBuyingDiscount = [];
  List<GlobalKey<FormState>> formKeysQTY = [];
  List<GlobalKey<FormState>> formKeysTotalPrice = [];

  int rowIndex = 0;
  int totalInvoicePrice = 0;
  DataRow createRow() {
    GlobalKey<FormState> formKeyTotalPrice = GlobalKey<FormState>();
    GlobalKey<FormState> formKeyBuying = GlobalKey<FormState>();
    GlobalKey<FormState> formKeyBuyingDiscount = GlobalKey<FormState>();
    GlobalKey<FormState> formKeyQTY = GlobalKey<FormState>();
    GlobalKey<FormState> formKeyName = GlobalKey<FormState>();
    GlobalKey<FormState> formKeyCode = GlobalKey<FormState>();
    TextEditingController itemCodeController = TextEditingController();
    TextEditingController buyingPriceController = TextEditingController();
    TextEditingController discountBuyingPriceController =
        TextEditingController();
    TextEditingController quantityController = TextEditingController();
    TextEditingController itemNameController = TextEditingController();
    TextEditingController itemTotalPricesController = TextEditingController();

    itemCodeControllers.add(itemCodeController);
    buyingPriceControllers.add(buyingPriceController);
    quantityControllers.add(quantityController);
    itemNameControllers.add(itemNameController);
    itemTotalPriceControllers.add(itemTotalPricesController);
    discountBuyingPriceControllers.add(discountBuyingPriceController);
    formKeysTotalPrice.add(formKeyTotalPrice);
    formKeysBuying.add(formKeyBuying);
    formKeysQTY.add(formKeyQTY);
    formKeysName.add(formKeyName);
    formKeysCode.add(formKeyCode);

    update();
    return DataRow(cells: [
      //! Code Items:
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
      //! Name Items
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
      //! Buying Price
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
            if (value.isEmpty) {
              buyingPriceController.text = "0";
            }

            if (buyingPriceController.text.isNotEmpty &&
                quantityController.text.isNotEmpty) {
              int result = int.parse(buyingPriceController.text) *
                  int.parse(quantityController.text);
              itemTotalPricesController.text = result.toString();
            }
            update();
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
      //! QTY
      DataCell(Form(
        key: formKeyQTY,
        child: TextFormField(
          controller: quantityController,
          textAlign: TextAlign.center,
          validator: (value) {
            return validInput(value!, 0, 20, "number");
          },
          onChanged: (value) {
            if (buyingPriceController.text.isEmpty) {
              buyingPriceController.text = "0";
            }
            if (itemTotalPricesController.text.isEmpty) {
              itemTotalPricesController.text = "0";
            }
            if (value.isEmpty) {
              quantityController.text = "";
            }
            double itemTotalPrices =
                double.parse(itemTotalPricesController.text);
            double parsedValue = value.isNotEmpty ? double.parse(value) : 0.0;

            if (value.isNotEmpty) {
              if (parsedValue != 0) {
                double divisionResult = itemTotalPrices / parsedValue;
                String result = divisionResult.isFinite
                    ? divisionResult.toStringAsFixed(2)
                    : "0";
                buyingPriceController.text = result;
              } else {
                buyingPriceController.text = "0";
              }
            }
            update();
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
      //! Total Price:
      DataCell(Form(
        key: formKeyTotalPrice,
        child: TextFormField(
          controller: itemTotalPricesController,
          textAlign: TextAlign.center,
          style: titleStyle,
          validator: (value) {
            return validInput(value!, 0, 20, "number");
          },
          onChanged: (value) {
            if (value.isEmpty) {
              itemTotalPricesController.text = "0";
            }

            if (itemTotalPricesController.text.isNotEmpty &&
                quantityController.text.isNotEmpty) {
              double result =
                  int.parse(value) / int.parse(quantityController.text);
              buyingPriceController.text = result.toStringAsFixed(2);
            }
            update();
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

  Map<String, dynamic> data = {};
  int purchaseCounter =
      0; // This will generate a unique purchase number for each transaction

  addItems() async {
    int purchaseNumber = await generateUniquePurchaseNumber();
    if (formKey.currentState!.validate()) {
      List<Map<String, dynamic>> items = [];
      for (int i = 0; i < rows.length; i++) {
        if (formKeysCode[i].currentState!.validate() &&
            formKeysName[i].currentState!.validate() &&
            formKeysBuying[i].currentState!.validate() &&
            formKeysQTY[i].currentState!.validate() && 
            formKeysTotalPrice[i].currentState!.validate()) {
          int purchasePrice = int.tryParse(buyingPriceControllers[i].text) ?? 0;
          int purchaseQuantity = int.tryParse(quantityControllers[i].text) ?? 0;
          String itemCode = itemCodeControllers[i].text.trim();
          String totalPrice = itemTotalPriceControllers[i].text.trim();

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
        }
      }
    }
  }

  Future<int> generateUniquePurchaseNumber() async {
    int result = 0;
    var response = await sqlDb.getData(
        "SELECT MAX(purchase_number) AS purchase_number FROM tbl_purchase");
    if (response[0]['purchase_number'] == null) {
      result = 0;
    } else {
      result = response[0]['purchase_number'];
    }
    return result;
  }

  List<dynamic> res = [];
  calculateDiscount() {
    if (formKey.currentState!.validate()) {
      for (int i = 0; i < rows.length; i++) {
        if (formKeysTotalPrice[i].currentState!.validate()) {
          int total = 0;
          for (int i = 0; i < itemTotalPriceControllers.length; i++) {
            total += int.parse(itemTotalPriceControllers[i].text);
          }
          buyingPriceControllers[i].text = (calculateFees(
                  int.parse(purchaseDiscountController!.text),
                  total,
                  itemTotalPriceControllers)[i])
              .toStringAsFixed(2);
        }
      }
    }
    update();
  }

  orderringDate(String group) async {
    var response = await sqlDb.getData(
        "SELECT * FROM purchaseView GROUP BY purchase_date ORDER BY $group ");
    purchaseData.clear();
    List responsedata = response ?? [];
    purchaseData.addAll(responsedata.map((e) => PurchaseModel.fromJson(e)));
    update();
  }

  getPurchaseData() async {
    String? itemsNO;
    String? itemsName;
    String? itemsSelling;
    String? itemsBuying;
    String? itemsDate;
    String? groupBy;

    if (itemsIdController!.text.isNotEmpty) {
      itemsNO = itemsIdController!.text;
    }
    if (itemsNameController!.text.isNotEmpty) {
      itemsName = itemsNameController!.text;
    }
    if (itemsSellingPriceController!.text.isNotEmpty) {
      itemsSelling = itemsSellingPriceController!.text;
    }
    if (itemsBuyingPriceController!.text.isNotEmpty) {
      itemsBuying = itemsBuyingPriceController!.text;
    }
    if (purchaseDateController!.text.isNotEmpty) {
      itemsDate = purchaseDateController!.text;
    }
    if (groupByNameController!.text.isNotEmpty) {
      groupBy = groupByNameController!.text;
    }
    var response = await buyingClass.searchItemsData(
        itemsBuying: itemsBuying,
        itemsDate: itemsDate,
        itemsName: itemsName,
        itemsNo: itemsNO,
        itemsSelling: itemsSelling,
        groupBy: groupBy);
    if (response['status'] == "success") {
      purchaseData.clear();
      List responsedata = response['data'] ?? [];
      purchaseData.addAll(responsedata.map((e) => PurchaseModel.fromJson(e)));
    }
    update();
  }

  clearFields() {
    itemsCodesData.clear();
    itemsNameData.clear();
  }

  List<TextEditingController?> itemsController = [];

  @override
  void onInit() {
    //! Initialize controllers for adding items
    itemsNameController = TextEditingController();
    itemsSellingPriceController = TextEditingController();
    itemsBuyingPriceController = TextEditingController();
    purchaseDateController = TextEditingController();
    itemsIdController = TextEditingController();
    groupByIdController = TextEditingController();
    groupByNameController = TextEditingController();

    //! Initialize controllers for viewing items
    itemCodeController = TextEditingController();
    buyingPriceController = TextEditingController();
    quantityController = TextEditingController();
    sellingPriceController = TextEditingController();
    itemNameController = TextEditingController();
    supplierNameController = TextEditingController();
    supplierIdController = TextEditingController();
    paymentMethodNameController = TextEditingController();
    paymentMethodIdController = TextEditingController();
    purchaseDiscountController = TextEditingController();
    totalPriceController = TextEditingController();

    itemsController = [
      itemsIdController,
      itemsNameController,
      purchaseDateController,
      itemsSellingPriceController,
      itemsBuyingPriceController
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
    itemsNameController?.dispose();
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
