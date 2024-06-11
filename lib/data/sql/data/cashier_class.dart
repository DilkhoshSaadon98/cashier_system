import 'package:cashier_system/data/sql/sqldb.dart';
import 'package:intl/intl.dart';

class CashierClass {
  SqlDb db = SqlDb();

  Future<Map<String, dynamic>> processCartData(String cartNumber) async {
    // Update cart statuses
    await updateCartStatus(cartNumber);

    // Get total cart price
    int totalCartPrice = await getTotalCartPrice(cartNumber);

    // Get pending carts count
    int totalPendingCart = await getPendingCartsCount();

    // Get pended carts
    List<int> totalPendedCarts = await getPendedCarts();

    // Get carts numbers
    List<int> totalCartsNumbers = await getCartsNumbers();
    int totalItemsNumbers = await getItemsNumbers(cartNumber);
    int totalCartCost = await getTotalCartCost(cartNumber);

    // Get cart data
    var cartData = await getCartData(cartNumber);

    // Construct response
    var response = {
      "status": "success",
      "total_cart_price": totalCartPrice,
      "total_pending_cart": totalPendingCart,
      "pended_carts": totalPendedCarts,
      "carts_number": totalCartsNumbers,
      "cart_items_count": totalItemsNumbers,
      "total_cart_cost": totalCartCost,
      "datacart": cartData,
    };

    return response;
  }

  Future<void> updateCartStatus(String cartNumber) async {
    await db.updateData(
        'tbl_cart', {'cart_status': 'review'}, 'cart_number = $cartNumber');
    await db.updateData('tbl_cart', {'cart_status': 'pending'},
        'cart_number <> $cartNumber AND cart_number <> 0');
  }

  //? Total Cart Price:
  Future<int> getTotalCartPrice(String cartNumber) async {
    var result = await db.getData('''
    SELECT 
    CAST(
        (
           SUM(items_selling * cart_items_count)
            - IFNULL(cart_discount, 0)
            + IFNULL(cart_tax, 0)
        ) AS INTEGER
    ) AS total_cart_price 
    FROM 
        cartview  
    WHERE 
        cart_number = $cartNumber 
        AND cart_item_gift = 0
  ''');
    if (result != null &&
        result.isNotEmpty &&
        result[0]['total_cart_price'] != null) {
      return result[0]['total_cart_price'];
    } else {
      return 0;
    }
  }

  //? Total Cart Cost:
  Future<int> getTotalCartCost(String cartNumber) async {
    var result = await db.getData('''
    SELECT 
    CAST(
        (
           SUM(items_costprice * cart_items_count) 
        ) AS INTEGER
    ) AS total_cart_cost 
    FROM 
        cartview  
    WHERE 
        cart_number = $cartNumber
  ''');
    if (result != null &&
        result.isNotEmpty &&
        result[0]['total_cart_cost'] != null) {
      return result[0]['total_cart_cost'];
    } else {
      return 0;
    }
  }

  //? Counting Pended Carts:
  Future<int> getPendingCartsCount() async {
    var result = await db.getData(
        "SELECT COUNT(DISTINCT cart_number) as pending_cart FROM tbl_cart WHERE cart_status = 'pending'");
    if (result != null &&
        result.isNotEmpty &&
        result[0]['pending_cart'] != null) {
      return result[0]['pending_cart'];
    } else {
      return 0;
    }
  }

  //? Get Pended Carts:
  Future<List<int>> getPendedCarts() async {
    var result = await db.getData(
        "SELECT DISTINCT cart_number FROM tbl_cart WHERE ( cart_status != 'review' AND cart_status != 'done' ) ORDER BY cart_number ASC");

    List<int> cartNumbers =
        result.map<int>((e) => e['cart_number'] as int).toList();
    return cartNumbers;
  }

