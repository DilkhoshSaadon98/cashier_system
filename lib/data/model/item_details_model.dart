class ItemDetailsModel {
  final int? itemDetailsModelId;
  final int itemId;
  final int soldQuantity;
  final double lastPurchasePrice;
  final int currentStock;
  final String lastSupplier;

  ItemDetailsModel({
    this.itemDetailsModelId,
    required this.itemId,
    this.soldQuantity = 0,
    this.lastPurchasePrice = 0.0,
    this.currentStock = 0,
    this.lastSupplier = "",
  });

  factory ItemDetailsModel.fromMap(Map<String, dynamic> map) {
    return ItemDetailsModel(
      itemDetailsModelId: map['item_details_id'],
      itemId: map['item_id'],
      soldQuantity: map['sold_quantity'] ?? 0,
      lastPurchasePrice: map['last_purchase_price']?.toDouble() ?? 0.0,
      currentStock: map['current_stock'] ?? 0,
      lastSupplier: map['last_supplier'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item_details_id': itemDetailsModelId,
      'item_id': itemId,
      'sold_quantity': soldQuantity,
      'last_purchase_price': lastPurchasePrice,
      'current_stock': currentStock,
      'last_supplier': lastSupplier,
    };
  }
}
