class UnitModel {
  final int? unitId;
  final String? unitBaseName;
  final double? factor;
  final String? unitCreateDate;

  UnitModel({
   this.unitId,
   this.unitBaseName,
   this.factor,
   this.unitCreateDate,
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
