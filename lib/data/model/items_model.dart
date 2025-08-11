class ItemsModel {
  final int? itemsId;
  final String itemsName;
  final String itemsBarcode;
  final double itemsSellingPrice;
  final double itemsBuyingPrice;
  final double itemsWholesalePrice;
  final double itemsCostPrice;
  final double itemsBaseQty;
  final double itemsAltQty;
  final double unitConversion;
  final String unitName;
  final String altUnitName;
  final String itemsDescription;
  final String categoriesName;
  final int itemsCategoryId;
  final String itemsImage;
  final String? itemsCreateDate;
  final String? productionDate;
  final String? expiryDate;

  ItemsModel(
      {this.itemsId,
      this.itemsBaseQty = 0.0,
      this.itemsAltQty = 0.0,
      this.altUnitName = "",
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
      this.unitName = "Pcs",
      this.unitConversion = 1,
      this.productionDate,
      this.expiryDate});

  factory ItemsModel.fromMap(Map<String, dynamic> map) {
    return ItemsModel(
      itemsId: map['item_id'],
      itemsName: map['item_name'],
      itemsBarcode: map['item_barcode'] ?? "",
      itemsSellingPrice: map['item_selling_price']?.toDouble() ?? 0.0,
      itemsBuyingPrice: map['item_buying_price']?.toDouble() ?? 0.0,
      itemsWholesalePrice: map['item_wholesale_price']?.toDouble() ?? 0.0,
      itemsCostPrice: map['item_cost_price']?.toDouble() ?? 0.0,
      itemsBaseQty: map['item_base_quantity'] ?? 0,
      itemsAltQty: map['item_alt_quantity'] ?? 0,
      itemsDescription: map['item_description'] ?? "",
      itemsCategoryId: map['item_category_id'],
      itemsImage: map['item_image'] ?? "",
      itemsCreateDate: map['item_create_date'],
      altUnitName: map['alt_unit_name'] ?? "",
      unitName: map['unit_name'] ?? "",
      unitConversion: map['unit_conversion'] ?? 1,
      productionDate: map['production_date'],
      expiryDate: map['expiry_date'],
      categoriesName: map['categories_name'] ?? "",
    );
  }
}
