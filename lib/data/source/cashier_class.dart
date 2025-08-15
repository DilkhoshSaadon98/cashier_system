import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/data/sql/sqldb.dart';

class CashierClass {
  final SqlDb db = SqlDb();

  Future<Map<String, dynamic>> processCartData(String cartNumber) async {
    try {
      //? Update cart statuses
      await updateCartStatus(cartNumber);

      //? Get total cart price
      int totalCartPrice = await getTotalCartPrice(cartNumber);

      //? Get pending carts count
      int totalPendingCart = await getPendingCartsCount();

      //? Get pended carts
      List<int> totalPendedCarts = await getPendedCarts();

      // Get carts numbers
      List<int> totalCartsNumbers = await getCartsNumbers();

      //? Get items numbers for each cart
      int totalItemsNumbers = await getItemsNumbers(cartNumber);

      //? Get total cart cost
      int totalCartCost = await getTotalCartCost(cartNumber);

      //? Get cart data
      var cartData = await getCartData(cartNumber);

      //? Construct response
      var response = {
        "status": "success",
        "total_cart_price": totalCartPrice,
        "total_pending_cart": totalPendingCart,
        "pended_carts": totalPendedCarts,
        "carts_number": totalCartsNumbers,
        "cart_items_count": totalItemsNumbers,
        "total_cart_cost": totalCartCost,
        "data_cart": cartData,
      };

      return response;
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error processing cart data");
      return {"status": "error", "message": e.toString()};
    }
  }

  //? Set Entire Carts Status to review and set others to pending (that cart number not equal 0 => Done):
  Future<void> updateCartStatus(String cartNumber) async {
    try {
      await db.updateData(
        'tbl_cart',
        {'cart_status': 'review'},
        'cart_number = $cartNumber',
      );

      await db.updateData(
        'tbl_cart',
        {'cart_status': 'pending'},
        'cart_number <> $cartNumber AND cart_number <> 0',
      );
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error updating cart status");
    }
  }

