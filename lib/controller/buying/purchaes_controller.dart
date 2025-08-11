import 'package:cashier_system/controller/buying/definition_buying_controller.dart';
import 'package:cashier_system/data/model/items_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PurchaseItem {
  String code = '';
  String name = '';
  double qty = 1;
  double price = 0.0;

  double get total => qty * price;
}

class PurchaseController extends DefinitionBuyingController {
  TextEditingController nameController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();
  TextEditingController totalPriceController = TextEditingController();

  List<BuyingRowModel> rowss = [];
  List<PurchaseItem> items = [PurchaseItem()];
  double discount = 0.0;
  double fees = 0.0;

  void updateRow(int index, String field, String value) {
    final item = items[index];
    switch (field) {
      case 'code':
        item.code = value;
        break;
      case 'name':
        item.name = value;
        break;
      case 'qty':
        item.qty = double.tryParse(value) ?? 1.0;
        break;
      case 'price':
        item.price = double.tryParse(value) ?? 0.0;
        break;
    }

    if (index == items.length - 1 && item.code.isNotEmpty) {
      items.add(PurchaseItem());
    }
    update();
  }

  void setDiscount(String val) {
    discount = double.tryParse(val) ?? 0.0;
    update();
  }

  void setFees(String val) {
    fees = double.tryParse(val) ?? 0.0;
    update();
  }

  int get itemCount => items.where((e) => e.code.isNotEmpty).length;
  double get discountPerItem => itemCount > 0 ? discount / itemCount : 0.0;
  double get feesPerItem => itemCount > 0 ? fees / itemCount : 0.0;
  double get totalBeforeExtras =>
      items.fold(0.0, (sum, item) => sum + item.total);
  double get grandTotal => items.fold(
        0.0,
        (sum, item) => item.code.isNotEmpty
            ? sum + item.total - discountPerItem + feesPerItem
            : sum,
      );
  void initializeRows() {
    if (rowss.isEmpty) {
      rowss.add(BuyingRowModel());
    }
    update();
  }

  @override
  void onInit() {
    initializeRows();
    getItems();
    super.onInit();
  }
}

class CustomSelectedListItems {
  final String name;
  final String value;
  final String? desc;
  final String? price;

  CustomSelectedListItems({
    required this.name,
    required this.value,
    this.desc,
    this.price,
  });
}

class BuyingRowModel {
  ItemsModel? selectedItem; // العنصر المختار في هذا الصف
  TextEditingController codeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();

  BuyingRowModel({this.selectedItem});

  void dispose() {
    codeController.dispose();
    nameController.dispose();
    purchasePriceController.dispose();
  }
}
