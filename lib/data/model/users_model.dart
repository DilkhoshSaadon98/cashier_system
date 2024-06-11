class UsersModel {
  int? usersId;
  String? usersName;
  String? usersEmail;
  String? usersPhone;
  String? usersPhone2;
  String? usersNote;
  String? usersAddress;
  String? usersRole;
  String? usersCreateDate;

  UsersModel(
      {this.usersId,
      this.usersName,
      this.usersEmail,
      this.usersPhone,
      this.usersPhone2,
      this.usersNote,
      this.usersAddress,
      this.usersRole,
      this.usersCreateDate});

  UsersModel.fromJson(Map<String, dynamic> json) {
    usersId = json['users_id'];
    usersName = json['users_name'];
    usersEmail = json['users_email'];
    usersPhone = json['users_phone'];
    usersPhone2 = json['users_phone2'];
    usersNote = json['users_note'];
    usersAddress = json['users_address'];
    usersRole = json['users_role'];
    usersCreateDate = json['users_createdate'];
  }
}