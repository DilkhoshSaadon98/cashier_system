import 'package:cashier_system/data/sql/sqldb.dart';

class BuyingClass {
  SqlDb db = SqlDb();

  Future<dynamic> getItemsData() async {
    var response = await db.getAllData('purchaseView');
    return response;
  }

  Future<dynamic> searchItemsData({
    String? itemsNo,
    String? itemsName,
    String? itemsSelling,
    String? itemsBuying,
    String? itemsDate,
    String? supplierName,
    String? groupBy,
  }) async {
    String sql = "";
    List<String> conditions = [];
    if (itemsNo != null) {
      conditions.add("( purchase_id = '$itemsNo' )");
    }
    if (itemsName != null) {
      conditions.add("( items_name LIKE '%$itemsName%' )");
    }
    if (itemsSelling != null) {
      conditions.add("( selling_price = '%$itemsName%' )");
    }
    if (itemsBuying != null) {
      conditions.add("( purchase_price = '%$itemsName%' )");
    }
    if (itemsDate != null) {
      conditions.add("( purchase_date LIKE '%$itemsDate%')");
    }
    if (supplierName != null) {
      conditions.add("( users_name LIKE '%$itemsDate%' )");
    }

    if (conditions.isNotEmpty) {
      sql += conditions.join(" AND ");
    } else {
      sql = "1 == 1";
    }
    var response = await db.getAllData('purchaseView',
        where: "$sql GROUP BY purchase_number");
    return response;
  }
}
