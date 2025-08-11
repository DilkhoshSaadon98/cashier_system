class AccountModel {
  int? accountId;
  String? accountName;
  String? accountType;
  String? accountCode;
  int? accountParentId;
  double? accountInitialBalance;
  double? totalDebits; // NEW
  double? totalCredits; // NEW
  double? accountBalance; // NEW (calculated balance from SQL)
  String? accountNote;
  String? createDate;
  String? updateDate;
  bool isExpanded;
  List<AccountModel> accountChildren;

  AccountModel({
    this.accountId,
    this.accountName,
    this.accountType,
    this.accountCode,
    this.accountParentId,
    this.accountInitialBalance,
    this.totalDebits,
    this.totalCredits,
    this.accountBalance,
    this.accountNote,
    this.createDate,
    this.updateDate,
    this.isExpanded = false,
    List<AccountModel>? accountChildren,
  }) : accountChildren = accountChildren ?? [];

  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
      accountId: map['account_id'],
      accountCode: map['account_code'] ?? '',
      accountName: map['account_name'],
      accountType: map['account_type'] ?? '',
      accountParentId: map['account_parent_id'],
      accountInitialBalance:
          (map['account_initial_balance'] as num?)?.toDouble() ?? 0.0,
      totalDebits: (map['total_debits'] as num?)?.toDouble() ?? 0.0,
      totalCredits: (map['total_credits'] as num?)?.toDouble() ?? 0.0,
      accountBalance: (map['balance'] as num?)?.toDouble() ?? 0.0,
      accountNote: map['account_note'],
      createDate: map['account_created_at'],
      updateDate: map['account_updated_at'] ?? '',
    );
  }

  static AccountModel empty() {
    return AccountModel(
      accountId: 0,
      accountName: '',
      accountType: '',
      accountCode: '',
    );
  }
}
