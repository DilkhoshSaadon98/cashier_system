import 'package:cashier_system/controller/home/home_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

Widget buildGridView() {
  return Container(
    height: 400,
    width: Get.width / 2,
    child: GetBuilder<HomeController>(
      builder: (controller) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _calculateCrossAxisCount(Get.width),
            childAspectRatio: 1.5,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: controller.homeTitles.length,
          itemBuilder: (context, index) {
            return Focus(
              autofocus: true,
              focusNode: controller.focusNode,
              onKeyEvent: (node, event) {
                if (event is KeyDownEvent) {
                  LogicalKeyboardKey key = event.logicalKey;
                  if (controller.keyToIndexMap.containsKey(key)) {
                    int index = controller.keyToIndexMap[key]!;
                    controller.homeTab[index]();
                    return KeyEventResult.handled;
                  }
                }
                return KeyEventResult.ignored;
              },
              child: InkWell(
                onTap: controller.homeTab[index],
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SvgPicture.asset(
                        controller.homeIcons[index],
                        semanticsLabel: 'Icon',
                        // ignore: deprecated_member_use
                        color: primaryColor,
                        width: 75,
                        height: 75,
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        controller.homeTitles[index].tr,
                        style: titleStyle.copyWith(
                          color: primaryColor,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ),
  );
}

int _calculateCrossAxisCount(double screenWidth) {
  if (screenWidth > 1200) {
    return 3;
  } else if (screenWidth > 800) {
    return 2;
  } else {
    return 1;
  }
}
