

import 'package:cashier_system/controller/items/units_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/handle_data_function_mobile.dart';
import 'package:cashier_system/view/units/widgets/units_card_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomShowUnits extends StatelessWidget {
  const CustomShowUnits({super.key});

  @override
  Widget build(BuildContext context) {
    int calculateCrossAxisCount(double width) {
      if (width >= 1000) return 5;
      if (width >= 700) return 4;
      if (width >= 500) return 3;
      if (width >= 300) return 2;
      return 1;
    }

    Get.put(UnitsController());

    return GetBuilder<UnitsController>(builder: (controller) {
      return checkDataMobile(
        controller.unitsData.length,
        Container(
          color: white,
          height: Get.height,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return GridView.builder(
                itemCount: controller.unitsData.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: calculateCrossAxisCount(constraints.maxWidth),
                  mainAxisExtent: 200,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemBuilder: (_, index) {
                  return unitsCardWidget(controller, index, context);
                },
              );
            },
          ),
        ),
      );
    });
  }
}
