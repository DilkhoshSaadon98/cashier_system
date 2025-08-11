class CreditorDebtorDetailsModel {
  int? creditorDebtorId;
  double? creditorDebtorAmount;
  String? creditorDebtorCreateDate;
  String? creditorDebtorTable;
  String? creditorDebtorAccount;
  int? creditorDebtorTableRowId;

  CreditorDebtorDetailsModel({
    this.creditorDebtorId,
    this.creditorDebtorAmount,
    this.creditorDebtorCreateDate,
    this.creditorDebtorTable,
    this.creditorDebtorAccount,
    this.creditorDebtorTableRowId,
  });

  CreditorDebtorDetailsModel.fromJson(Map<String, dynamic> json) {
    creditorDebtorId = json['invoice_id'];
    creditorDebtorAmount = json['invoice_price'];
    creditorDebtorCreateDate = json['invoice_createdate'];
    creditorDebtorTable = json['invoice_source_table'];
    creditorDebtorAccount = json['invoice_account'];
    creditorDebtorTableRowId = json['invoice_row_id'];
  }
}
