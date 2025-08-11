import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/localization/changelocal.dart';
import 'package:get/get.dart';

class LanguageController extends GetxController {
  LocaleController localeController = Get.find();

  String? selectedLanguage;

  chooseLanguage(String val) {
    selectedLanguage = val;
    selectedLanguage == "en"
        ? localeController.changeLang('en')
        : selectedLanguage == "ar"
            ? localeController.changeLang('ar')
            : localeController.changeLang('he');
    update();
  }

  @override
  void onInit() {
    selectedLanguage = myServices.systemSharedPreferences.getString('lang');
    super.onInit();
  }
}
