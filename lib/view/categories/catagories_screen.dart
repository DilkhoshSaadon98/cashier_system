import 'package:cashier_system/controller/catagories/catagories_view_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/constant/routes.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_search_widget.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/custom_buttton_global.dart';
import 'package:cashier_system/view/categories/components/view_categories_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CatagoriesScreen extends StatelessWidget {
  const CatagoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CatagoriesController());
    return Scaffold(
      backgroundColor: primaryColor,
      body: GetBuilder<CatagoriesController>(builder: (controller) {
        return Row(
          children: [
            //! View Categories
            Expanded(
                flex: 6,
                child: ListView(
                  children: [
                    customAppBarTitle('View Categories'),
                    const CustomShowCatagories(),
                  ],
                )),
            Expanded(
                flex: 2,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                  color: primaryColor,
                  child: ListView(
                    children: [
                      //! Custom Header:
                      CustomHeaderScreen(
                        imagePath: AppImageAsset.itemsIcons,
                        root: () {},
                        title: 'Catagories'.tr,
                      ),
                      customSizedBox(25),
                      customButtonGlobal(
                        () {},
                        "View Categories",
                        Icons.visibility,
                        const Color.fromARGB(255, 31, 178, 114),
                        black,
                      ),
                      customButtonGlobal(() {
                        Get.offAndToNamed(AppRoute.categoriesAddScreen);
                      }, "Add Categories", Icons.add_box_outlined, whiteNeon,
                          black),
                      customSizedBox(),
                      CustomSearchField(
                        borderColor: whiteNeon,
                        hinttext: "Search in Catagories . . .",
                        iconData: Icons.search,
                        mycontroller: controller.search,
                        onChanged: (val) {
                          controller.onSearchItems();
                          // controller.checkSearch(val);
                        },
                        isNumber: false,
                        labeltext: "Search",
                        valid: (value) {
                          return validInput(value!, 3, 100, '');
                        },
                      ),
                    ],
                  ),
                )),
          ],
        );
      }),
    );
  }
}
