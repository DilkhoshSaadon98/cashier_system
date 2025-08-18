import 'package:cashier_system/controller/buying/buying_controller.dart';

List<double> calculateFeesAndDiscountFunction(
    int fees, double totalPrice, List<PurchaseRowModel> rows,
    {bool useOriginalPrice = true}) {
  List<double> dataResult = [];

  for (var row in rows) {
    double itemTotal = useOriginalPrice
        ? double.tryParse(row.totalPurchasePriceController.text) ?? 0.0
        : double.tryParse(row.discountTotalPurchasePriceController.text) ?? 0.0;

    double feeAmount = (itemTotal / totalPrice) * fees;
    dataResult.add(feeAmount);
  }

  return dataResult;
}
