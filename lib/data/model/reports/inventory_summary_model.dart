class InventorySummaryModel {
  final int invoiceNumber;
  final String movementDate;
  final String type;
  final String itemName;
  final String unitName;
  final double quantity;
  final double costPrice;
  final double salePrice;
  final String note;
  final String? accountName;

  InventorySummaryModel({
    required this.invoiceNumber,
    required this.movementDate,
    required this.type,
    required this.itemName,
    required this.unitName,
    required this.quantity,
    required this.costPrice,
    required this.salePrice,
    required this.note,
    this.accountName,
  });

  factory InventorySummaryModel.fromMap(Map<String, dynamic> map) {
    return InventorySummaryModel(
      invoiceNumber: map['invoice_number'],
      movementDate: map['date'],
      type: map['type'],
      itemName: map['item_name'],
      unitName: map['unit_name'],
      quantity: (map['quantity'] as num).toDouble(),
      costPrice: (map['cost_price'] as num).toDouble(),
      salePrice: (map['sale_price'] as num).toDouble(),
      note: map['note'],
      accountName: map['account_name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'invoice_number': invoiceNumber,
      'date': movementDate,
      'type': type,
      'item_name': itemName,
      'unit_name': unitName,
      'quantity': quantity,
      'unit_price': costPrice,
      'note': note,
      'account_name': accountName,
    };
  }
}
