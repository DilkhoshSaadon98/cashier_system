class ItemsModel {
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
  int? categoriesId;
  String? categoriesName;
  String? categoriesCreatedate;
  String? categoriesImage;
  int? typeID;
  String? typeName;
  int? itemsQTY;

  ItemsModel(
      {this.itemsId,
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
      this.itemsCreatedate,
      this.categoriesId,
      this.categoriesName,
      this.categoriesCreatedate,
      this.categoriesImage,
      this.typeID,
      this.typeName,
      this.itemsQTY,
      });

  ItemsModel.fromJson(Map<String, dynamic> json) {
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
    categoriesId = json['categories_id'];
    categoriesName = json['categories_name'];
    categoriesCreatedate = json['categories_createdate'];
    categoriesImage = json['categories_image'];
    typeID = json['type_id'];
    typeName = json['type_name'];
    itemsQTY = json['items_quantity'];
  }
}
