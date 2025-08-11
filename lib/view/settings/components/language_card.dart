import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageCard extends StatelessWidget {
  final String title;
  final bool active;
  const LanguageCard({super.key, required this.title, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(
        horizontal: constScreenPadding,
      ),
      decoration: BoxDecoration(
        color: active == true ? tableHeaderColor : white,
        borderRadius: BorderRadius.circular(5),
        border:
            Border.all(color: active == true ? white : primaryColor, width: .5),
      ),
      child: Row(
        mainAxisAlignment: active == true
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
        children: [
          Text(title.tr,
              style: titleStyle.copyWith(
                  color: active == true ? white : primaryColor,
                  height: 1,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          active == true
              ? const Icon(
                  Icons.check,
                  color: secondColor,
                )
              : Container()
        ],
      ),
    );
  }
}
