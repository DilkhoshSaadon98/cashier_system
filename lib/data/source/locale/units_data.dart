import 'package:cashier_system/core/localization/text_routes.dart';

final Map<String, Unit> unitsMap = {
  'pcs': Unit(name: TextRoutes.pcs, baseUnit: 'pcs', conversionFactor: 1),
  'box': Unit(name: TextRoutes.box, baseUnit: 'pcs', conversionFactor: 10),
  'g': Unit(name: TextRoutes.grams, baseUnit: 'kg', conversionFactor: 0.001),
  'kg': Unit(name: TextRoutes.kilograms, baseUnit: 'kg', conversionFactor: 1),
  'ml': Unit(
      name: TextRoutes.milliliters, baseUnit: 'l', conversionFactor: 0.001),
  'l': Unit(name: TextRoutes.liters, baseUnit: 'l', conversionFactor: 1),
};

class Unit {
  final String id;
  final String baseUnit;
  final double conversionFactor;
  final String name;

  Unit({
    required this.name,
    required this.baseUnit,
    required this.conversionFactor,
    this.id = '',
  });
}
