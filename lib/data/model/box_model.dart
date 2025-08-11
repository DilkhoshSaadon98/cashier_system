class BoxModel {
  int? boxId;
  double? boxAmount;
  String? boxCreateDate;
  String? usersName;
  String? boxTable;
  int? boxTableRowId;
  String? usersAddress;
  String? usersPhone;

  BoxModel({
    this.boxId,
    this.boxAmount,
    this.boxCreateDate,
    this.usersName,
    this.boxTable,
    this.boxTableRowId,
    this.usersAddress,
    this.usersPhone,
  });

  BoxModel.fromJson(Map<String, dynamic> json) {
    boxId = json['invoice_id'];
    boxAmount = json['invoice_price'];
    usersName = json['users_name'];
    boxCreateDate = json['invoice_createdate'];
    boxTable = json['invoice_source_table'];
    boxTableRowId = json['invoice_row_id'];
    usersAddress = json['users_address'];
    usersPhone = json['users_phone'];
  }
}
