class ImportModel {
  int? importId;
  String? importAccount;
  double? importAmount;
  String? importNote;
  int? importSupplier;
  String? importCreateDate;
  int? usersId;
  String? usersName;
  String? usersAddress;
  String? usersPhone;

  ImportModel(
      {this.importId,
      this.importAccount,
      this.importAmount,
      this.importNote,
      this.importCreateDate,
      this.importSupplier,
      this.usersId,
      this.usersName,this.usersAddress,this.usersPhone});

  ImportModel.fromJson(Map<String, dynamic> json) {
    importId = json['import_id'];
    importAccount = json['import_account'];
    importAmount = json['import_amount'];
    importNote = json['import_note'];
    importCreateDate = json['import_create_date'];
    importSupplier = json['import_supplier_id'];
    usersId = json['users_id'];
    usersName = json['users_name'];
    usersAddress = json['users_address'];
    usersPhone = json['users_phone'];
  }
}