  //? Get Carts For Cashier Header:
  Future<List<int>> getCartsNumbers() async {
    var result = await db.getData(
        "SELECT DISTINCT cart_number FROM tbl_cart WHERE cart_number <> 0 ORDER BY cart_number ASC");
    List<int> cartNumbers =
        result.map<int>((e) => e['cart_number'] as int).toList();
    return cartNumbers;
  }

  //? Counting Items Number for each cart:
  Future<int> getItemsNumbers(String cartNumber) async {
    var result = await db.getData(
        "SELECT COUNT(DISTINCT cart_items_id) as cart_items_count FROM tbl_cart WHERE cart_number = $cartNumber  ORDER BY cart_number ASC");
    if (result != null &&
        result.isNotEmpty &&
        result[0]['cart_items_count'] != null) {
      return result[0]['cart_items_count'];
    } else {
      return 0;
    }
  }

  Future<int> getMaxInvoiceNumber(String cartNumber) async {
    var result = await db.getData(
        "SELECT COUNT(DISTINCT cart_items_id) as cart_items_count FROM tbl_cart WHERE cart_number = $cartNumber  ORDER BY cart_number ASC");
    if (result != null &&
        result.isNotEmpty &&
        result[0]['cart_items_count'] != null) {
      return result[0]['cart_items_count'];
    } else {
      return 0;
    }
  }

  //? Get cart data :
  Future<dynamic> getCartData(String cartNumber) async {
    return await db.getAllData('cartview', where: 'cart_number = $cartNumber ');
  }

  //! Cashier Button Actions:
  //? increase data items:
  Future<dynamic> increasData(
      int itemCount, String cartNumber, String itemsId) async {
    int newCount = itemCount + 1;
    Map<String, dynamic> data = {"cart_items_count": newCount};
    return await db.updateData('tbl_cart', data,
        'cart_number = $cartNumber AND cart_items_id = $itemsId',
        json: false);
  }

  //? decrease data items:
  Future<dynamic> decreaseData(
      int itemCount, String cartNumber, String itemsId) async {
    int newCount = itemCount - 1;
    Map<String, dynamic> data = {"cart_items_count": newCount};
    return await db.updateData('tbl_cart', data,
        'cart_number = $cartNumber AND cart_items_id = $itemsId');
  }

  //? Cart Items Discount:
  Future<dynamic> discountingItems(
      String cartNumber, String discount, List<String> itemsId) async {
    String itemIdList = itemsId.join(',');
    Map<String, dynamic> data = {"cart_item_discount": discount};
    return await db.updateData('tbl_cart', data,
        'cart_number = $cartNumber AND cart_items_id IN ($itemIdList)');
  }

  //? Cart Discount:
  Future<dynamic> discountingCart(String cartNumber, String discount) async {
    Map<String, dynamic> data = {"cart_discount": discount};
    return await db.updateData('tbl_cart', data, 'cart_number = $cartNumber');
  }

  //? Update Items Bu input Number
  Future<dynamic> addItembyNum(
      String cartNumber, String count, List<String> itemsId) async {
    String itemIdList = itemsId.join(',');
    Map<String, dynamic> data = {"cart_items_count": count};
    return await db.updateData('tbl_cart', data,
        'cart_number = $cartNumber AND cart_items_id IN ($itemIdList)');
  }

  //? Update Items Number
  Future<dynamic> updateItemNumber(
      String cartNumber, String count, String itemsId) async {
    Map<String, dynamic> data = {"cart_items_count": count};
    return await db.updateData('tbl_cart', data,
        'cart_number = $cartNumber AND cart_items_id = $itemsId');
  }

