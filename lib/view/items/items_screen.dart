import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/constant/screen_routes.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/responsive/divide_screen_widget.dart';
import 'package:cashier_system/core/responsive/screen_builder.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/view/categories/widgets/add_category_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ItemsScreen extends StatelessWidget {
  const ItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map> data = [
      {
        'title': TextRoutes.viewItems,
        'image': AppImageAsset.itemsIcons,
        'on_tap': () {
          Get.toNamed(AppRoute.itemsViewScreen);
        }
      },
      {
        'title': TextRoutes.addItems,
        'image': AppImageAsset.addItems,
        'on_tap': () {
          Get.toNamed(AppRoute.itemsAddScreen);
        }
      },
      {
        'title': TextRoutes.viewCategories,
        'image': AppImageAsset.categorySvg,
        'on_tap': () {
          Get.toNamed(AppRoute.catagoriesScreen);
        }
      },
      {
        'title': TextRoutes.addCategories,
        'image': AppImageAsset.addCategory,
        'on_tap': () {
          showAddCategoryForm(context, false);
        }
      },
    ];
    return Scaffold(
      backgroundColor: white,
      body: ScreenBuilder(
        windows: DivideScreenWidget(
          showWidget: Center(
            child: SizedBox(
              width: 600.w,
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: 4,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  return customItemsCard(data[index]);
                },
              ),
            ),
          ),
          actionWidget: const Column(
            children: [
              CustomHeaderScreen(
                imagePath: AppImageAsset.itemsIcons,
                title: TextRoutes.items,
              )
            ],
          ),
        ),
        mobile: Scaffold(
          appBar: customAppBarTitle(TextRoutes.items, true),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SizedBox(
                width: 500.w,
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: 4,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  itemBuilder: (context, index) {
                    return customItemsCard(data[index]);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget customItemsCard(Map data) {
    return InkWell(
      onTap: data['on_tap'],
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(12.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                data['image'],
                semanticsLabel: 'Icon',
                color: white,
                width: 75,
                height: 75,
              ),
              SizedBox(height: 10.h),
              Text(
                data['title'].toString().tr,
                textAlign: TextAlign.center,
                style: titleStyle.copyWith(
                  color: white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
