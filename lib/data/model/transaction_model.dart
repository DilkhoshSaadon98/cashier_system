class TransactionModel {
  final int transactionId;
   String transactionNumber;
  final String transactionType;
  final String transactionDate;
  final double transactionAmount;
  final String? transactionNote;
  final double? transactionDiscount;

  final int sourceAccountId;
  final String sourceAccountName;
  final String sourceAccountType;

  final int targetAccountId;
  final String targetAccountName;
  final String targetAccountType;

  TransactionModel({
    required this.transactionId,
    required this.transactionNumber,
    required this.transactionType,
    required this.transactionDate,
    required this.transactionAmount,
    this.transactionNote,
    this.transactionDiscount,
    required this.sourceAccountId,
    required this.sourceAccountName,
    required this.sourceAccountType,
    required this.targetAccountId,
    required this.targetAccountName,
    required this.targetAccountType,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      transactionId: map['transaction_id'],
      transactionNumber: map['transaction_number']??"",
      transactionType: map['transaction_type'],
      transactionDate: map['transaction_date'],
      transactionAmount: map['transaction_amount'] != null
          ? double.tryParse(map['transaction_amount'].toString()) ?? 0.0
          : 0.0,
      transactionNote: map['transaction_note'],
      transactionDiscount: map['transaction_discount'] ?? 0.0,
      sourceAccountId: map['source_account_id:1'] ?? map['source_account_id'],
      sourceAccountName: map['source_account_name'],
      sourceAccountType: map['source_account_type'],
      targetAccountId: map['target_account_id:1'] ?? map['target_account_id'],
      targetAccountName: map['target_account_name'],
      targetAccountType: map['target_account_type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transaction_id': transactionId,
      'transaction_type': transactionType,
      'transaction_date': transactionDate,
      'transaction_amount': transactionAmount,
      'transaction_note': transactionNote,
      'transaction_discount': transactionDiscount,
      'source_account_id': sourceAccountId,
      'source_account_name': sourceAccountName,
      'source_account_type': sourceAccountType,
      'target_account_id': targetAccountId,
      'target_account_name': targetAccountName,
      'target_account_type': targetAccountType,
    };
  }
}
