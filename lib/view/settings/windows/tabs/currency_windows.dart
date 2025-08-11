import 'package:cashier_system/controller/setting/currency_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/view/settings/components/language_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CurrencyWindows extends StatelessWidget {
  const CurrencyWindows({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CurrencyController());
    return Scaffold(
      appBar: customAppBarTitle(
          "System Currency", Get.width < mobileScreenWidth ? true : false),
      backgroundColor: white,
      body: GetBuilder<CurrencyController>(builder: (controller) {
        return SizedBox(
          width: Get.width,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            children: [
              InkWell(
                onTap: () {
                  controller.chooseCurrency("iqd");
                },
                child: LanguageCard(
                    title: "Iraqi Dinar",
                    active:
                        controller.selectedCurrency == "iqd" ? true : false),
              ),
              InkWell(
                onTap: () {
                  controller.chooseCurrency("dollar");
                },
                child: LanguageCard(
                    title: "Dollar",
                    active:
                        controller.selectedCurrency == "dollar" ? true : false),
              ),
            ],
          ),
        );
      }),
    );
  }
}
