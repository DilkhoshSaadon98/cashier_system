class GeneralLedgerModel {
  final int id;
  final int voucherNo;
  final String transactionType;
  final String? transactionDate;
  final double amount;
  final double? discount;
  final String? description;
  final int sourceAccountId;
  final int targetAccountId;
  final String sourceAccountName;
  final String sourceAccountType;
  final String targetAccountName;
  final String targetAccountType;

  GeneralLedgerModel({
    required this.id,
    required this.voucherNo,
    required this.transactionType,
    this.transactionDate,
    required this.amount,
    this.discount,
    this.description,
    required this.sourceAccountId,
    required this.targetAccountId,
    required this.sourceAccountName,
    required this.sourceAccountType,
    required this.targetAccountName,
    required this.targetAccountType,
  });

  factory GeneralLedgerModel.fromJson(Map<String, dynamic> json) {
    return GeneralLedgerModel(
      id: json['id'],
      voucherNo: json['voucher_no'],
      transactionType: json['transaction_type'],
      transactionDate: (json['transaction_date'] == "") ? null : json['transaction_date'],
      amount: (json['amount'] ?? 0).toDouble(),
      discount: json['discount'] == null ? null : (json['discount'] as num).toDouble(),
      description: json['description'],
      sourceAccountId: json['source_account_id'],
      targetAccountId: json['target_account_id'],
      sourceAccountName: json['source_account_name'],
      sourceAccountType: json['source_account_type'],
      targetAccountName: json['target_account_name'],
      targetAccountType: json['target_account_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'voucher_no': voucherNo,
      'transaction_type': transactionType,
      'transaction_date': transactionDate,
      'amount': amount,
      'discount': discount,
      'description': description,
      'source_account_id': sourceAccountId,
      'target_account_id': targetAccountId,
      'source_account_name': sourceAccountName,
      'source_account_type': sourceAccountType,
      'target_account_name': targetAccountName,
      'target_account_type': targetAccountType,
    };
  }
}
