import 'package:cashier_system/controller/catagories/catagories_add_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/shared/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_formfield_global.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddCatagories extends StatelessWidget {
  const AddCatagories({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AddCategoriesController());
    return GetBuilder<AddCategoriesController>(builder: (controller) {
      return Container(
          height: Get.height - 50,
          color: white,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Form(
            key: controller.formState,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categories Name'.tr,
                  style: titleStyle.copyWith(
                    fontSize: 20.sp,
                  ),
                ),
                customSizedBox(10),
                CustomTextFormFieldGlobal(
                    hinttext: 'Categories Name',
                    labeltext: "Categories Name",
                    mycontroller: controller.catagoriesName,
                    iconData: Icons.layers,
                    borderColor: primaryColor,
                    valid: (value) {
                      return validInput(value!, 0, 500, "");
                    },
                    isNumber: false),
                // customSizedBox(30),
                // Text(
                //   'Categories Image'.tr,
                //   style: titleStyle.copyWith(
                //     fontSize: 20.sp,
                //   ),
                // ),
                // Container(
                //   width: Get.width,
                //   alignment: Alignment.center,
                //   child: Stack(
                //     children: [
                //       CircleAvatar(
                //         radius: 100,
                //         backgroundColor: Colors.grey[200],
                //         child: controller.file != null
                //             ? Image.file(
                //                 controller.file!,
                //                 width: 125,
                //                 height: 125,
                //               )
                //             : SvgPicture.asset(
                //                 AppImageAsset.itemsIcons,
                //                 width: 75,
                //                 height: 75,
                //               ),
                //       ),
                //       IconButton(
                //         onPressed: () {
                //           controller.choseFile();
                //         },
                //         icon: Icon(
                //           Icons.add_a_photo,
                //           color: primaryColor,
                //           size: 30,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                const Spacer(),
                customButtonGlobal(() {
                  controller.addCategories();
                }, "Add", Icons.add, primaryColor, white)
              ],
            ),
          ));
    });
  }
}
