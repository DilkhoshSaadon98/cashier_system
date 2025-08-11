class JournalVoucherModel {
  final int voucherId;
  final String voucherNumber;
  final String voucherDate;
  final String voucherNote;
  final List<VoucherLineModel> lines;
  final double totalDebit;
  final double totalCredit;

  JournalVoucherModel({
    required this.voucherId,
    required this.voucherNumber,
    required this.voucherDate,
    required this.voucherNote,
    required this.lines,
    required this.totalDebit,
    required this.totalCredit,
  });

  factory JournalVoucherModel.fromJson(Map<String, dynamic> json) {
    return JournalVoucherModel(
      voucherId: json['voucher_id'],
      voucherNumber: json['voucher_number'],
      voucherDate: json['voucher_date'],
      voucherNote: json['voucher_note'],
      totalDebit: json['total_debit']?.toDouble() ?? 0.0,
      totalCredit: json['total_credit']?.toDouble() ?? 0.0,
      lines: (json['lines'] as List<dynamic>?)
              ?.map((e) => VoucherLineModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class VoucherLineModel {
  final int accountId;
  final String accountName;
  final double debit;
  final double credit;
  final String? note;

  VoucherLineModel({
    required this.accountId,
    required this.accountName,
    required this.debit,
    required this.credit,
    this.note,
  });

  factory VoucherLineModel.fromJson(Map<String, dynamic> json) {
    return VoucherLineModel(
      accountId: json['account_id'],
      accountName: json['account_name'],
      debit: json['debit']?.toDouble() ?? 0.0,
      credit: json['credit']?.toDouble() ?? 0.0,
      note: json['note'],
    );
  }
}
class VoucherLineDetailsModel {
  final int lineId;
  final int voucherId;
  final String voucherNumber;
  final String voucherDate;
  final String? voucherNote;
  final int accountId;
  final String accountName;
  final String accountType;
  final double debit;
  final double credit;
  final String? lineNote;

  VoucherLineDetailsModel({
    required this.lineId,
    required this.voucherId,
    required this.voucherNumber,
    required this.voucherDate,
    this.voucherNote,
    required this.accountId,
    required this.accountName,
    required this.accountType,
    required this.debit,
    required this.credit,
    this.lineNote,
  });

  factory VoucherLineDetailsModel.fromMap(Map<String, dynamic> map) {
    return VoucherLineDetailsModel(
      lineId: map['line_id'],
      voucherId: map['voucher_id'],
      voucherNumber: map['voucher_number'],
      voucherDate: map['voucher_date'],
      voucherNote: map['voucher_note'],
      accountId: map['account_id'],
      accountName: map['account_name'],
      accountType: map['account_type'],
      debit: (map['debit'] ?? 0.0).toDouble(),
      credit: (map['credit'] ?? 0.0).toDouble(),
      lineNote: map['line_note'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'line_id': lineId,
      'voucher_id': voucherId,
      'voucher_number': voucherNumber,
      'voucher_date': voucherDate,
      'voucher_note': voucherNote,
      'account_id': accountId,
      'account_name': accountName,
      'account_type': accountType,
      'debit': debit,
      'credit': credit,
      'line_note': lineNote,
    };
  }
}