  //? Get Total Cart Price:
  Future<int> getTotalCartPrice(String cartNumber) async {
    try {
      var result = await db.getData(
        '''
        SELECT 
        CAST(
            (
               SUM(item_selling_price * cart_items_count)
                - IFNULL(cart_discount, 0)
                + IFNULL(cart_tax, 0)
            ) AS INTEGER
        ) AS total_cart_price 
        FROM 
            view_cart  
        WHERE 
            cart_number = $cartNumber
            AND cart_item_gift = 0
      ''',
      );

      if (result != null && result.isNotEmpty) {
        return result[0]['total_cart_price'] ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error fetching total cart price");
      return 0;
    }
  }

  //? Get Total Cart Cost:
  Future<int> getTotalCartCost(String cartNumber) async {
    try {
      var result = await db.getData(
        '''
        SELECT 
        CAST(
            (
               SUM(item_cost_price * cart_items_count) 
            ) AS INTEGER
        ) AS total_cart_cost 
        FROM 
            view_cart  
        WHERE 
            cart_number = $cartNumber
      ''',
      );

      if (result != null && result.isNotEmpty) {
        return result[0]['total_cart_cost'] ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error fetching total cart cost");
      return 0;
    }
  }

  //? Counting Pending Carts:
  Future<int> getPendingCartsCount() async {
    try {
      var result = await db.getData('''
        SELECT COUNT(DISTINCT cart_number) as pending_cart 
        FROM tbl_cart 
        WHERE cart_status = 'pending'
      ''');

      if (result != null && result.isNotEmpty) {
        return result[0]['pending_cart'] ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error fetching pending carts count");
      return 0;
    }
  }

  //? Get Pending Carts;
  Future<List<int>> getPendedCarts() async {
    try {
      var result = await db.getData('''
        SELECT DISTINCT cart_number 
        FROM tbl_cart 
        WHERE (cart_status != 'review' AND cart_status != 'done') 
        ORDER BY cart_number ASC
      ''');

      return result.map<int>((e) => e['cart_number'] as int).toList();
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error fetching pended carts");
      return [];
    }
  }

  //? Get Total Cart Numbers:
  Future<List<int>> getCartsNumbers() async {
    try {
      var result = await db.getData('''
        SELECT DISTINCT cart_number 
        FROM tbl_cart 
        WHERE cart_number <> 0 
        ORDER BY cart_number ASC
      ''');

      return result.map<int>((e) => e['cart_number'] as int).toList();
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error fetching carts numbers");
      return [];
    }
  }

  //? Get Items Numbers From Selected Cart:
  Future<int> getItemsNumbers(String cartNumber) async {
    try {
      var result = await db.getData(
        '''
        SELECT COUNT(DISTINCT cart_items_id) as cart_items_count 
        FROM tbl_cart 
        WHERE cart_number = $cartNumber
        ORDER BY cart_number ASC
      ''',
      );

      if (result != null && result.isNotEmpty) {
        return result[0]['cart_items_count'] ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error fetching items numbers");
      return 0;
    }
  }

  //? Get Selected Cart Data:
  Future<dynamic> getCartData(String cartNumber) async {
    try {
      return await db.getAllData(
        'view_cart',
        where: 'cart_number = $cartNumber',
      );
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error fetching cart data");
      return [];
    }
  }

  Future<int> getMaxInvoiceNumber(String cartNumber) async {
    try {
      var result = await db.getData(
          "SELECT COUNT(DISTINCT cart_items_id) as cart_items_count FROM tbl_cart WHERE cart_number = $cartNumber ORDER BY cart_number ASC");
      if (result != null &&
          result.isNotEmpty &&
          result[0]['cart_items_count'] != null) {
        return result[0]['cart_items_count'];
      } else {
        return 0;
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error getting max invoice number");
      return 0;
    }
  }

  //! Cashier Button Actions:
  //? Increase data items:
  Future<int?> increaseData(
      int itemCount, String cartNumber, int itemsId) async {
    try {
      final newCount = itemCount + 1;
      int cartNu = int.parse(cartNumber);
      final data = {"cart_items_count": newCount};

      final response = await db.updateData(
        'tbl_cart',
        data,
        'cart_number = $cartNu AND cart_items_id = $itemsId',
        json: false,
      );

      print('Rows updated: $response');
      return response;
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error increasing data");
      return null;
    }
  }

  //? Decrease data items:
  Future<dynamic> decreaseData(
      int itemCount, String cartNumber, int itemsId) async {
    try {
      int newCount = itemCount - 1;
      Map<String, dynamic> data = {"cart_items_count": newCount};
      return await db.updateData(
        'tbl_cart',
        data,
        'cart_number = $cartNumber AND cart_items_id = $itemsId',
      );
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error decreasing data");
      return null;
    }
  }

  //? Cart Items Discount:
  Future<dynamic> percentageDiscountingItems(
      String cartNumber, String discount, List<int> itemsId) async {
    try {
      Map<String, dynamic> data = {"cart_item_discount": discount};
      return await db.updateData(
        'tbl_cart',
        data,
        'cart_number = $cartNumber ',
      );
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error applying item discount");
      return null;
    }
  }

  //? Cart Discount:
  Future<dynamic> discountingCart(String cartNumber, String discount) async {
    try {
      Map<String, dynamic> data = {"cart_discount": discount};
      return await db.updateData(
        'tbl_cart',
        data,
        'cart_number = $cartNumber',
      );
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error applying cart discount");
      return null;
    }
  }

  //? Update Items By Input Number
  Future<dynamic> updateItemsCount(
      String cartNumber, String count, List<int> itemsId) async {
    try {
      String itemIdList = itemsId.join(',');
      Map<String, dynamic> data = {"cart_items_count": count};
      return await db.updateData(
        'tbl_cart',
        data,
        'cart_number = $cartNumber AND cart_items_id IN ($itemIdList)',
      );
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error updating item count");
      return null;
    }
  }

  //? Update Items Number
  Future<dynamic> updateItemNumber(
      String cartNumber, String count, String itemsId) async {
    try {
      Map<String, dynamic> data = {"cart_items_count": count};
      return await db.updateData(
        'tbl_cart',
        data,
        'cart_number = $cartNumber AND cart_items_id = $itemsId',
      );
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error updating item number");
      return null;
    }
  }

  //? Update Items Price
  Future<dynamic> updateItemPrice(
      String cartNumber, String price, List<int> itemsId) async {
    try {
      String itemIdList = itemsId.join(',');
      Map<String, dynamic> data = {"cart_item_price": price};

      return await db.updateData(
        'tbl_cart',
        data,
        'cart_number = $cartNumber AND cart_items_id IN ($itemIdList)',
      );
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error updating item number");
      return null;
    }
  }

  //? Update Cart Item Gift Status
  Future<int> cartItemGift(String cartNumber, List<int> itemsId) async {
    try {
      String itemIdList = itemsId.join(',');
      var result = await db.getData(
          "SELECT cart_items_id, cart_item_gift FROM tbl_cart WHERE cart_number = $cartNumber AND cart_items_id IN ($itemIdList)");
      for (var item in result) {
        int currentGiftValue = item['cart_item_gift'];
        int newGiftValue = currentGiftValue == 0 ? 1 : 0;
        String noteData = currentGiftValue == 0 ? TextRoutes.gift : "";
        int response = await db.updateData(
            'tbl_cart',
            {"cart_item_gift": newGiftValue, "cart_note": noteData},
            'cart_number = $cartNumber AND cart_items_id = ${item['cart_items_id']}');

        if (response <= 0) {
          return 0;
        }
      }
      return result.length;
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error updating cart item gift status");
      return 0; // Or handle it as needed
    }
  }

  //? Add Owner To Cart
  Future<dynamic> cartOwnerName(String cartNumber, String name, String phone,
      String address, String note) async {
    try {
      Map<String, dynamic> usersData = {
        "users_name": name,
        "users_phone": phone,
        "users_address": address,
        "users_note": note,
        "users_createdate": currentTime,
        "account_id": 9,
      };
      int userId = await db.insertData("tbl_users", usersData);

      Map<String, dynamic> data = {"cart_owner_id": userId};
      return await db.updateData('tbl_cart', data, 'cart_number = $cartNumber');
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error adding owner to cart");
      return null;
    }
  }

  //? Update Gift Item To Cart
  Future<dynamic> cartOwnerNameUpdate(String cartNumber, String? userId) async {
    print(cartNumber);
    try {
      Map<String, dynamic> data = {"cart_owner_id": userId};
      print(data);
      return await db.updateDataAllowNull(
          'tbl_cart', data, 'cart_number = $cartNumber');
    } catch (e) {
      print(e);
      showErrorDialog(e.toString(),
          title: "Error", message: "Error updating cart owner name");
      return null;
    }
  }

  //? Update Cashing Cart State
  Future<dynamic> cartCashState(String cartNumber, String state) async {
    try {
      Map<String, dynamic> data = {"cart_cash": state};
      return await db.updateData('tbl_cart', data, 'cart_number = $cartNumber');
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error updating cart cash state");
      return null;
    }
  }

  //? Update Tax Cart Value
  Future<dynamic> cartTax(String cartNumber, String tax) async {
    try {
      Map<String, dynamic> data = {"cart_tax": tax};
      return await db.updateData('tbl_cart', data, 'cart_number = $cartNumber');
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error updating cart tax value");
      return null;
    }
  }

  //? Delete Selected Items
  Future<dynamic> deleteData(String cartNumber, List<int> itemsId) async {
    try {
      String itemIdList = itemsId.join(',');
      return await db.deleteData('tbl_cart',
          'cart_number = $cartNumber AND cart_items_id IN ($itemIdList)');
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error deleting items from cart");
      return null;
    }
  }

  //? Delete Cart
  Future<dynamic> deleteCart(String cartNumber) async {
    try {
      var response =
          await db.deleteData('tbl_cart', 'cart_number = $cartNumber');
      return response;
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error deleting cart");
      return null;
    }
  }

  //? Cart Payment
  Future<dynamic> cartPayment(Map<String, dynamic> data) async {
    try {
      return await db.insertData('tbl_invoice', data);
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error processing cart payment");
      return null;
    }
  }

  //? Get max invoice id
  Future<int> getMaxInvoiceId() async {
    try {
      var result =
          await db.getData("SELECT MAX(invoice_id) AS max_id FROM tbl_invoice");
      if (result != null && result.isNotEmpty && result[0]['max_id'] != null) {
        return result[0]['max_id'];
      } else {
        return 0;
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error getting max invoice ID");
      return 0;
    }
  }

  //? Get last invoices
  Future<dynamic> lastInvoices() async {
    try {
      var result = await db.getData(
          "SELECT * FROM view_sales_invoices_summary ORDER BY invoice_id DESC LIMIT 10");
      if (result != null && result.isNotEmpty) {
        return result;
      } else {
        return 'fail';
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error fetching last invoices");
      return 'fail';
    }
  }

  //? Update Invoice
  Future<int> updateInvoice(String cartOrdersId, int cartNumber) async {
    try {
      Map<String, dynamic> data = {
        "cart_orders": 0,
        "cart_status": "review",
        "cart_number": cartNumber,
        "cart_update": 1
      };
      return await db.updateData(
          'tbl_cart', data, "cart_orders = $cartOrdersId");
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error updating invoice");
      return 0;
    }
  }

  //? Remove Updated Invoice
  Future<int> removeUpdatedInvoice(String cartOrdersIdr) async {
    try {
      int response =
          await db.deleteData('tbl_invoice', "invoice_id = $cartOrdersIdr");
      if (response > 0) {
        await db.deleteData(
            'tbl_transactions', "transaction_number = 'IN-$cartOrdersIdr'");
      }
      return response;
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error removing updated invoice");
      return 0;
    }
  }
}
