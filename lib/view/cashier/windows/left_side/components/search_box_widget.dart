import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/view/cashier/windows/left_side/components/cashier_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBoxWidget extends StatelessWidget {
  const SearchBoxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CashierController>(builder: (controller) {
      return Expanded(
          child: SingleChildScrollView(
            child: Container(
                    decoration: BoxDecoration(
              color: white, borderRadius: BorderRadius.circular(10)),
                    child: CashierDropDownSearch(
            title: "Search Items".tr,
            contrllerId: controller.dropDownID!,
            contrllerName: controller.dropDownName!,
            listData: controller.dropDownList,
            iconData: Icons.search,
                    ),
                  ),
          ));
    });
  }
}
