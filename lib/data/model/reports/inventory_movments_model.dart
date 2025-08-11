class InventoryMovementsModel {
  final int invoiceNumber;
  final String itemName;
  final String unitName;
  final String createDate;
  final double sellingPrice;
  final double costPrice;
  final double quantityPurchased;
  final double quantitySold;
  final double quantityReturnPurchase;
  final double quantityReturnSale;
  final double quantityRemaining;

  InventoryMovementsModel({
    required this.invoiceNumber,
    required this.itemName,
    required this.createDate,
    required this.sellingPrice,
    required this.unitName,
    required this.costPrice,
    required this.quantityPurchased,
    required this.quantitySold,
    required this.quantityReturnPurchase,
    required this.quantityReturnSale,
    required this.quantityRemaining,
  });

  factory InventoryMovementsModel.fromJson(Map<String, dynamic> json) {
    return InventoryMovementsModel(
      invoiceNumber: json['invoice_number'],
      itemName: json['item_name'],
      unitName: json['unit_name'],
      costPrice: json['item_cost_price'] ?? 0.0,
      sellingPrice: json['sale_price'],
      createDate: json['date'],
      quantityPurchased: (json['quantity_purchased'] as num).toDouble(),
      quantitySold: (json['quantity_sold'] as num).toDouble(),
      quantityReturnPurchase:
          (json['quantity_return_purchase'] as num).toDouble(),
      quantityReturnSale: (json['quantity_return_sale'] as num).toDouble(),
      quantityRemaining: (json['quantity_remaining'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoice_number': invoiceNumber,
      'item_name': itemName,
      'unit_name': unitName,
      'quantity_purchased': quantityPurchased,
      'quantity_sold': quantitySold,
      'quantity_return_purchase': quantityReturnPurchase,
      'quantity_return_sale': quantityReturnSale,
      'quantity_remaining': quantityRemaining,
    };
  }
}
