import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget? customExportPDF() {
  Get.defaultDialog(
      title: "Export PDF".tr,
      titleStyle: titleStyle,
      middleText: "",
      content: Container(
        alignment: Alignment.topCenter,
        child: GetBuilder<CashierController>(builder: (controller) {
          return Column(
            children: [
              GestureDetector(
                onDoubleTap: () async {
                  String? selectedFolderPath;
                  String? selectedDirectory =
                      await FilePicker.platform.getDirectoryPath();
                  if (selectedDirectory != null) {
                    selectedFolderPath = selectedDirectory;
                    myServices.sharedPreferences
                        .setString("save_path", selectedFolderPath);
                    controller.update();
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        TextRoutes.selectPath.tr,
                        style: bodyStyle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        myServices.sharedPreferences.getString('save_path') ??
                            TextRoutes.emptyPath.tr,
                        style: bodyStyle,
                      ),
                    ),
                  ],
                ),
              ),
              verticalGap(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    TextRoutes.autoSave.tr,
                    style: bodyStyle,
                  ),
                  Switch(
                      value: myServices.systemSharedPreferences
                              .getBool("auto_print") ??
                          false,
                      onChanged: (val) {
                        controller.autoPrintChange(val);
                      })
                ],
              ),
              verticalGap(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    TextRoutes.openFile.tr,
                    style: bodyStyle,
                  ),
                  Checkbox(
                      value:
                          myServices.sharedPreferences.getBool("open_file") ??
                              false,
                      onChanged: (value) {
                        myServices.sharedPreferences
                            .setBool("open_file", value!);
                        controller.update();
                      })
                ],
              ),
              verticalGap(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    TextRoutes.saveFile.tr,
                    style: bodyStyle,
                  ),
                  Checkbox(
                      value:
                          myServices.sharedPreferences.getBool("save_file") ??
                              false,
                      onChanged: (value) {
                        myServices.sharedPreferences
                            .setBool("save_file", value!);
                        controller.update();
                      })
                ],
              ),
            ],
          );
        }),
      ));
  return null;
}
