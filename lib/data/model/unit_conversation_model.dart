class UnitConversationModel {
  final int conversionId;
  final int unitId;
  final String largerUnitName;
  final String largerUnitLabel;
  final double conversionFactor;

  UnitConversationModel({
    required this.conversionId,
    required this.unitId,
    required this.largerUnitName,
    required this.largerUnitLabel,
    required this.conversionFactor,
  });

  factory UnitConversationModel.fromJson(Map<String, dynamic> json) {
    return UnitConversationModel(
      conversionId: json['conversion_id'] ?? 0,
      unitId: json['unit_id'] ?? 0,
      largerUnitName: json['larger_unit_name'] ?? '',
      largerUnitLabel: json['larger_unit_label'] ?? '',
      conversionFactor: (json['conversion_factor'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversion_id': conversionId,
      'unit_id': unitId,
      'larger_unit_name': largerUnitName,
      'larger_unit_label': largerUnitLabel,
      'conversion_factor': conversionFactor,
    };
  }
}
