class ExpensesModel {
  int? expensesId;
  String? expensesTitle;
  int? expensesPrice;
  String? expensesNote;
  int? expensesCreateDate;

  ExpensesModel(
      {this.expensesId,
      this.expensesTitle,
      this.expensesPrice,
      this.expensesNote,
      this.expensesCreateDate});

  ExpensesModel.fromJson(Map<String, dynamic> json) {
    expensesId = json['expenses_id'];
    expensesTitle = json['expenses_title'];
    expensesPrice = json['expenses_price'];
    expensesNote = json['expenses_note'];
    expensesCreateDate = json['expenses_create_date'];
  }
}
