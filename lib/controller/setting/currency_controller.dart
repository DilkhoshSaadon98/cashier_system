import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:get/get.dart';

class CurrencyController extends GetxController {
  String? selectedCurrency;

  chooseCurrency(String val) {
    selectedCurrency = val;
    myServices.systemSharedPreferences.setString("currency", selectedCurrency!);
    update();
  }

  @override
  void onInit() {
    selectedCurrency = myServices.systemSharedPreferences.getString('currency');
    super.onInit();
  }
}
