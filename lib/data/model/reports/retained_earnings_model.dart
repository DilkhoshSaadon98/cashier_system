class RetainedEarningsModel {
  final int voucherNo;
  final String type;
  final String dateTime;
  final String note;
  final double amount;
  final double debit;
  final double credit;
  final int accountId;
  final String accountName;

  RetainedEarningsModel({
    required this.voucherNo,
    required this.type,
    required this.dateTime,
    required this.note,
    required this.amount,
    required this.debit,
    required this.credit,
    required this.accountId,
    required this.accountName,
  });

  factory RetainedEarningsModel.fromJson(Map<String, dynamic> json) {
    return RetainedEarningsModel(
      voucherNo: json['voucher_no'],
      type: json['type'],
      dateTime: json['date_time'],
      note: json['note'] ?? '',
      amount: (json['amount'] as num).toDouble(),
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
      'amount': amount,
      'debit': debit,
      'credit': credit,
      'account_id': accountId,
      'account_name': accountName,
    };
  }
}
