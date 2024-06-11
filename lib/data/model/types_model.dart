class TypesModel {
  int? typesId;
  String? typesName;
  String? typesCreatedate;

  TypesModel({this.typesId, this.typesName, this.typesCreatedate});

  TypesModel.fromJson(Map<String, dynamic> json) {
    typesId = json['type_id'];
    typesName = json['type_name'];
    typesCreatedate = json['types_createdate'];
  }
}
