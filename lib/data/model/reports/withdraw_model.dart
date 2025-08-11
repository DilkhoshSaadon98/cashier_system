class WithdrawModel {
  final int voucherNo;
  final String type;
  final String dateTime;
  final String note;
  final double amount;
  final double debit;
  final double credit;
  final int accountId;
  final String accountName;

  WithdrawModel({
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

  factory WithdrawModel.fromJson(Map<String, dynamic> json) {
    return WithdrawModel(
      voucherNo: json['voucher_no'],
      type: json['transaction_type'],
      dateTime: json['transaction_date'],
      note: json['note'],
      amount: json['amount'].toDouble(),
      debit: json['debit'].toDouble(),
      credit: json['credit'].toDouble(),
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
