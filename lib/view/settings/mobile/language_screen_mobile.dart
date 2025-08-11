import 'package:cashier_system/controller/setting/language_controller.dart';
import 'package:cashier_system/core/functions/change_direction.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/view/settings/components/language_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageScreenMobile extends StatelessWidget {
  const LanguageScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LanguageController());
    return Directionality(textDirection: screenDirection(),
      child: Scaffold(
        appBar: customAppBarTitle("System Language", true),
        body: GetBuilder<LanguageController>(builder: (controller) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            children: [
              InkWell(
                onTap: () {
                  controller.chooseLanguage("en");
                },
                child: LanguageCard(
                    title: "English",
                    active: controller.selectedLanguage == "en" ? true : false),
              ),
              InkWell(
                onTap: () {
                  controller.chooseLanguage("ar");
                },
                child: LanguageCard(
                    title: "Arabic",
                    active: controller.selectedLanguage == "ar" ? true : false),
              ),
              InkWell(
                onTap: () {
                  controller.chooseLanguage("he");
                },
                child: LanguageCard(
                    title: "Kurdish",
                    active: controller.selectedLanguage == "he" ? true : false),
              ),
            ],
          );
        }),
      ),
    );
  }
}
