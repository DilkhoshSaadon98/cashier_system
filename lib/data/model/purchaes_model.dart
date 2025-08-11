class PurchaseModel {
  final int? purchaseId;
  final int? purchaseItemsId;
  final int? purchaseNumber;
  final double? purchasePrice;
  final int? purchaseQuantity;
  final double? purchaseTotalPrice;
  final String? purchasePayment;
  final int? purchaseSupplierId;
  final double? purchaseDiscount;
  final String? purchaseDate;
  final double? purchaseFees;
  final String? supplierName;
  final String? itemName;
  final String? supplierAddress;
  final String? supplierPhone;

  final List<PurchaseItem>? items;

  PurchaseModel({
    this.purchaseId,
    this.purchaseItemsId,
    this.purchaseNumber,
    this.purchasePrice,
    this.purchaseQuantity,
    this.purchaseTotalPrice,
    this.purchasePayment,
    this.purchaseSupplierId,
    this.purchaseDiscount,
    this.purchaseDate,
    this.purchaseFees,
    this.supplierName,
    this.itemName,
    this.supplierAddress,
    this.supplierPhone,
    this.items,
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    return PurchaseModel(
      purchaseId: json['purchase_id'] as int?,
      purchaseItemsId: json['purchase_items_id'] as int?,
      purchaseNumber: json['purchase_number'] as int?,
      purchasePrice: json['purchase_price'] != null
          ? (json['purchase_price'] as num).toDouble()
          : null,
      purchaseQuantity: json['purchase_quantity'] as int?,
      purchaseTotalPrice: json['purchase_total_price'] != null
          ? (json['purchase_total_price'] as num).toDouble()
          : null,
      purchasePayment: json['purchase_payment'] as String?,
      purchaseSupplierId: json['purchase_supplier_id'] as int?,
      purchaseDiscount: json['purchase_discount'] != null
          ? (json['purchase_discount'] as num).toDouble()
          : null,
      purchaseDate: json['purchase_date'] as String?,
      purchaseFees: json['purchase_fees'] != null
          ? (json['purchase_fees'] as num).toDouble()
          : null,
      supplierName: json['supplier_name'] as String?,
      itemName: json['item_name'] as String?,
      supplierAddress: json['supplier_address'] as String?,
      supplierPhone: json['supplier_phone'] as String?,
      items: json['items'] != null
          ? (json['items'] as List)
              .map((e) => PurchaseItem.fromJson(e))
              .toList()
          : null,
    );
  }
}

class PurchaseItem {
  final String itemName;
  final int quantity;
  final double price;

  PurchaseItem({
    required this.itemName,
    required this.quantity,
    required this.price,
  });

  double get totalPrice => price * quantity;

  factory PurchaseItem.fromJson(Map<String, dynamic> json) {
    return PurchaseItem(
      itemName: json['item_name'],
      quantity: json['purchase_quantity'],
      price: json['purchase_price'],
    );
  }
}
