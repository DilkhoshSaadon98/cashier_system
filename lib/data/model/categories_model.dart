class CategoriesModel {
  int? categoriesId;
  String? categoriesName;
  String? categoriesCreatedate;

  CategoriesModel(
      {this.categoriesId,
      this.categoriesName,
      this.categoriesCreatedate});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    categoriesId = json['categories_id'];
    categoriesName = json['categories_name'];
    categoriesCreatedate = json['categories_createdate'];
  }


}
