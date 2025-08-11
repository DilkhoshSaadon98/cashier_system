import 'package:cashier_system/controller/home/home_controller.dart';
import 'package:cashier_system/view/home/widgets/home_card_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Widget buildGridViewMobile() {
  return Align(
    alignment: Alignment.center,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: Get.width > 600 ? 600 : Get.width,
        ),
        child: GetBuilder<HomeController>(
          builder: (controller) {
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
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
      ),
    ),
  );
}
