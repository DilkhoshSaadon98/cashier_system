class TrialBalanceModel {
  final int accountId;
  final String accountName;
  final double debit;
  final double credit;
  final double balance;

  TrialBalanceModel({
    required this.accountId,
    required this.accountName,
    required this.debit,
    required this.credit,
    required this.balance,
  });

  factory TrialBalanceModel.fromJson(Map<String, dynamic> json) {
    return TrialBalanceModel(
      accountId: json['voucher_no'],
      accountName: json['source_account_name'],
      debit: (json['total_debit'] as num).toDouble(),
      credit: (json['total_credit'] as num).toDouble(),
      balance: (json['balance'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_id': accountId,
      'account_name': accountName,
      'debit': debit,
      'credit': credit,
      'balance': balance,
    };
  }
}
