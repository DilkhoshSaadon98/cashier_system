import 'package:get/get.dart';
import 'package:intl/intl.dart';

String formattingNumbers(dynamic number) {
  return NumberFormat('#,##0').format(number) + ' IQD'.tr;
}
