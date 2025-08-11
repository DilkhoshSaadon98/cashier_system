class UsersModel {
  final int usersId;
  final String usersName;
  final int accountId;
  final String usersEmail;
  final String usersPhone;
  final String usersPhone2;
  final String usersAddress;
  final String usersCreateDate;
  final String usersNote;
  final String accountName;
  final String accountCode;
  final String accountType;

  UsersModel({
    required this.usersId,
    required this.usersName,
    required this.accountId,
    required this.usersEmail,
    required this.usersPhone,
    required this.usersPhone2,
    required this.usersAddress,
    required this.usersCreateDate,
    required this.usersNote,
    required this.accountName,
    required this.accountCode,
    required this.accountType,
  });

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
      usersId: json['id'],
      usersName: json['name'] ?? '',
      accountId: json['account_id'] ?? 0,
      usersEmail: json['email'] ?? '',
      usersPhone: json['phone'] ?? '',
      usersPhone2: json['phone2'] ?? '',
      usersAddress: json['address'] ?? '',
      usersCreateDate: json['date'] ?? '',
      usersNote: json['note'] ?? '',
      accountName: json['account_name'] ?? '',
      accountCode: json['account_code'] ?? '',
      accountType: json['account_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': usersId,
      'name': usersName,
      'account_id': accountId,
      'email': usersEmail,
      'phone': usersPhone,
      'phone2': usersPhone2,
      'address': usersAddress,
      'date': usersCreateDate,
      'note': usersNote,
      'account_name': accountName,
      'account_code': accountCode,
      'account_type': accountType,
    };
  }
}
