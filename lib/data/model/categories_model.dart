class CategoriesModel {
  int? categoriesId;
  String? categoriesName;
  String? categoriesImage;
  int? itemsCount;
  String? categoriesCreateDate;

  CategoriesModel(
      {this.categoriesId,
      this.categoriesName,
      this.categoriesImage,
      this.itemsCount = 0,
      this.categoriesCreateDate});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    categoriesId = json['categories_id'];
    categoriesName = json['categories_name'];
    categoriesImage = json['categories_image'];
    itemsCount = json['item_count'];
    categoriesCreateDate = json['categories_createdate'];
  }
}
