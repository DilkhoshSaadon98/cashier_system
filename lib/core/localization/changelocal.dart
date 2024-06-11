import 'package:cashier_system/core/services/services.dart';
import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocaleController extends GetxController {
  Locale? language;

  MyServices myServices = Get.find();

  changeLang(String langcode) {
    Locale locale = Locale(langcode);
    myServices.systemSharedPreferences.setString("lang", langcode);
    Get.updateLocale(locale);
  }



  @override
  void onInit() {
    //requestPerLocation();
    String? sharedPrefLang =
        myServices.systemSharedPreferences.getString("lang");
    if (sharedPrefLang == "ar") {
      language = const Locale("ar");
    } else if (sharedPrefLang == "en") {
      language = const Locale("en");
    } else if (sharedPrefLang == "he") {
      language = const Locale("he");
    } else {
      language = Locale(Get.deviceLocale!.languageCode);
    }
    super.onInit();
  }
}
