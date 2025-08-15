import 'dart:convert';

import 'package:cashier_system/data/model/items_model.dart';

class CartModel {
  final int cartId;
  final int cartItemsId;
  final int cartOrders;
  final int cartNumber;
  final double cartItemDiscount;
  final double cartDiscount;
  final int cartItemGift;
  final String? cartOwnerId;
  final int? accountId;
  final int cartItemsCount;
  final double cartItemsPrice;
  final double cartTax;
  final String cartCash;
  final String cartStatus;
  final String cartCreateDate;
  final int cartUpdate;
  final String? usersName;

  // Item data
  final int itemsId;
  final String itemsName;
  final String itemsBarcode;
  final double itemsSellingPrice;
  final double itemsBuyingPrice;
  final double itemsWholesalePrice;
  final double itemsCostPrice;
  final double itemsBaseQuantity;
  final double itemsAltQuantity;
  final double unitFactor;
  final String mainUnitName;
  final String itemDescription;
  final int itemCategoryId;
  final String itemImage;
  final String itemCreateDate;
  final String itemCode;
  final String productionDate;
  final String expiryDate;
  String? cartNote;
  final double itemCount;
  final List<AltUnit> altUnits;
  String? selectedUnitName;
  CartModel({
    required this.cartId,
    required this.accountId,
    required this.cartItemsId,
    required this.cartOrders,
    required this.cartNumber,
    required this.cartItemDiscount,
    required this.cartDiscount,
    required this.cartItemGift,
    this.cartOwnerId,
    required this.cartItemsCount,
    required this.cartItemsPrice,
    required this.cartTax,
    required this.cartCash,
    required this.cartStatus,
    required this.cartCreateDate,
    required this.cartUpdate,
    this.usersName,
    this.cartNote,
    required this.itemsId,
    required this.itemsName,
    required this.itemsBarcode,
    required this.itemsSellingPrice,
    required this.itemsBuyingPrice,
    required this.itemsWholesalePrice,
    required this.itemsCostPrice,
    required this.itemsBaseQuantity,
    required this.itemsAltQuantity,
    required this.unitFactor,
    required this.mainUnitName,
    required this.itemDescription,
    required this.itemCategoryId,
    required this.itemImage,
    required this.itemCreateDate,
    required this.itemCode,
    required this.productionDate,
    required this.expiryDate,
    required this.itemCount,
    this.altUnits = const [],
    this.selectedUnitName,
  });
  factory CartModel.fromJson(Map<String, dynamic> map) {
    List<AltUnit> altUnitsList = [];
    if (map['alt_units'] != null && map['alt_units'] != "") {
      // Decode JSON string first
      final unitsData = jsonDecode(map['alt_units']) as List<dynamic>;
      altUnitsList = unitsData.map((u) => AltUnit.fromMap(u)).toList();
    }
    double mainPrice = (map['item_selling_price'] ?? 0).toDouble();

    return CartModel(
      cartId: map['cart_id'] ?? 0,
      accountId: map['account_id'],
      cartItemsId: map['cart_items_id'] ?? 0,
      cartOrders: map['cart_orders'] ?? 0,
      cartNote: map['cart_note'] ?? "",
      cartNumber: map['cart_number'] ?? 0,
      cartItemDiscount: (map['cart_item_discount'] ?? 0).toDouble(),
      cartDiscount: (map['cart_discount'] ?? 0).toDouble(),
      cartItemGift: map['cart_item_gift'] ?? 0,
      cartOwnerId: map['cart_owner_id'].toString(),
      cartItemsCount: map['cart_items_count'] ?? 0,
      cartItemsPrice: (map['cart_item_price'] ?? 0).toDouble(),
      cartTax: (map['cart_tax'] ?? 0).toDouble(),
      cartCash: map['cart_cash'] ?? '',
      cartStatus: map['cart_status'] ?? '',
      cartCreateDate: map['cart_create_date'] ?? '',
      cartUpdate: map['cart_update'] ?? 0,
      usersName: map['users_name'],
      itemsId: map['item_id'] ?? 0,
      itemsName: map['item_name'] ?? '',
      itemsBarcode: map['item_barcode']?.toString() ?? '',
      itemsBuyingPrice: (map['item_buying_price'] ?? 0).toDouble(),
      itemsWholesalePrice: (map['item_wholesale_price'] ?? 0).toDouble(),
      itemsCostPrice: (map['item_cost_price'] ?? 0).toDouble(),
      itemsBaseQuantity: (map['item_base_quantity'] ?? 0).toDouble(),
      itemsAltQuantity: (map['item_alt_quantity'] ?? 0).toDouble(),
      unitFactor: (map['factor'] ?? 1).toDouble(),
      mainUnitName: map['main_item_unit'] ?? '',
      itemDescription: map['item_description'] ?? '',
      itemCategoryId: map['item_category_id'] ?? 0,
      itemImage: map['item_image'] ?? '',
      itemCreateDate: map['item_create_date'] ?? '',
      itemCode: map['item_code']?.toString() ?? '',
      productionDate: map['production_date'] ?? '',
      expiryDate: map['expiry_date'] ?? '',
      itemCount: (map['item_count'] ?? 0).toDouble(),
      altUnits: altUnitsList,
      itemsSellingPrice: mainPrice,
      selectedUnitName: map['selected_item_unit'] ?? '',
    );
  }
}
