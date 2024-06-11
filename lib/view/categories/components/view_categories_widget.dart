import 'package:cashier_system/controller/catagories/catagories_view_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomShowCatagories extends StatelessWidget {
  const CustomShowCatagories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(CatagoriesController());
    return Container(
      color: white,
      height: Get.height,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: GetBuilder<CatagoriesController>(builder: (controller) {
        return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Get.width > 1200
                    ? 7
                    : Get.width > 900
                        ? 5
                        : Get.width > 500
                            ? 3
                            : 1,
                mainAxisSpacing: 15,
                childAspectRatio: Get.width > 1300
                    ? 0.7.h
                    : Get.width > 1000
                        ? 0.6.h
                        : Get.width > 500
                            ? 0.5
                            : 0.5,
                crossAxisSpacing: 15),
            itemCount: !controller.isSearch
                ? controller.data.length
                : controller.listdataSearch.length,
            itemBuilder: (context, index) {
              return SingleChildScrollView(
                child: GestureDetector(
                  onDoubleTap: () async {
                    await controller.deleteCategoriesData(
                        controller.data[index].categoriesId.toString());
                  },
                  onTap: () {
                    controller.goUpdate(controller.data[index]);
                  },
                  child: Container(
                    height: 175.h,
                    width: 175.w,
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryColor),
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customSizedBox(5),
                        const FlutterLogo(
                          size: 50,
                        ),
                        // imageUrl: !controller.isSearch
                        //     ? "${AppLink.imagestCategories}/${controller.data[index].categoriesImage}"
                        //     : "${AppLink.imagestCategories}/${controller.listdataSearch[index].categoriesImage}"),
                        Container(
                          width: Get.width,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              )),
                          child: Text(
                            !controller.isSearch
                                ? controller.data[index].categoriesName!
                                : controller
                                    .listdataSearch[index].categoriesName!,
                            style:
                                titleStyle.copyWith(color: white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      }),
    );
  }
}
