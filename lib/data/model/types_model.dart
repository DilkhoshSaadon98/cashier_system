class TypesModel {
  int? typesId;
  String? typesName;
  String? typesDesc;
  String? typesCreatedate;

  TypesModel(
      {this.typesId, this.typesName, this.typesDesc, this.typesCreatedate});

  TypesModel.fromJson(Map<String, dynamic> json) {
    typesId = json['type_id'];
    typesName = json['type_name'];
    typesDesc = json['types_desc'];
    typesCreatedate = json['types_createdate'];
  }
}
