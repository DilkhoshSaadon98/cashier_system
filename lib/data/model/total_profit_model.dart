class TotalProfitModel {
  int? totalProfitId;
  int? totalProfitAmount;
  String? totalProfitCreateDate;
  String? totalProfitTable;
  int? totalProfitRowId;

  TotalProfitModel({
    this.totalProfitId,
    this.totalProfitAmount,
    this.totalProfitCreateDate,
    this.totalProfitTable,
    this.totalProfitRowId,
  });

  TotalProfitModel.fromJson(Map<String, dynamic> json) {
    totalProfitId = json['invoice_id'];
    totalProfitAmount = json['invoice_price'];
    totalProfitCreateDate = json['invoice_createdate'];
    totalProfitTable = json['invoice_source_table'];
    totalProfitRowId = json['invoice_row_id'];
  }
}
