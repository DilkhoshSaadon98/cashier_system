List<double> calculateFees(int fees, int totalPrice, List<dynamic> data) {
  print(data);
  print(totalPrice);
  List<double> percentageValue = [];
  List<double> dataResult = [];
  for (int i = 0; i < data.length; i++) {
    percentageValue.add((int.parse(data[i].text) / totalPrice) * 100);
  }
  print("percentage  : $percentageValue");
  for (int i = 0; i < data.length; i++) {
    dataResult.add((percentageValue[i] * fees / 100));
  }
  print("dataResult  : $dataResult");
  return dataResult;
}
