import 'package:cashier_system/controller/items/items_add_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/responsive/responisve_text_body.dart';
import 'package:cashier_system/core/shared/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_drop_down_search.dart';
import 'package:cashier_system/core/shared/custom_formfield_global.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddItems extends StatelessWidget {
  const AddItems({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AddItemsViewController());

    return Container(
      height: Get.height - 50,
      width: Get.width,
      color: white,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: GetBuilder<AddItemsViewController>(
        builder: (controller) {
          return SingleChildScrollView(
            child: Form(
              key: controller.formState,
              child: Column(
                children: [
                  SizedBox(
                    height: 700.h,
                    child: ListView.builder(
                      itemCount: controller.addItemList.length + 1,
                      itemBuilder: (context, index) {
                        if (index < 8) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customSizedBox(10),
                              Row(
                                children: [
                                  Text(
                                    controller.addItemList.keys
                                        .elementAt(index)
                                        .tr,
                                    style: titleStyle.copyWith(
                                      fontSize: responsivefontSize(Get.width),
                                    ),
                                  ),
                                  Text(
                                    " *",
                                    style: titleStyle.copyWith(
                                      color: Colors.red,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              customSizedBox(5),
                              CustomTextFormFieldGlobal(
                                mycontroller: controller.controllerList![index],
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
                                    1000,
                                    (index > 1 && index < 7) ? "number" : "",
                                  );
                                },
                                isNumber: false,
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customSizedBox(10),
                              Text(
                                "Items Types *".tr,
                                style: titleStyle.copyWith(
                                  fontSize: responsivefontSize(Get.width),
                                ),
                              ),
                              customSizedBox(5),
                              CustomDropDownSearch(
                                iconData: Icons.type_specimen,
                                title: 'Choose Type'.tr,
                                listData: controller.dropDownListTypes,
                                contrllerName: controller.typeName!,
                                contrllerId: controller.typeID!,
                                color: primaryColor,
                              ),
                              customSizedBox(10),
                              Row(
                                children: [
                                  Text(
                                    "Items Categories".tr,
                                    style: titleStyle.copyWith(
                                      fontSize: responsivefontSize(Get.width),
                                    ),
                                  ),
                                  Text(
                                    " *",
                                    style: titleStyle.copyWith(
                                      color: Colors.red,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              customSizedBox(5),
                              CustomDropDownSearch(
                                iconData: Icons.layers_outlined,
                                title: 'Choose Categories'.tr,
                                listData: controller.dropDownList,
                                contrllerName: controller.catName!,
                                contrllerId: controller.catID!,
                                color: primaryColor,
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                  customButtonGlobal(
                    () {
                      controller.addItems();
                    },
                    "Add Items",
                    Icons.add,
                    primaryColor,
                    Colors.white,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
