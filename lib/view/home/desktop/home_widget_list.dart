import 'package:cashier_system/controller/home/home_controller.dart';
import 'package:cashier_system/view/home/widgets/home_card_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Widget buildGridViewDesktop() {
  return SizedBox(
    width: Get.width / 2,
    child: GetBuilder<HomeController>(
      builder: (controller) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _calculateCrossAxisCount(Get.width),
            childAspectRatio: _calculateChildAspectRatio(Get.width),
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: controller.data.length,
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
                child: customHomeItemsCard(controller.data[index]));
          },
        );
      },
    ),
  );
}

int _calculateCrossAxisCount(double screenWidth) {
  if (screenWidth > 1000) {
    return 3;
  } else if (screenWidth > 600) {
    return 2;
  } else {
    return 2;
  }
}

double _calculateChildAspectRatio(double screenWidth) {
  if (screenWidth > 1200) {
    return 1.5;
  } else if (screenWidth > 800) {
    return 1.3;
  } else {
    return 1.0;
  }
}
