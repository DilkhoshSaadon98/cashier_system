import 'package:cashier_system/controller/items/items_view_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/constant/routes.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/shared/custom_formfield_global.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/custom_buttton_global.dart';
import 'package:cashier_system/view/items/components/custom_show_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/constant/color.dart';

class ItemsScreen extends StatelessWidget {
  const ItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ItemsViewController());
    return Scaffold(
      backgroundColor: primaryColor,
      body: GetBuilder<ItemsViewController>(builder: (controller) {
        return Row(
          children: [
            Expanded(
                flex: 7,
                child: Container(
                    color: thirdColor, child: const CustomShowItems())),
            Expanded(
                flex: 2,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                  color: primaryColor,
                  child: ListView(
                    children: [
                      CustomHeaderScreen(
                        imagePath: AppImageAsset.itemsIcons,
                        root: () {
                          Get.offAllNamed(AppRoute.itemsScreen);
                        },
                        title: "Items".tr,
                      ),
                      customSizedBox(5),
                      customButtonGlobal(
                        () {
                          Get.offAndToNamed(AppRoute.itemsScreen);
                        },
                        "View Items",
                        Icons.visibility,
                        const Color.fromARGB(255, 31, 178, 114),
                        black,
                      ),
                      customButtonGlobal(() {
                        Get.offAndToNamed(AppRoute.itemsAddScreen);
                      }, "Add Items", Icons.add_box_outlined, whiteNeon, black),
                      customSizedBox(5),
                      Text(
                        "Search By".tr,
                        style: titleStyle.copyWith(color: white),
                      ),
                      customSizedBox(5),
                      Form(
                        child: SizedBox(
                          height: 350,
                          child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return customSizedBox(10);
                              },
                              itemCount: controller.itemsTitle.length,
                              itemBuilder: (context, index) {
                                return CustomTextFormFieldGlobal(
                                    mycontroller:
                                        controller.itemsController[index],
                                    hinttext: controller.itemsTitle[index],
                                    labeltext: controller.itemsTitle[index],
                                    iconData: Icons.search_outlined,
                                    valid: (value) {
                                      return validInput(value!, 0, 100, "");
                                    },
                                    borderColor: white,
                                    isNumber: false);
                              }),
                        ),
                      ),
                      customButtonGlobal(() {
                        controller.onSearchItems();
                      }, "Search", Icons.search, white, primaryColor),
                      customButtonGlobal(() {
                        controller.clearFileds();
                      }, "Clear Fileds", Icons.delete_forever, Colors.red,
                          white)
                    ],
                  ),
                )),
          ],
        );
      }),
    );
  }
}
