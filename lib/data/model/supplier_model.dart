class SupplierModel {
  final int? supplierId;
  final String supplierName;
  final int accountId;
  final String? supplierEmail;
  final String? supplierPhone2;
  final String supplierPhone;
  final String supplierAddress;
  final String supplierCreateDate;
  final String? supplierNote;

  SupplierModel({
    this.supplierId,
    required this.supplierName,
    required this.accountId,
    this.supplierEmail,
    this.supplierPhone2,
    required this.supplierPhone,
    required this.supplierAddress,
    required this.supplierCreateDate,
    this.supplierNote,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      supplierId: json['supplier_id'],
      supplierName: json['supplier_name'],
      accountId: json['account_id'],
      supplierEmail: json['supplier_email'],
      supplierPhone2: json['supplier_phone2'],
      supplierPhone: json['supplier_phone'],
      supplierAddress: json['supplier_address'],
      supplierCreateDate: json['supplier_create_date'],
      supplierNote: json['supplier_note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (supplierId != null) 'supplier_id': supplierId,
      'supplier_name': supplierName,
      'account_id': accountId,
      'supplier_email': supplierEmail,
      'supplier_phone2': supplierPhone2,
      'supplier_phone': supplierPhone,
      'supplier_address': supplierAddress,
      'supplier_create_date': supplierCreateDate,
      'supplier_note': supplierNote,
    };
  }
}
