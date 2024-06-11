import 'package:cashier_system/controller/items/items_update_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/constant/routes.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/view/items/components/custom_update_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ItemsUpdateScreen extends StatelessWidget {
  const ItemsUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ItemsUpdateController());
    return Scaffold(
      backgroundColor: primaryColor,
      body: GetBuilder<ItemsUpdateController>(builder: (controller) {
        return Row(
          children: [
            Expanded(
                flex: 9,
                child: Scaffold(
                  appBar: customAppBarTitle("Edit Items"),
                  body:
                      Container(color: thirdColor, child: const UpdateItems()),
                )),
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
                        root: () {},
                        title: "Items",
                      ),
                      customSizedBox(25),
                      customButtonGlobal(
                        () {
                          Get.offAndToNamed(AppRoute.itemsScreen);
                        },
                        "View Items",
                        Icons.visibility,
                        Colors.greenAccent,
                        black,
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
