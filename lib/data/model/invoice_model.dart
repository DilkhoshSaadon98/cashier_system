class InvoiceModel {
  int? invoiceId;
  int? invoicUserId;
  int? invoiceTax;
  int? invoiceDiscount;
  int? invoicePrice;
  int? invoiceCostPrice;
  int? invoiceItemNumber;
  String? invoicePayment;
  String? invoiceCreateDate;
  int? usersId;
  String? usersName;
  String? usersEmail;
  String? usersPhone;
  String? usersAddress;
  String? usersRole;
  String? usersCreateDate;

  InvoiceModel(
      {this.invoiceId,
      this.invoicUserId,
      this.invoiceTax,
      this.invoiceDiscount,
      this.invoicePrice,
      this.invoiceCostPrice,
      this.invoiceItemNumber,
      this.invoiceCreateDate,
      this.invoicePayment,
      this.usersId,
      this.usersName,
      this.usersEmail,
      this.usersPhone,
      this.usersAddress,
      this.usersRole,
      this.usersCreateDate});

  InvoiceModel.fromJson(Map<String, dynamic> json) {
    invoiceId = json['invoice_id'];
    invoicUserId = json['invoice_user_id'];
    invoiceTax = json['invoice_tax'];
    invoiceDiscount = json['invoice_discount'];
    invoiceItemNumber = json['invoice_items_number'];
    invoicePrice = json['invoice_price'];
    invoiceCostPrice = json['invoice_cost'];
    invoiceCreateDate = json['invoice_createdate'];
    invoicePayment = json['invoice_payment'];
    usersId = json['users_id'];
    usersName = json['users_name'];
    usersEmail = json['users_email'];
    usersPhone = json['users_phone'];
    usersAddress = json['users_address'];
    usersRole = json['users_role'];
    usersCreateDate = json['users_createdate'];
  }
}
