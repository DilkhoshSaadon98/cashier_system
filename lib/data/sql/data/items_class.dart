import 'package:cashier_system/data/sql/sqldb.dart';

class ItemsClass {
  SqlDb db = SqlDb();

  Future<dynamic> getItemsData() async {
    var response = await db.getAllData('itemsView');
    return response;
  }

  Future<dynamic> searchItemsData({
    String? itemsNo,
    String? itemsName,
    String? itemsCount,
    String? itemsSelling,
    String? itemsType,
    String? itemsCategories,
  }) async {
    String sql = "";
    List<String> conditions = [];
    if (itemsNo != null) {
      conditions
          .add("( items_id LIKE '%$itemsNo%' OR items_barcode LIKE '%$itemsNo%' )");
    }
    if (itemsName != null) {
      conditions.add(
          "( items_name LIKE '%$itemsName%' OR items_desc LIKE '%$itemsName%' )");
    }
    if (itemsCount != null) {
      conditions.add("items_count = '$itemsCount'");
    }
    if (itemsSelling != null) {
      conditions.add("items_selling = '$itemsSelling'");
    }
    if (itemsType != null) {
      conditions.add("type_name LIKE '%$itemsType%'");
    }
    if (itemsCategories != null) {
      conditions.add("categories_name LIKE '%$itemsCategories%'");
    }
    if (conditions.isNotEmpty) {
      sql += conditions.join(" AND ");
    } else {
      sql = "1 == 1";
    }
    var response = await db.getAllData('itemsView', where: sql);
    return response;
  }
}
