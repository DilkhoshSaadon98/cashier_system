class InvoicesSalaryModel {
  final int invoiceId;
  final String invoiceCreatedDate;
  final double invoiceCost;
  final double invoiceDiscount;
  final double invoiceTax;
  final double invoicePrice;
  final double invoiceProfit;
  final String? accountName;

  InvoicesSalaryModel({
    required this.invoiceId,
    required this.invoiceCreatedDate,
    required this.invoiceCost,
    required this.invoiceDiscount,
    required this.invoiceTax,
    required this.invoicePrice,
    required this.invoiceProfit,
    this.accountName,
  });

  factory InvoicesSalaryModel.fromJson(Map<String, dynamic> json) {
    return InvoicesSalaryModel(
      invoiceId: json['invoice_id'],
      invoiceCreatedDate: json['invoice_createdate'],
      invoiceCost: (json['invoice_cost'] as num).toDouble(),
      invoiceDiscount: (json['invoice_discount'] as num).toDouble(),
      invoiceTax: (json['invoice_tax'] as num).toDouble(),
      invoicePrice: (json['invoice_price'] as num).toDouble(),
      invoiceProfit: (json['invoice_profit'] as num).toDouble(),
      accountName: json['account_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoice_id': invoiceId,
      'invoice_createdate': invoiceCreatedDate,
      'invoice_cost': invoiceCost,
      'invoice_discount': invoiceDiscount,
      'invoice_tax': invoiceTax,
      'invoice_price': invoicePrice,
      'invoice_profit': invoiceProfit,
      'account_name': accountName,
    };
  }
}
