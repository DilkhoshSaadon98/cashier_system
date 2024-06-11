class BoxModel {
  int? boxId;
  int? boxAmount;
  String? boxCreateDate;
  String? boxTable;
  int? boxTableRowId;

  BoxModel({
    this.boxId,
    this.boxAmount,
    this.boxCreateDate,
    this.boxTable,
    this.boxTableRowId,
  });

  BoxModel.fromJson(Map<String, dynamic> json) {
    boxId = json['invoice_id'];
    boxAmount = json['invoice_price'];
    boxCreateDate = json['invoice_createdate'];
    boxTable = json['invoice_source_table'];
    boxTableRowId = json['invoice_row_id'];
  }
}
