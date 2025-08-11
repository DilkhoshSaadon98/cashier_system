class DebtorsModel {
  final int debtorsId;
  final String debtorsName;
  final double totalInvoicesBalance;
  final double totalImportsBalance;
  final double totalExportsBalanceNonEmployee;
  final double totalCustomerBalance;

  DebtorsModel({
    required this.debtorsId,
    required this.debtorsName,
    required this.totalInvoicesBalance,
    required this.totalImportsBalance,
    required this.totalExportsBalanceNonEmployee,
    required this.totalCustomerBalance,
  });

  factory DebtorsModel.fromJson(Map<String, dynamic> json) {
    return DebtorsModel(
      debtorsId: json['creditor_debtor_id'],
      debtorsName: json['creditor_debtor_supplier'],
      totalInvoicesBalance: json['total_dept_invoices_balance']?.toDouble(),
      totalImportsBalance: json['total_imports_balance']?.toDouble(),
      totalExportsBalanceNonEmployee: json['total_exports_balance']?.toDouble(),
      totalCustomerBalance: json['total_customer_balance'],
    );
  }


}
