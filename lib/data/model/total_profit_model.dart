class TotalProfitModel {
  int? totalProfitId;
  double? totalProfitAmount;
  String? totalProfitCreateDate;
  String? totalProfitTable;
  int? totalProfitRowId;
  String? usersName;
  String? usersAddress;
  String? usersPhone;

  TotalProfitModel({
    this.totalProfitId,
    this.totalProfitAmount,
    this.totalProfitCreateDate,
    this.totalProfitTable,
    this.usersName,
    this.totalProfitRowId,
    this.usersAddress,
    this.usersPhone,
  });

  TotalProfitModel.fromJson(Map<String, dynamic> json) {
    totalProfitId = json['invoice_id'];
    totalProfitAmount = json['invoice_price'];
    totalProfitCreateDate = json['invoice_createdate'];
    usersName = json['users_name'];
    totalProfitTable = json['invoice_source_table'];
    totalProfitRowId = json['invoice_row_id'];
    usersAddress = json['users_address'];
    usersPhone = json['users_phone'];
  }
}
