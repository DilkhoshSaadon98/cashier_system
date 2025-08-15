import 'package:cashier_system/data/sql/sqldb.dart';

class UnitsClass {
  SqlDb db = SqlDb();
  String tableName = 'tbl_units';
  String tableUnitConversationName = 'tbl_unit_conversions';

Future<int>  addUnitsData(Map<String, dynamic> data) async {
    int response = await db.insertData(tableName, data);
    return response;
  }
Future<int>  updateUnitsData(Map<String, dynamic> data,int unitId) async {
    int response = await db.updateData(tableName, data,"unit_id = $unitId");
    return response;
  }

Future<int>  addUnitConversionsData(Map<String, dynamic> data) async {
    int response = await db.insertData(tableUnitConversationName, data);
    return response;
  }
}
