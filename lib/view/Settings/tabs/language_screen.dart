import 'package:cashier_system/controller/setting/language_controller.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/view/Settings/widgets/language_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LanguageController());
    return Scaffold(
      appBar: customAppBarTitle("System Language"),
      body: GetBuilder<LanguageController>(builder: (controller) {
        return SizedBox(
          width: Get.width,
          height: 600,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
          ),
        );
      }),
    );
  }
}
