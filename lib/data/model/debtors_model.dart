class DebtorsModel {
  final int debtorsId;
  final String debtorsName;
  final int totalInvoicesCount;
  final int totalImportsCount;
  final int totalInvoiceValueDept;
  final int totalImportValue;
  final int totalCustomerDebtorBallance;

  DebtorsModel({
    required this.debtorsId,
    required this.debtorsName,
    required this.totalInvoicesCount,
    required this.totalImportsCount,
    required this.totalInvoiceValueDept,
    required this.totalImportValue,
    required this.totalCustomerDebtorBallance,
  });

  factory DebtorsModel.fromJson(Map<String, dynamic> json) {
    return DebtorsModel(
      debtorsId: json['id'],
      debtorsName: json['users_name'],
      totalInvoicesCount: json['total_invoices_count'],
      totalImportsCount: json['total_imports_count'],
      totalInvoiceValueDept: json['total_invoice_value_dept'],
      totalImportValue: json['total_import_value'],
      totalCustomerDebtorBallance: json['total_customer_balance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'users_name': debtorsName,
      'total_invoices_count': totalInvoicesCount,
      'total_imports_count': totalImportsCount,
      'total_invoice_value_dept': totalInvoiceValueDept,
      'total_import_value': totalImportValue,
      'total_customer_debtor_price': totalCustomerDebtorBallance,
    };
  }
}
