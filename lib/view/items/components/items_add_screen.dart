import 'package:cashier_system/controller/items/items_add_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/constant/routes.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/custom_buttton_global.dart';
import 'package:cashier_system/view/items/components/custom_add_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ItemsAddScreen extends StatelessWidget {
  const ItemsAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AddItemsViewController());
    return Scaffold(
      backgroundColor: primaryColor,
      body: GetBuilder<AddItemsViewController>(builder: (controller) {
        return Row(
          children: [
            Expanded(
                flex: 7,
                child: Container(
                    color: thirdColor,
                    child: ListView(
                      children: [
                        customAppBarTitle('Add Items'),
                        const AddItems()
                      ],
                    ))),
            Expanded(
                flex: 2,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                  color: primaryColor,
                  child: Column(
                    children: [
                      CustomHeaderScreen(
                        imagePath: AppImageAsset.itemsIcons,
                        root: () {
                          Get.offAndToNamed(AppRoute.itemsScreen);
                        },
                        title: "Items",
                      ),
                      customSizedBox(25),
                      customButtonGlobal(
                        () {
                          Get.offAndToNamed(AppRoute.itemsScreen);
                        },
                        "View Items",
                        Icons.visibility,
                        const Color.fromARGB(255, 31, 178, 114),
                        black,
                      ),
                      customButtonGlobal(() {}, "Add Items",
                          Icons.add_box_outlined, whiteNeon, black),
                    ],
                  ),
                )),
          ],
        );
      }),
    );
  }
}
