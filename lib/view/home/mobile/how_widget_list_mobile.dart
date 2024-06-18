import 'package:cashier_system/controller/home/home_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

Widget buildGridViewMobile() {
  return SizedBox(
    height: Get.height,
    child: GetBuilder<HomeController>(
      builder: (controller) {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
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
                        width: 50,
                        height: 50,
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
