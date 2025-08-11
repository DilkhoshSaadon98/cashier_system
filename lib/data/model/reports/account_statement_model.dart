class AccountStatementModel {
  final int voucherNo;
  final String dateTime;
  final String type;
  final String note;
  final double debit;
  final double credit;
  final int accountId;
  final String accountName;

  AccountStatementModel({
    required this.voucherNo,
    required this.dateTime,
    required this.type,
    required this.note,
    required this.debit,
    required this.credit,
    required this.accountId,
    required this.accountName,
  });

  factory AccountStatementModel.fromJson(Map<String, dynamic> json) {
    return AccountStatementModel(
      voucherNo: json['voucher_no'],
      dateTime: json['transaction_date'],
      type: json['transaction_type'],
      note: json['note'] ?? '',
      debit: (json['debit'] as num).toDouble(),
      credit: (json['credit'] as num).toDouble(),
      accountId: json['account_id'],
      accountName: json['account_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'voucher_no': voucherNo,
      'date_time': dateTime,
      'type': type,
      'note': note,
      'debit': debit,
      'credit': credit,
      'account_id': accountId,
      'account_name': accountName,
    };
  }
}
