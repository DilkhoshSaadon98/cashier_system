import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/screen_routes.dart';
import 'package:cashier_system/core/functions/change_direction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CustomHeaderScreen extends StatelessWidget {
  final String? title;
  final String? imagePath;
  final bool showBackButton;
  final void Function()? onTapLogo;

  const CustomHeaderScreen({
    super.key,
    this.title,
    this.imagePath,
    this.onTapLogo,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final isLtr = screenDirection() == TextDirection.ltr;

    final logoSection = GestureDetector(
      onTap: onTapLogo,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (imagePath != null)
            SvgPicture.asset(
              imagePath!,
              width: 30,
              // ignore: deprecated_member_use
              color: white,
            ),
          if (title != null)
            Text(
              title!.tr,
              style: titleStyle.copyWith(color: white, fontSize: 16),
            ),
        ],
      ),
    );

    final homeButton = GestureDetector(
      onTap: () => Get.offAllNamed(AppRoute.homeScreen),
      child: const CircleAvatar(
        radius: 20,
        backgroundColor: fourthColor,
        child: Icon(Icons.home, color: white),
      ),
    );

    final backButton = showBackButton
        ? IconButton(
            onPressed: () => Get.back(),
            icon: const CircleAvatar(
              radius: 20,
              backgroundColor: white,
              child: Icon(
                Icons.arrow_forward_ios_outlined,
                color: primaryColor,
              ),
            ),
          )
        : const SizedBox();

    return Row(
      children: isLtr
          ? [logoSection, const Spacer(), homeButton, backButton]
          : [homeButton, backButton, const Spacer(), logoSection],
    );
  }
}
