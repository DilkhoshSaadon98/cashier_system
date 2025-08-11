import 'package:cashier_system/controller/catagories/catagories_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/handle_data_function_mobile.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/view/categories/widgets/categories_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesScreenMobile extends StatelessWidget {
  const CategoriesScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CatagoriesController());
    return Scaffold(
      appBar: customAppBarTitle(TextRoutes.viewCategories, true),
      backgroundColor: mobileScreenBackgroundColor,
      body: GetBuilder<CatagoriesController>(builder: (controller) {
        return checkDataMobile(
          controller.data.length,
          Container(
              color: white,
              height: Get.height,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: Get.width > 500 ? 3 : 2,
                      mainAxisSpacing: 15,
                      mainAxisExtent: 200,
                      crossAxisSpacing: 15),
                  itemCount: controller.data.length,
                  itemBuilder: (context, index) {
                    return categoriesCardWidget(controller, index, context);
                  })),
        );
      }),
    );
  }
}
