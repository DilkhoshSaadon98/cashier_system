import 'package:cashier_system/controller/buying/definition_buying_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/core/dialogs/snackbar_helper.dart';
import 'package:cashier_system/core/functions/calculate_discount.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/data/model/items_model.dart';
import 'package:cashier_system/data/model/purchaes_model.dart';
import 'package:flutter/material.dart';
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

//? Calculate total Purchase Price:
  double totalPurchaseCalculatedPrice = 0.0;
  void calculateTotalPrice() {
    totalPurchaseCalculatedPrice = 0.0;

    for (var row in purchaseRow) {
      double discountedTotal =
          double.tryParse(row.discountTotalPurchasePriceController.text) ?? 0.0;
      totalPurchaseCalculatedPrice += discountedTotal;
    }

    update();
  }

//? Remove Empty Rows:
  void removeEmptyRows() {
    try {
      for (int i = purchaseRow.length - 1; i >= 0; i--) {
        final row = purchaseRow[i];
        final isEmpty = (row.purchasePriceController.text.isEmpty) ||
            (row.itemsModel!.itemsName.isEmpty);

        if (isEmpty) {
          row.dispose();
          purchaseRow.removeAt(i);
        }
      }
      if (purchaseRow.isEmpty) {
        showErrorSnackBar(TextRoutes.noData);
        changeShowSaveButton(false);
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

  void calculatePrice() {
    try {
      removeEmptyRows();

      double grandTotal = 0.0;

      // 1️⃣ Calculate total per row from **base price** (never overwritten by discounts)
      for (var row in purchaseRow) {
        double qty = double.tryParse(row.itemsQTYController.text) ?? 1.0;

        // Use row.itemsModel!.itemsBuyingPrice as the base price
        double basePrice = row.itemsModel?.itemsBuyingPrice ?? 0.0;

        double totalPurchase = qty * basePrice;
        row.totalPurchasePriceController.text =
            totalPurchase.toStringAsFixed(2);

        grandTotal += totalPurchase;
      }

      // 2️⃣ Apply discount/fees proportionally from base total
      for (var row in purchaseRow) {
        double baseTotal =
            double.tryParse(row.totalPurchasePriceController.text) ?? 0.0;

        double discount = 0.0;
        double fees = 0.0;

        if (purchaseDiscountController.text.isNotEmpty) {
          discount = calculateFeesAndDiscountFunction(
              int.tryParse(purchaseDiscountController.text) ?? 0,
              grandTotal,
              purchaseRow)[purchaseRow.indexOf(row)];
        }

        if (purchaseFeesController.text.isNotEmpty) {
          fees = calculateFeesAndDiscountFunction(
              int.tryParse(purchaseFeesController.text) ?? 0,
              grandTotal,
              purchaseRow)[purchaseRow.indexOf(row)];
        }

        double finalPrice = baseTotal - discount + fees;
        row.discountTotalPurchasePriceController.text =
            finalPrice.toStringAsFixed(2);

        double qty = double.tryParse(row.itemsQTYController.text) ?? 1.0;
        row.purchasePrice = qty != 0 ? finalPrice / qty : 0.0;
        row.purchasePriceController.text =
            row.purchasePrice!.toStringAsFixed(2);
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
      if (!detailsFormKey.currentState!.validate() ||
          !itemsFormKey.currentState!.validate()) {
        showErrorSnackBar(TextRoutes.formValidationFailed);
        return;
      }
      String transactionNumber = await generateVoucherNumber();
      String dataTime =
          dateController.text.isEmpty ? currentTime : dateController.text;
      double totalPrice = totalPurchaseCalculatedPrice;
      double purchaseDiscount =
          double.tryParse(purchaseDiscountController.text) ?? 0.0;
      double purchaseFees = double.tryParse(purchaseFeesController.text) ?? 0.0;
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
        'transaction_date': dataTime,
        'transaction_amount': totalPrice,
        'transaction_note':
            "فاتورة مشتريات للمورد ${supplierNameController.text}",
        'transaction_discount': purchaseDiscount,
        'transaction_number': transactionNumber,
        'source_account_id': sourceAccountId,
        'target_account_id': targetAccountId,
      };
      await sqlDb.insertData("tbl_transactions", transactionData);

      // الآن نضيف كل صنف في جدول الشراء ونحدث المخزون
      for (int i = purchaseRow.length - 1; i >= 0; i--) {
        double purchasePrice = double.tryParse(
                purchaseRow[i].discountTotalPurchasePriceController.text) ??
            0.0;
        double qty =
            double.tryParse(purchaseRow[i].itemsQTYController.text) ?? 0.0;
        double factor =
            double.tryParse(purchaseRow[i].factorController.text) ?? 1.0;

        double purchaseQuantity = qty * factor;
        int itemCode = purchaseRow[i].id!;
        // بيانات الشراء لكل صنف
        Map<String, dynamic> itemData = {
          'purchase_items_id': itemCode,
          'purchase_price': purchasePrice,
          'purchase_quantity': purchaseQuantity,
          'purchase_total_price': purchasePrice * purchaseQuantity,
          'purchase_number': transactionNumber,
          'purchase_date': dataTime,
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
            "UPDATE tbl_items SET item_count = item_count + $purchaseQuantity WHERE item_id = $itemCode",
          );
          // إضافة حركة مخزون (purchase)
          Map<String, dynamic> inventoryMovementData = {
            'item_id': itemCode,
            'movement_type': 'purchase',
            'quantity': purchaseQuantity,
            'cost_price': purchasePrice,
            'movement_date': dataTime,
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
      purchaseRow.clear();
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
        purchaseData.addAll(rawList.map((e) => PurchaseModel.fromJson(e)));
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
    addRow();
    getPurchaseData(isInitialSearch: true);
    rowIndexCounter = 0;
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

    //! Dispose global keys if necessary (though typically not required for GlobalKey)
    detailsFormKey = GlobalKey<FormState>();

    super.dispose();
  }

  void addRow() {
    purchaseRow.add(PurchaseRowModel(
      id: null,
      itemsModel: null,
      itemsType: null,
      itemsQTY: null,
      purchasePrice: null,
      totalPurchasePrice: null,
      discountTotalPurchasePrice: null,
    ));
    update();
  }

  void removeRow(int index) {
    purchaseRow.removeAt(index);
    update();
  }
}

void updatePurchaseFields({
  required TextEditingController qtyController,
  required TextEditingController purchasePriceController,
  required TextEditingController totalPriceController,
  String updatedField = 'qty', // 'qty', 'purchasePrice', 'totalPrice'
}) {
  final q = double.tryParse(qtyController.text) ?? 0.0;
  final p = double.tryParse(purchasePriceController.text) ?? 0.0;
  final tp = double.tryParse(totalPriceController.text) ?? 0.0;

  if (updatedField == 'qty' || updatedField == 'purchasePrice') {
    // Calculate total price
    final newTP = q * p;
    totalPriceController.text = newTP.toStringAsFixed(2);
  } else if (updatedField == 'totalPrice') {
    // Calculate purchase price
    if (q != 0) {
      final newP = tp / q;
      purchasePriceController.text = newP.toStringAsFixed(2);
    }
  }
}

class PurchaseRowModel {
  int? id;
  ItemsModel? itemsModel;
  String? itemsType;
  double? itemsQTY;
  double? purchasePrice;
  double? totalPurchasePrice;
  double? discountTotalPurchasePrice;
  double? factor;

  // Controllers
  final TextEditingController idController;
  final TextEditingController itemsTypeController;
  final TextEditingController itemsQTYController;
  final TextEditingController purchasePriceController;
  final TextEditingController totalPurchasePriceController;
  final TextEditingController discountTotalPurchasePriceController;
  final TextEditingController factorController;

  PurchaseRowModel(
      {this.id,
      this.itemsModel,
      this.itemsType,
      this.itemsQTY,
      this.purchasePrice,
      this.totalPurchasePrice,
      this.discountTotalPurchasePrice,
      this.factor = 1})
      : idController = TextEditingController(text: id?.toString() ?? ''),
        itemsTypeController = TextEditingController(text: itemsType ?? ''),
        itemsQTYController =
            TextEditingController(text: itemsQTY?.toString() ?? ''),
        purchasePriceController =
            TextEditingController(text: purchasePrice?.toString() ?? ''),
        totalPurchasePriceController =
            TextEditingController(text: totalPurchasePrice?.toString() ?? ''),
        discountTotalPurchasePriceController = TextEditingController(
            text: discountTotalPurchasePrice?.toString() ?? ''),
        factorController =
            TextEditingController(text: factor?.toString() ?? '');

  void dispose() {
    idController.dispose();
    itemsTypeController.dispose();
    itemsQTYController.dispose();
    purchasePriceController.dispose();
    totalPurchasePriceController.dispose();
    discountTotalPurchasePriceController.dispose();
  }
}
