import 'package:cashier_system/controller/inventory/edit_import_export_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/custom_formfield_global.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/view/import_export/desktop/custom_drop_down_impexp.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditImportExportScreen extends StatelessWidget {
  const EditImportExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(EditImportExportController());
    return Scaffold(
      appBar: customAppBarTitle("Edit Data", true),
      body: Container(
        width: Get.width,
        height: Get.height,
        alignment: Alignment.center,
        child: GetBuilder<EditImportExportController>(builder: (controller) {
          return SizedBox(
            width: Get.width / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customSizedBox(10),
                CustomDropDownImpExp(
                  title: controller.accountControllerName.text.isNotEmpty
                      ? controller.accountControllerName.text
                      : "Account".tr,
                  contrllerId: controller.accountControllerId,
                  contrllerName: controller.accountControllerName,
                  listData: [
                    SelectedListItem(name: "Box", value: "Box"),
                    SelectedListItem(name: "Employee", value: "Employee"),
                    SelectedListItem(
                        name: "Import Money", value: "Import Money"),
                    SelectedListItem(name: "Expenses", value: "Expenses"),
                  ],
                  iconData: Icons.layers,
                  color: primaryColor,
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
                  color: primaryColor,
                ),
                customSizedBox(10),
                CustomTextFormFieldGlobal(
                  hinttext: '',
                  iconData: Icons.date_range_outlined,
                  labeltext: "Date",
                  isNumber: true,
                  borderColor: primaryColor,
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
                  borderColor: primaryColor,
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
                    borderColor: primaryColor,
                    valid: (value) {
                      return validInput(value!, 0, 1000, "number");
                    },
                  ),
                ),
                customSizedBox(30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xff43766C),
                      radius: 25,
                      child: IconButton(
                          onPressed: () async {
                            controller.dataTable == "Import"
                                ? await controller.editImportData()
                                : await controller.editExportData();
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
                          onPressed: () {
                            controller.dataTable == "Import"
                                ? controller.deleteData("tbl_import",
                                    "import_id = ${controller.dataId}")
                                : controller.deleteData("tbl_export",
                                    "export_id = ${controller.dataId}");
                          },
                          icon: const Icon(
                            Icons.delete_sweep_outlined,
                            color: white,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
