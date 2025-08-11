class UnitModel {
  final int unitId;
  final String unitName;
  final int convertValue;
  final String unitDesc;
  final String unitCreateDate;

  UnitModel({
    required this.unitId,
    required this.unitName,
    required this.convertValue,
    required this.unitDesc,
    required this.unitCreateDate,
  });

  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(
      unitId: json['unit_id'],
      unitName: json['unit_name'],
      convertValue: json['conversion_to_base'],
      unitDesc: json['unit_desc'],
      unitCreateDate: json['unite_createdate'],
    );
  }
}
