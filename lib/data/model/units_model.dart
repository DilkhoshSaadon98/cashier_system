class UnitModel {
  final int unitId;
  final String unitBaseName;
  final double factor;
  final String unitCreateDate;

  UnitModel({
    required this.unitId,
    required this.unitBaseName,
    required this.factor,
    required this.unitCreateDate,
  });

  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(
      unitId: json['unit_id'],
      unitBaseName: json['base_unit_name'],
      factor: json['factor'],
      unitCreateDate: json['created_at'],
    );
  }
}
