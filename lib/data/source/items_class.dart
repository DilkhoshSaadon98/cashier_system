import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/core/class/sqldb.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ItemsClass {
  SqlDb db = SqlDb();

  Future<dynamic> searchItemsData({
    String? itemsNo,
    String? itemsBarcode,
    String? itemsName,
    String? itemsCount,
    String? itemsSelling,
    int? itemsCategories,
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

    DateFormat formatter = DateFormat('yyyy-MM-dd');
    if (itemsNo != null) {
      conditions.add("(item_id = $itemsNo)");
    }
    if (itemsBarcode != null) {
      conditions.add("( item_barcode = $itemsBarcode)");
    }
    if (itemsName != null) {
      conditions.add(
          "(item_name LIKE '%$itemsName%' OR item_description LIKE '%$itemsName%')");
    }
    //? Production Date:
    if (productionFrom != null) {
      if (productionTo != null) {
        DateTime startDate = formatter.parse(productionFrom.trim());
        DateTime endDate = formatter.parse(productionTo.trim());
        conditions.add(
            "( item_production_date BETWEEN '${formatter.format(startDate)}' AND '${formatter.format(endDate)}' )");
      } else {
        DateTime startDate = formatter.parse(productionFrom.trim());
        conditions
            .add("( item_production_date = '${formatter.format(startDate)}' )");
      }
    }
    //? Expiry Date:
    if (expiryFrom != null) {
      if (expiryTo != null) {
        DateTime startDate = formatter.parse(expiryFrom.trim());
        DateTime endDate = formatter.parse(expiryTo.trim());
        conditions.add(
            "( item_expiry_date BETWEEN '${formatter.format(startDate)}' AND '${formatter.format(endDate)}' )");
      } else {
        DateTime startDate = formatter.parse(expiryFrom.trim());
        conditions
            .add("( item_expiry_date = '${formatter.format(startDate)}' )");
      }
    }
    //? Insert Date:
    if (createFrom != null) {
      if (createTo != null) {
        DateTime startDate = formatter.parse(createFrom.trim());
        DateTime endDate = formatter.parse(createTo.trim());
        conditions.add(
            "( item_create_date BETWEEN '${formatter.format(startDate)}' AND '${formatter.format(endDate)}' )");
      } else {
        DateTime startDate = formatter.parse(createFrom.trim());
        conditions
            .add("( item_create_date = '${formatter.format(startDate)}' )");
      }
    }

    if (itemsCount != null) {
      conditions.add("item_count = '$itemsCount'");
    }
    if (itemsSelling != null) {
      conditions.add("item_selling_price = '$itemsSelling'");
    }

    if (itemsCategories != null) {
      conditions.add("item_category_id = $itemsCategories");
    }

    if (conditions.isNotEmpty) {
      sql += conditions.join(" AND ");
    } else {
      sql = "1 = 1";
    }

    var response = await db.getData(
        'SELECT * FROM view_items WHERE $sql ORDER BY $sortField ${sortOrder.toUpperCase()} LIMIT $limit OFFSET $offset');

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

  Future<Map<String, String>> deleteItems(List<int> ids) async {
    Map<String, String> result = {};

    for (var id in ids) {
      String? usedIn;

      final usedCart = await db
          .getData("SELECT 1 FROM tbl_cart WHERE cart_items_id = $id LIMIT 1");
      if (usedCart.isNotEmpty) usedIn = TextRoutes.itemLinkedWithSaleInvoices;

      final usedInventory = await db.getData(
          "SELECT 1 FROM tbl_inventory_movements WHERE item_id = $id LIMIT 1");
      if (usedInventory.isNotEmpty && usedIn == null) {
        usedIn = TextRoutes.itemLinkedWithSaleInvoices;
      }

      final usedInvoice = await db.getData(
          "SELECT 1 FROM tbl_invoice_items WHERE invoice_item_id = $id LIMIT 1");
      if (usedInvoice.isNotEmpty && usedIn == null) {
        usedIn = TextRoutes.itemLinkedWithSaleInvoices;
      }

      final usedPurchase = await db.getData(
          "SELECT 1 FROM tbl_purchase WHERE purchase_items_id = $id LIMIT 1");
      if (usedPurchase.isNotEmpty && usedIn == null) {
        usedIn = TextRoutes.itemLinkedWithPurchaseInvoices;
      }
      ;

      if (usedIn == null) {
        // تحقق من tbl_units_price
        final usedUnits = await db.getData(
            "SELECT 1 FROM tbl_units_price WHERE item_id = $id LIMIT 1");
        if (usedUnits.isNotEmpty) {
          await db.deleteData("tbl_units_price", "item_id = $id");
        }

        final res = await db.deleteData("tbl_items", "item_id = $id");
        if (res > 0) {
          result[id.toString()] = TextRoutes.success;
        } else {
          result[id.toString()] = TextRoutes.fail;
        }
      } else {
        result[id.toString()] = '${TextRoutes.failDeleteData.tr}-$usedIn';
      }
    }

    return result;
  }
}
