class CartModel {
  int? cartItemDiscount;
  int? cartDiscount;
  int? cartItemGift;
  int? countItems;
  String? cartOwner;
  String? cartTax;
  String? cartCash;
  int? cartId;
  int? cartItemsId;
  int? cartOrders;
  int? cartNumber;
  int? cartUpdate;
  int? cartItemsCount;
  String? cartCreateDate;
  String? cartStatus;
  int? itemsId;
  String? itemsName;
  String? itemsBarcode;
  int? itemsSellingprice;
  int? itemsBuingprice;
  int? itemsWholesaleprice;
  int? itemsCount;
  int? itemsType;
  int? itemsCostprice;
  String? itemsDesc;
  int? itemsCat;
  String? itemsCreatedate;

  CartModel(
      {this.cartItemDiscount,
      this.cartDiscount,
      this.countItems,
      this.cartItemGift,
      this.cartOwner,
      this.cartTax,
      this.cartCash,
      this.cartId,
      this.cartItemsId,
      this.cartOrders,
      this.cartNumber,
      this.cartUpdate,
      this.cartItemsCount,
      this.cartCreateDate,
      this.cartStatus,
      this.itemsId,
      this.itemsName,
      this.itemsBarcode,
      this.itemsSellingprice,
      this.itemsBuingprice,
      this.itemsWholesaleprice,
      this.itemsCount,
      this.itemsType,
      this.itemsCostprice,
      this.itemsDesc,
      this.itemsCat,
      this.itemsCreatedate});

  CartModel.fromJson(Map<String, dynamic> json) {
    cartItemDiscount = json['cart_item_discount'];
    cartDiscount = json['cart_discount'];
    cartItemGift = json['cart_item_gift'];
    countItems = json['count_items'];
    cartOwner = json['cart_owner'];
    cartTax = json['cart_tax'];
    cartCash = json['cart_cash'];
    cartId = json['cart_id'];
    cartItemsId = json['cart_items_id'];
    cartOrders = json['cart_orders'];
    cartNumber = json['cart_number'];
    cartUpdate = json['cart_update'];
    cartItemsCount = json['cart_items_count'];
    cartCreateDate = json['cart_create_date'];
    cartStatus = json['cart_status'];
    itemsId = json['items_id'];
    itemsName = json['items_name'];
    itemsBarcode = json['items_barcode'];
    itemsSellingprice = json['items_selling'];
    itemsBuingprice = json['items_buingprice'];
    itemsWholesaleprice = json['items_wholesaleprice'];
    itemsCount = json['items_count'];
    itemsType = json['items_type'];
    itemsCostprice = json['items_costprice'];
    itemsDesc = json['items_desc'];
    itemsCat = json['items_cat'];
    itemsCreatedate = json['items_createdate'];
  }

}