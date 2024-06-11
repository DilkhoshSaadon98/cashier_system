class PurchaseModel {
  int? purchaseId;
  int? purchaseItemsId;
  int? purchasePrice;
  int? purchaseQuantity;
  int? sellingPrice;
  int? purchaseTotalPrice;
  String? purchasePayment;
  int? purchaseSupplierId;
  double? purchaseDiscount;
  String? purchaseDate;
  String? userName; // From users table
  String? itemName; // From items table

  PurchaseModel({
    this.purchaseId,
    this.purchaseItemsId,
    this.purchasePrice,
    this.purchaseQuantity,
    this.sellingPrice,
    this.purchaseTotalPrice,
    this.purchasePayment,
    this.purchaseSupplierId,
    this.purchaseDiscount,
    this.purchaseDate,
    this.userName,
    this.itemName,
  });

  // Method to convert from JSON
  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    return PurchaseModel(
      purchaseId: json['purchase_id'],
      purchaseItemsId: json['purchase_items_id'],
      purchasePrice: json['purchase_price'],
      purchaseQuantity: json['purchase_quantity'],
      sellingPrice: json['selling_price'],
      purchaseTotalPrice: json['purchase_total_price'],
      purchasePayment: json['purchase_payment'],
      purchaseSupplierId: json['purchase_supplier_id'],
      purchaseDiscount: json['purchase_discount']?.toDouble(),
      purchaseDate: json['purchase_date'],
      userName: json['users_name'],
      itemName: json['items_name'],
    );
  }

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'purchase_id': purchaseId,
      'purchase_items_id': purchaseItemsId,
      'purchase_price': purchasePrice,
      'purchase_quantity': purchaseQuantity,
      'selling_price': sellingPrice,
      'purchase_total_price': purchaseTotalPrice,
      'purchase_payment': purchasePayment,
      'purchase_supplier_id': purchaseSupplierId,
      'purchase_discount': purchaseDiscount,
      'purchase_date': purchaseDate,
      'users_name': userName,
      'items_name': itemName,
    };
  }
}
