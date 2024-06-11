import 'package:cashier_system/controller/items/items_update_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/shared/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_drop_down_search.dart';
import 'package:cashier_system/core/shared/custom_formfield_global.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UpdateItems extends StatelessWidget {
  const UpdateItems({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ItemsUpdateController());
    return Container(
        height: Get.height - 50,
        width: Get.width,
        color: white,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: GetBuilder<ItemsUpdateController>(builder: (controller) {
          return Form(
            key: controller.formState,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 650.h,
                    child: ListView.builder(
                        itemCount: controller.addItemList.length + 1,
                        itemBuilder: (context, index) {
                          return index < 8
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customSizedBox(),
                                    Row(
                                      children: [
                                        Text(
                                          controller.addItemList.keys
                                              .elementAt(index)
                                              .tr,
                                          style: titleStyle.copyWith(
                                            fontSize: 18.sp,
                                          ),
                                        ),
                                        Text(
                                          " *",
                                          style: titleStyle.copyWith(
                                              fontSize: 22.sp,
                                              color: Colors.red),
                                        ),
                                      ],
                                    ),
                                    customSizedBox(10),
                                    CustomTextFormFieldGlobal(
                                        mycontroller:
                                            controller.controllerList![index],
                                        hinttext: controller.addItemList.keys
                                            .elementAt(index),
                                        labeltext: controller.addItemList.keys
                                            .elementAt(index),
                                        iconData: controller.addItemList.values
                                            .elementAt(index),
                                        borderColor: primaryColor,
                                        valid: (value) {
                                          return validInput(
                                              value!,
                                              0,
                                              500,
                                              index > 2 && index < 7
                                                  ? "number"
                                                  : "");
                                        },
                                        isNumber: false)
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customSizedBox(),
                                    Row(
                                      children: [
                                        Text(
                                          "Items Type".tr,
                                          style: titleStyle.copyWith(
                                            fontSize: 18.sp,
                                          ),
                                        ),
                                        Text(
                                          " *",
                                          style: titleStyle.copyWith(
                                              fontSize: 22.sp,
                                              color: Colors.red),
                                        ),
                                      ],
                                    ),
                                    customSizedBox(10),
                                    CustomDropDownSearch(
                                      title: 'Choose Type',
                                      iconData: Icons.type_specimen_outlined,
                                      listData: controller.dropDownListTypes,
                                      contrllerName: controller.typeName!,
                                      contrllerId: controller.typeID!,
                                      color: primaryColor,
                                    ),
                                    customSizedBox(),
                                    Row(
                                      children: [
                                        Text(
                                          "Items Categories".tr,
                                          style: titleStyle.copyWith(
                                            fontSize: 18.sp,
                                          ),
                                        ),
                                        Text(
                                          " *",
                                          style: titleStyle.copyWith(
                                            color: Colors.red,
                                            fontSize: 22.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                    customSizedBox(10),
                                    CustomDropDownSearch(
                                      title: 'Choose Catagories',
                                      iconData: Icons.category_outlined,
                                      listData: controller.dropDownList,
                                      contrllerName: controller.catName!,
                                      contrllerId: controller.catID!,
                                      color: primaryColor,
                                    ),
                                  ],
                                );
                        }),
                  ),
                  customButtonGlobal(() {
                    controller.updateItems();
                  }, "Update Items", Icons.add, primaryColor, white)
                ],
              ),
            ),
          );
        }));
  }
}
