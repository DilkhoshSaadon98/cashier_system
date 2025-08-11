import 'package:cashier_system/controller/catagories/catagories_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/responsive/divide_screen_widget.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_search_widget.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/buttons/custom_buttton_global.dart';
import 'package:cashier_system/view/categories/widgets/view_categories_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesAddScreenWindows extends StatelessWidget {
  const CategoriesAddScreenWindows({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CatagoriesController());
    return Scaffold(
      backgroundColor: primaryColor,
      body: GetBuilder<CatagoriesController>(builder: (controller) {
        return DivideScreenWidget(
          //! View Categories
          showWidget: ListView(
            children: [
              customAppBarTitle(TextRoutes.viewCategories),
              const CustomShowCatagories(),
            ],
          ),
          actionWidget: ListView(
            children: [
              //! Custom Header:
              CustomHeaderScreen(
                imagePath: AppImageAsset.itemsIcons,
                showBackButton: true,
                title: TextRoutes.categories.tr,
              ),
              verticalGap(),

              customButtonGlobal(() {}, TextRoutes.addCategories,
                  Icons.add_box_outlined, white, primaryColor),
              verticalGap(),
              CustomSearchField(
                borderColor: white,
                hinttext: TextRoutes.searchInCatagories,
                iconData: Icons.search,
                mycontroller: controller.search,
                onChanged: (val) {
                  controller.onSearchItems();
                },
                isNumber: false,
                labeltext: TextRoutes.search,
                valid: (value) {
                  return validInput(value!, 3, 100, '');
                },
              )
            ],
          ),
        );
      }),
    );
  }
}
