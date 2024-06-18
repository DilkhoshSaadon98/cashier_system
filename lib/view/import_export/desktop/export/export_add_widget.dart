import 'package:cashier_system/controller/imp_exp/export_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/shared/custom_divider.dart';
import 'package:cashier_system/core/shared/custom_formfield_global.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/view/import_export/shared/custom_drop_down_impexp.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAddExportWidget extends StatelessWidget {
  const CustomAddExportWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(ExportController());
    return GetBuilder<ExportController>(
        init: ExportController(),
        builder: (controller) {
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
              customSizedBox(10),
              CustomDropDownImpExp(
                title: controller.accountControllerName.text.isNotEmpty
                    ? controller.accountControllerName.text
                    : "Account".tr,
                contrllerId: controller.accountControllerId,
                contrllerName: controller.accountControllerName,
                listData: [
                  SelectedListItem(name: "Box".tr, value: "Box"),
                  SelectedListItem(name: "Employee".tr, value: "Employee"),
                  SelectedListItem(
                      name: "Export Money".tr, value: "Import Money"),
                  SelectedListItem(name: "Expenses".tr, value: "Expenses"),
                ],
                iconData: Icons.layers,
                color: white,
              ),
              customSizedBox(10),
              CustomDropDownImpExp(
                title: controller.userControllerName.text.isNotEmpty
                    ? controller.userControllerName.text
                    : "Supplier Name".tr,
                contrllerId: controller.userControllerId,
                contrllerName: controller.userControllerName,
                listData: controller.dropDownListUsers,
                iconData: Icons.layers,
                color: white,
              ),
              customSizedBox(10),
              CustomTextFormFieldGlobal(
                hinttext: '',
                iconData: Icons.date_range_outlined,
                labeltext: "Date",
                isNumber: true,
                borderColor: white,
                mycontroller: controller.dateController,
                onTap: () {
                  controller.selectDate(context, controller.dateController);
                },
                valid: (value) {
                  return validInput(value!, 0, 1000, "number");
                },
              ),
              customSizedBox(10),
              CustomTextFormFieldGlobal(
                hinttext: 'Amount ',
                iconData: Icons.attach_money,
                labeltext: "Amount ",
                isNumber: true,
                borderColor: white,
                mycontroller: controller.amountController,
                valid: (value) {
                  return validInput(value!, 0, 1000, "number");
                },
              ),
              customSizedBox(10),
              SizedBox(
                height: 50,
                child: CustomTextFormFieldGlobal(
                  hinttext: 'Note',
                  iconData: Icons.description_outlined,
                  labeltext: "Note",
                  isNumber: false,
                  mycontroller: controller.noteController,
                  borderColor: white,
                  valid: (value) {
                    return validInput(value!, 0, 1000, "number");
                  },
                ),
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
              customSizedBox(30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xff43766C),
                    radius: 25,
                    child: IconButton(
                        onPressed: () {
                          controller.addExportData();
                        },
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
