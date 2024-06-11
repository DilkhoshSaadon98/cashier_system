import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/routes.dart';
import 'package:cashier_system/core/responsive/responisve_text_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CustomHeaderScreen extends StatelessWidget {
  final String? title;
  final String? imagePath;
  final void Function()? root;
  CustomHeaderScreen({
    super.key,
    this.title,
    this.imagePath,
    this.root,
  });

  final DateTime myDateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: root,
          child: Column(
            children: [
              SvgPicture.asset(
                imagePath!,
                width: 30,
                // ignore: deprecated_member_use
                color: secondColor,
              ),
              Text(
                title!.tr,
                style: titleStyle.copyWith(
                    color: secondColor,
                    fontSize: responsivefontSize(Get.width)),
              ),
            ],
          ),
        ),
        const Spacer(),
        IconButton(
            onPressed: () {
              Get.back();
            },
            icon: CircleAvatar(
              radius: 20,
              backgroundColor: white,
              child: Icon(
                Icons.arrow_forward_ios_outlined,
                color: primaryColor,
              ),
            )),
        GestureDetector(
          onTap: () {
            Get.offAllNamed(AppRoute.homeScreen);
          },
          child: CircleAvatar(
              radius: 20,
              backgroundColor: secondColor,
              child: Icon(
                Icons.home,
                color: primaryColor,
                size: 30,
              )),
        ),
      ],
    );
  }
}
