import 'package:cashier_system/controller/imp_exp/export_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/shared/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_divider.dart';
import 'package:cashier_system/core/shared/custom_formfield_global.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/view/import_export/components/custom_drop_down_impexp.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSearchExportWidget extends GetView<ExportController> {
  const CustomSearchExportWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(ExportController());
    return GetBuilder<ExportController>(builder: (controller) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              controller.selectedScreenTitle.tr,
              style: titleStyle.copyWith(color: white, fontSize: 20),
            ),
          ),
          customSizedBox(),
          CustomDropDownImpExp(
            title: controller.accountControllerName.text.isEmpty
                ? "Account".tr
                : controller.accountControllerName.text,
            contrllerId: controller.accountControllerId,
            contrllerName: controller.accountControllerName,
            listData: [
              SelectedListItem(name: "Box".tr, value: "Box"),
              SelectedListItem(name: "Employee".tr, value: "Employee"),
              SelectedListItem(name: "Export Money".tr, value: "Export Money"),
              SelectedListItem(name: "Expenses".tr, value: "Expenses"),
            ],
            iconData: Icons.layers,
            color: white,
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
            color: white,
          ),
          customSizedBox(),
          Text(
            "Invoice Number".tr,
            style: titleStyle.copyWith(color: white),
          ),
          SizedBox(
            height: 60,
            width: Get.width,
            child: Row(
              children: [
                Expanded(
                  child: CustomTextFormFieldGlobal(
                    hinttext: 'From',
                    iconData: Icons.numbers,
                    labeltext: "From",
                    isNumber: true,
                    borderColor: white,
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
                    borderColor: white,
                    valid: (value) {
                      return validInput(value!, 0, 1000, "number");
                    },
                  ),
                ),
              ],
            ),
          ),
          customSizedBox(),
          Text(
            "Date".tr,
            style: titleStyle.copyWith(color: white, fontSize: 16),
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
                  borderColor: white,
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
                  borderColor: white,
                  valid: (value) {
                    return validInput(value!, 0, 1000, "number");
                  },
                ),
              ),
            ],
          ),
          customSizedBox(5),
          customDivider(white),
          customSizedBox(5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Ballance".tr,
                style: titleStyle.copyWith(color: white, fontSize: 20),
              ),
              Text(
                formattingNumbers(controller.totalExportBallance),
                style: titleStyle.copyWith(color: white, fontSize: 20),
              ),
            ],
          ),
          customSizedBox(5),
          customButtonGlobal(() {
            controller.getexportData();
          }, "Search", Icons.search),
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
                    onPressed: () async {
                      await controller.deleteExportData();
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
