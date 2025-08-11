class CustomerLedgerModel {
  final int voucherNo;
  final String type;
  final String dateTime;
  final String note;
  final double transactionAmount;
  final double debit;
  final double credit;
  final int accountId;
  final String accountName;

  CustomerLedgerModel({
    required this.voucherNo,
    required this.type,
    required this.dateTime,
    required this.note,
    required this.transactionAmount,
    required this.debit,
    required this.credit,
    required this.accountId,
    required this.accountName,
  });

  factory CustomerLedgerModel.fromJson(Map<String, dynamic> json) {
    return CustomerLedgerModel(
      voucherNo: json['voucher_no'],
      type: json['transaction_type'],
      dateTime: json['transaction_date'],
      note: json['note'] ?? '',
      transactionAmount: (json['transaction_amount'] as num).toDouble(),
      debit: (json['debit'] as num).toDouble(),
      credit: (json['credit'] as num).toDouble(),
      accountId: json['account_id'],
      accountName: json['account_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'voucher_no': voucherNo,
      'type': type,
      'date_time': dateTime,
      'note': note,
      'transaction_amount': transactionAmount,
      'debit': debit,
      'credit': credit,
      'account_id': accountId,
      'account_name': accountName,
    };
  }
}
