import 'package:cashier_system/controller/imp_exp/import_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/shared/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_divider.dart';
import 'package:cashier_system/core/shared/custom_formfield_global.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/view/import_export/shared/custom_drop_down_impexp.dart';
import 'package:cashier_system/view/import_export/mobile/export/view_export_data_mobile.dart';
import 'package:cashier_system/view/import_export/mobile/import/view_import_data_mobile.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSearchExportWidgetMobile extends GetView<ImportController> {
  const CustomSearchExportWidgetMobile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(ImportController());
    return GetBuilder<ImportController>(builder: (controller) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              controller.selectedScreenTitle.tr,
              style: titleStyle.copyWith(color: primaryColor, fontSize: 20),
            ),
          ),
          customSizedBox(5),
          CustomDropDownImpExp(
            title: controller.accountControllerName.text.isEmpty
                ? "Account".tr
                : controller.accountControllerName.text,
            contrllerId: controller.accountControllerId,
            contrllerName: controller.accountControllerName,
            listData: [
              SelectedListItem(name: "Box", value: "Box"),
              SelectedListItem(name: "Employee", value: "Employee"),
              SelectedListItem(name: "Export Money", value: "Export Money"),
              SelectedListItem(name: "Expenses", value: "Expenses"),
              SelectedListItem(name: "Cash Expenses", value: "Cash Expenses"),
            ],
            iconData: Icons.layers,
            color: primaryColor,
          ),
          customSizedBox(),
          CustomDropDownImpExp(
            title: controller.userControllerName.text.isEmpty
                ? "Supplier Name".tr
                : controller.userControllerName.text,
            contrllerId: controller.userControllerId,
            contrllerName: controller.userControllerName,
            listData: controller.dropDownListUsers,
            iconData: Icons.layers,
            color: primaryColor,
          ),
          customSizedBox(),
          Text(
            "Invoice Number".tr,
            style: titleStyle.copyWith(color: primaryColor),
          ),
          customSizedBox(5),
          Row(
            children: [
              Expanded(
                child: CustomTextFormFieldGlobal(
                  hinttext: 'From',
                  iconData: Icons.numbers,
                  labeltext: "From",
                  isNumber: true,
                  borderColor: primaryColor,
                  mycontroller: controller.noFromController,
                  valid: (value) {
                    return validInput(value!, 0, 1000, "number");
                  },
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: CustomTextFormFieldGlobal(
                  hinttext: 'To',
                  iconData: Icons.numbers,
                  labeltext: "To",
                  isNumber: true,
                  mycontroller: controller.noToController,
                  borderColor: primaryColor,
                  valid: (value) {
                    return validInput(value!, 0, 1000, "number");
                  },
                ),
              ),
            ],
          ),
          customSizedBox(5),
          Text(
            "Date".tr,
            style: titleStyle.copyWith(color: primaryColor, fontSize: 16),
          ),
          customSizedBox(5),
          Row(
            children: [
              Expanded(
                child: CustomTextFormFieldGlobal(
                  hinttext: 'From',
                  iconData: Icons.date_range,
                  labeltext: "From",
                  isNumber: true,
                  mycontroller: controller.dateFromController,
                  onTap: () {
                    controller.selectDate(
                        context, controller.dateFromController);
                  },
                  borderColor: primaryColor,
                  valid: (value) {
                    return validInput(value!, 0, 1000, "number");
                  },
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: CustomTextFormFieldGlobal(
                  hinttext: 'To',
                  iconData: Icons.date_range,
                  onTap: () {
                    controller.selectDate(context, controller.dateToController);
                  },
                  labeltext: "To",
                  isNumber: true,
                  mycontroller: controller.dateToController,
                  borderColor: primaryColor,
                  valid: (value) {
                    return validInput(value!, 0, 1000, "number");
                  },
                ),
              ),
            ],
          ),
          customSizedBox(5),
          customDivider(primaryColor),
          customSizedBox(5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Ballance".tr,
                style: titleStyle.copyWith(color: primaryColor, fontSize: 20),
              ),
              Text(
                formattingNumbers(controller.totalImportBallance),
                style: titleStyle.copyWith(color: primaryColor, fontSize: 20),
              ),
            ],
          ),
          customSizedBox(5),
          customButtonGlobal(() async {
            await controller.getImportData();
            Get.to(() => const ViewExportDataMobile());
          }, "Show Data", Icons.search, primaryColor, white),
          customSizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xff43766C),
                radius: 25,
                child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.save,
                      color: white,
                    )),
              ),
              CircleAvatar(
                backgroundColor: Colors.red,
                radius: 25,
                child: IconButton(
                    onPressed: () {
                      controller.deleteImportData();
                    },
                    icon: const Icon(
                      Icons.delete_sweep_outlined,
                      color: white,
                    )),
              ),
              CircleAvatar(
                  backgroundColor: thirdColor,
                  radius: 25,
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.print, color: white))),
            ],
          ),
        ],
      );
    });
  }
}
