import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/class/sqldb.dart';

class ItemsClass {
  SqlDb db = SqlDb();

  Future<dynamic> searchItemsData({
    String? itemsNo,
    String? itemsBarcode,
    String? itemsName,
    String? itemsCount,
    String? itemsSelling,
    String? itemsType,
    String? itemsCategories,
    String? itemsDesc,
    String? productionFrom,
    String? productionTo,
    String? expiryFrom,
    String? expiryTo,
    String? createFrom,
    String? createTo,
    String? sortField,
    String sortOrder = 'ASC',
    int offset = 0,
    int limit = 50,
  }) async {
    String? sql = "";
    List<String> conditions = [];

    if (itemsNo != null) {
      conditions.add("(item_id = $itemsNo)");
    }
    if (itemsBarcode != null) {
      conditions.add("( item_barcode LIKE '%$itemsBarcode%')");
    }
    if (itemsName != null) {
      conditions.add(
          "(item_name LIKE '%$itemsName%' OR item_description LIKE '%$itemsName%')");
    }
    if (productionFrom != null) {
      conditions.add("production_date >= '$productionFrom'");
    }
    if (productionTo != null) {
      conditions.add("production_date <= '$productionTo'");
    }

    if (expiryFrom != null) {
      conditions.add("expiry_date >= '$expiryFrom'");
    }
    if (expiryTo != null) {
      conditions.add("expiry_date <= '$expiryTo'");
    }

    if (createFrom != null) {
      conditions.add("item_create_date >= '$createFrom'");
    }
    if (createTo != null) {
      conditions.add("item_create_date <= '$createTo'");
    }
    if (itemsCount != null) {
      conditions.add("item_count = '$itemsCount'");
    }
    if (itemsSelling != null) {
      conditions.add("item_selling_price = '$itemsSelling'");
    }
    if (itemsType != null) {
      conditions.add("item_type LIKE '%$itemsType%'");
    }
    if (itemsCategories != null) {
      if (itemsCategories == TextRoutes.unknown) {
        conditions
            .add("(categories_name IS NULL OR categories_name = 'Unknown')");
      } else {
        conditions.add("categories_name LIKE '%$itemsCategories%'");
      }
    }
    if (itemsDesc != null) {
      conditions.add("item_description LIKE '%$itemsDesc%'");
    }

    if (conditions.isNotEmpty) {
      sql += conditions.join(" AND ");
    } else {
      sql = "1 = 1";
    }

    String orderBy = '';
    if (sortField != null && sortField.isNotEmpty) {
      final allowedSortFields = [
        'item_id',
        'item_name',
        'item_count',
        'item_selling_price',
        'production_date',
        'expiry_date',
        'item_create_date',
      ];

      if (allowedSortFields.contains(sortField)) {
        final sanitizedSortOrder =
            sortOrder.toUpperCase() == 'DESC' ? 'DESC' : 'ASC';
        orderBy = " ORDER BY $sortField $sanitizedSortOrder";
      }
    }

    var response = await db.getData(
        'SELECT * FROM view_items WHERE $sql $orderBy LIMIT $limit OFFSET $offset');

    List<dynamic> totalItemsData = await getTotalItemsPrice(sql);
    double totalItemsPrice = totalItemsData[0];
    int totalItemsCount = totalItemsData[1];

    return {
      "status": "success",
      "total_items": totalItemsCount,
      "total_selling_price": totalItemsPrice,
      "data": response,
    };
  }

  //? Get Total Items Price:
  Future<List<dynamic>> getTotalItemsPrice(String sql) async {
    try {
      var result = await db.getData(
        '''
      SELECT 
        SUM(CAST(item_selling_price * item_count AS REAL)) AS total_items_price,
        COUNT(item_id) AS total_items_count
      FROM 
        itemsView
        WHERE $sql
      ''',
      );

      if (result != null && result.isNotEmpty) {
        double totalItemsPrice = result[0]['total_items_price'] ?? 0.0;
        int totalItemsCount = result[0]['total_items_count'] ?? 0;

        return [totalItemsPrice, totalItemsCount];
      } else {
        return [0.0, 0];
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          message: "Error fetching total items price");
      return [0.0, 0];
    }
  }
}
