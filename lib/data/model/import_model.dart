class ImportModel {
  int? importId;
  String? importAccount;
  int? importAmount;
  String? importNote;
  int? importSupplier;
  String? importCreateDate;
  int? usersId;
  String? usersName;
  String? usersEmail;
  String? usersPhone;
  String? usersAddress;
  String? usersRole;
  String? usersCreateDate;

  ImportModel(
      {this.importId,
      this.importAccount,
      this.importAmount,
      this.importNote,
      this.importCreateDate,
      this.importSupplier,
      this.usersId,
      this.usersName,
      this.usersEmail,
      this.usersPhone,
      this.usersAddress,
      this.usersRole,
      this.usersCreateDate});

  ImportModel.fromJson(Map<String, dynamic> json) {
    importId = json['import_id'];
    importAccount = json['import_account'];
    importAmount = json['import_amount'];
    importNote = json['import_note'];
    importCreateDate = json['import_create_date'];
    importSupplier = json['import_supplier_id'];
    usersId = json['users_id'];
    usersName = json['users_name'];
    usersEmail = json['users_email'];
    usersPhone = json['users_phone'];
    usersAddress = json['users_address'];
    usersRole = json['users_role'];
    usersCreateDate = json['users_createdate'];
  }
}
