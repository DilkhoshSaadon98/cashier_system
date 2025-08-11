import 'package:cashier_system/core/localization/ar_translation.dart';
import 'package:cashier_system/core/localization/en_translation.dart';
import 'package:cashier_system/core/localization/ku_sorani_translation.dart';
import 'package:get/get.dart';

class MyTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': enTranslation,
        "ar":arTranslation,
       "he":kuSoraniTranslation
      };
}
