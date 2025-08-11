import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';

String formattingNumbers(dynamic number) {
  NumberFormat numberFormat;

  if (number is int) {
    numberFormat = NumberFormat('#,##0');
  } else if (number is double) {
    numberFormat = NumberFormat('#,##0.00');
  } else {
    numberFormat = NumberFormat('#,##0');
  }

  String currencyText =
      myServices.systemSharedPreferences.getString('currency') == "iqd"
          ? 'IQD'.tr
          : " \$";

  return '${numberFormat.format(number)} $currencyText';
}
