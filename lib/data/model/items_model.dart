import 'dart:convert';

class ItemsModel {
  final int? itemsId;
  final String itemsName;
  final String itemsBarcode;
  final double itemsSellingPrice;
  final double itemsBuyingPrice;
  final double itemsWholesalePrice;
  final double itemsCostPrice;
  final double itemsBaseQty;
  final String itemsDescription;
  final int itemsCategoryId;
  final String itemsImage;
  final double itemsCount;
  final String? itemsCreateDate;
  final String? productionDate;
  final String? expiryDate;
  final String baseUnitName;
  final int mainUnitId;
  final List<AltUnit> altUnits;
  final String categoriesName;

  ItemsModel({
    this.itemsId,
    this.itemsBaseQty = 0.0,
    required this.itemsName,
    this.itemsBarcode = "",
    this.itemsSellingPrice = 0.0,
    this.itemsBuyingPrice = 0.0,
    this.itemsWholesalePrice = 0.0,
    this.itemsCostPrice = 0.0,
    this.itemsDescription = "",
    this.categoriesName = "",
    required this.itemsCategoryId,
    this.itemsImage = "",
    this.itemsCreateDate,
    this.itemsCount = 0.0,
    this.baseUnitName = "Pcs",
    this.productionDate,
    this.expiryDate,
    this.mainUnitId = 0,
    this.altUnits = const [],
  });

  factory ItemsModel.fromMap(Map<String, dynamic> map) {
    List<AltUnit> altUnitsList = [];

    if (map['alt_units'] != null && map['alt_units'] != "") {
      // Decode JSON string first
      final unitsData = jsonDecode(map['alt_units']) as List<dynamic>;
      altUnitsList = unitsData.map((u) => AltUnit.fromMap(u)).toList();
    }

    return ItemsModel(
      itemsId: map['item_id'],
      itemsName: map['item_name'],
      itemsBarcode: map['main_unit_barcode'] ?? "",
      itemsSellingPrice: map['main_unit_price']?.toDouble() ?? 0.0,
      itemsBuyingPrice: map['item_buying_price']?.toDouble() ?? 0.0,
      itemsWholesalePrice: map['item_wholesale_price']?.toDouble() ?? 0.0,
      itemsCostPrice: map['item_cost_price']?.toDouble() ?? 0.0,
      itemsBaseQty: map['item_count'] ?? 0,
      itemsDescription: map['item_description'] ?? "",
      itemsCategoryId: map['item_category_id'],
      itemsImage: map['item_image'] ?? "",
      itemsCreateDate: map['item_create_date'],
      itemsCount: map['item_count'] ?? 0.0,
      baseUnitName: map['main_unit_name'] ?? "",
      mainUnitId: map['main_unit_id'] ?? 0,
      altUnits: altUnitsList,
      productionDate: map['item_production_date'],
      expiryDate: map['item_expiry_date'],
      categoriesName: map['categories_name'] ?? "",
    );
  }
}

class AltUnit {
  final int unitId;
  final String unitName;
  final double price;
  final String barcode;
  final double unitFactor;

  AltUnit({
    required this.unitId,
    required this.unitName,
    required this.price,
    required this.unitFactor,
    this.barcode = "",
  });

  factory AltUnit.fromMap(Map<String, dynamic> map) {
    return AltUnit(
      unitId: map['unit_id'],
      unitName: map['unit_name'] ?? "",
      price: map['price']?.toDouble() ?? 0.0,
      unitFactor: map['factor']?.toDouble() ?? 1.0,
      barcode: map['barcode'] ?? "",
    );
  }
}
