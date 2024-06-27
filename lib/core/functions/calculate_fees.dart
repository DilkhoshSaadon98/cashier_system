import 'package:flutter/material.dart';

List<double> calculateFees(int fees, int totalPrice, List<TextEditingController> itemTotalPriceControllers) {
  List<double> percentageValue = [];
  List<double> dataResult = [];

  // Calculate percentage of each item's total price compared to the total
  for (int i = 0; i < itemTotalPriceControllers.length; i++) {
    double itemTotal = double.parse(itemTotalPriceControllers[i].text);
    double percentage = (itemTotal / totalPrice) * 100;
    percentageValue.add(percentage);
  }

  // Apply the fees percentage to each item's percentage value
  for (int i = 0; i < itemTotalPriceControllers.length; i++) {
    double feeAmount = (percentageValue[i] * fees / 100);
    dataResult.add(feeAmount);
  }

  return dataResult;
}