  Future<int> cartItemGift(String cartNumber, List<String> itemsId) async {
    String itemIdList = itemsId.join(',');
    var result = await db.getData(
        "SELECT cart_items_id, cart_item_gift FROM tbl_cart WHERE cart_number = $cartNumber AND cart_items_id IN ($itemIdList)");
    for (var item in result) {
      int currentGiftValue = item['cart_item_gift'];
      int newGiftValue = currentGiftValue == 0 ? 1 : 0;
      int response = await db.updateData(
          "tbl_cart",
          {"cart_item_gift": newGiftValue},
          "cart_number = $cartNumber AND cart_items_id = ${item['cart_items_id']}");

      if (response <= 0) {
        return 0;
      }
    }
    return result.length;
  }

//? Get User Id for addn Cart Owner
  Future<int> getUserId(String username) async {
    var result = await db.getData(
        "SELECT users_id FROM tbl_users WHERE users_name = '$username'");
    if (result != null && result.isNotEmpty && result[0]['users_id'] != null) {
      return result[0]['users_id'];
    } else {
      return 0;
    }
  }

  //? Add Owner To Cart
  Future<dynamic> cartOwnerName(String cartNumber, String name, String phone,
      String address, String note) async {
    Map<String, dynamic> data = {"cart_owner": name};
    Map<String, dynamic> usersData = {
      "users_name": name,
      "users_phone": phone,
      "users_address": address,
      "users_note": note,
      "users_role": "customer",
      "users_createdate":
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
    };
    await db.insertData("tbl_users", usersData);
    return await db.updateData('tbl_cart', data, 'cart_number = $cartNumber');
  }

//? Update Gift Item To Cart
  Future<dynamic> cartOwnerNameUpdate(String cartNumber, String name) async {
    Map<String, dynamic> data = {"cart_owner": name};
    return await db.updateData('tbl_cart', data, 'cart_number = $cartNumber');
  }

//? UPdate Cashing Cart State
  Future<dynamic> cartCashState(String cartNumber, String state) async {
    Map<String, dynamic> data = {"cart_cash": state};
    return await db.updateData('tbl_cart', data, 'cart_number = $cartNumber');
  }

//? UPdate Tax Cart Value
  Future<dynamic> cartTax(String cartNumber, String tax) async {
    Map<String, dynamic> data = {"cart_tax": tax};
    return await db.updateData('tbl_cart', data, 'cart_number = $cartNumber');
  }

//? Delete Selected Items
  Future<dynamic> deleteData(String cartNumber, List<String> itemsId) async {
    String itemIdList = itemsId.join(',');
    return await db.deleteData('tbl_cart',
        'cart_number = $cartNumber AND cart_items_id IN ($itemIdList)');
  }

//? Delete Cart
  Future<dynamic> deleteCart(String cartNumber) async {
    return await db.deleteData('tbl_cart', 'cart_number = $cartNumber');
  }

  //! cart Payment
  Future<dynamic> cartPayment(Map<String, dynamic> data) async {
    return await db.insertData('tbl_invoice', data);
  }

  //! Get max invoice id:
  Future<int> getMaxInvoiceId() async {
    var result =
        await db.getData("SELECT MAX(invoice_id) AS max_id FROM tbl_invoice");
    if (result != null && result.isNotEmpty && result[0]['max_id'] != null) {
      return result[0]['max_id'];
    } else {
      return 0;
    }
  }

  //! Get last Invoices
  Future<dynamic> lastInvoices() async {
    var result = await db
        .getData("SELECT * FROM invoiceView ORDER BY invoice_id DESC LIMIT 10");
    //  print(result);
    if (result != null && result.isNotEmpty) {
      return result;
    } else {
      return 'fail';
    }
  }

  //! UPdate Last Invoice

  Future<int> updateInvoice(String cartOrdersId, int cartNumber) async {
    Map<String, dynamic> data = {
      "cart_orders": 0,
      "cart_status": "review",
      "cart_number": cartNumber,
      "cart_update": 1
    };
    return await db.updateData('tbl_cart', data, "cart_orders = $cartOrdersId");
  }

  //! remove updated Invoice
  Future<int> removeUpdatedInvoice(String cartOrdersIdr) async {
    return await db.deleteData('tbl_invoice', "invoice_id = $cartOrdersIdr");
  }
}
