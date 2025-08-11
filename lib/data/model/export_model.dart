class ExportModel {
  int? exportId;
  int? exportCashId;
  String? exportAccount;
  double? exportAmount;
  String? exportNote;
  int? exportSupplier;
  String? exportCreateDate;
  int? usersId;
  String? usersName;
  String? usersEmail;
  String? usersPhone;
  String? usersAddress;
  String? usersCreateDate;
  ExportModel({
    this.exportId,
    this.exportCashId,
    this.exportAccount,
    this.exportAmount,
    this.exportNote,
    this.exportCreateDate,
    this.exportSupplier,
    this.usersId,
    this.usersName,
    this.usersEmail,
    this.usersPhone,
    this.usersAddress,
    this.usersCreateDate,
  });

  ExportModel.fromJson(Map<String, dynamic> json) {
    exportId = json['export_id'];
    exportCashId = json['export_cash_id'];
    exportAccount = json['export_account'];
    exportAmount = json['export_amount'];
    exportNote = json['export_note'];
    exportCreateDate = json['export_create_date'];
    exportSupplier = json['export_supplier_id'];
    usersId = json['users_id'];
    usersName = json['users_name'];
    usersEmail = json['users_email'];
    usersPhone = json['users_phone'];
    usersAddress = json['users_address'];
    usersCreateDate = json['users_createdate'];
    usersAddress = json['users_address'];
    usersPhone = json['users_phone'];
  }
}
