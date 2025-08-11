import 'package:flutter/material.dart';

List<double> calculateFeesAndDiscountFunction(int fees, double totalPrice,
    List<TextEditingController> itemTotalPriceControllers) {
  List<double> dataResult = [];

  for (int i = 0; i < itemTotalPriceControllers.length; i++) {
    double itemTotal = double.tryParse(itemTotalPriceControllers[i].text)??0.0;
    double feeAmount = (itemTotal / totalPrice) * fees;
    dataResult.add(feeAmount);
  }
  return dataResult;
}
