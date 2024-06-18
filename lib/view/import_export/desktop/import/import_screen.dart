import 'package:cashier_system/controller/imp_exp/export_controller.dart';
import 'package:cashier_system/controller/imp_exp/import_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/constant/routes.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/view/import_export/shared/custom_expansion_tile.dart';
import 'package:cashier_system/view/import_export/desktop/import/import_add_widget.dart';
import 'package:cashier_system/view/import_export/desktop/import/import_search_widget.dart';
import 'package:cashier_system/view/import_export/desktop/import/import_table_widget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImportScreen extends StatelessWidget {
  const ImportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ImportController());
    return Scaffold(
      body: GetBuilder<ImportController>(builder: (controller) {
        return Row(
          children: [
            //! Left Side Import:
            const Expanded(flex: 6, child: ImportTableWidget()),
            //! Right Side Import:
            Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                      color: primaryColor,
                      border: Border.all(width: .5, color: primaryColor)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: ListView(
                    children: [
                      //! Header Side
                      CustomHeaderScreen(
                          title: 'Imports'.tr,
                          imagePath: AppImageAsset.importIcons,
                          root: () {
                            Get.offAndToNamed(AppRoute.importScreen);
                          }),
                      customSizedBox(),
                      //! ExpansionTile Import
                      CustomExpansionTileWidget(
                          expanded: false,
                          onTapSearch: () {
                            controller.changeSelectedScreenTitle("Search");
                            controller.changeSelectedIndex(0);
                            controller.getImportData();
                            controller.clearFileds();
                          },
                          onTapAdd: () {
                            controller.changeSelectedScreenTitle("Add");
                            controller.changeSelectedIndex(1);
                            controller.clearFileds();
                          },
                          backColor: const Color(0xff135D66),
                          searchColor: const Color(0xff77B0AA),
                          addColor: white,
                          title: "Imports".tr),
                      customSizedBox(10),
                      //! ExpansionTile Export
                      CustomExpansionTileWidget(
                          expanded: false,
                          onTapSearch: () {
                            Get.offAndToNamed(AppRoute.exportScreen);
                            controller.changeSelectedScreenTitle("Search");
                            controller.changeSelectedIndex(0);
                            ExportController exportController =
                                Get.put(ExportController());
                            exportController.getexportData();
                            controller.clearFileds();
                          },
                          onTapAdd: () {
                            Get.offAndToNamed(AppRoute.exportScreen);
                            controller.changeSelectedScreenTitle("Add");
                            controller.changeSelectedIndex(1);
                            ExportController exportController =
                                Get.put(ExportController());
                            exportController.getexportData();
                            controller.clearFileds();
                          },
                          backColor: const Color(0xff1B4242),
                          searchColor: const Color(0xff5C8374),
                          addColor: white,
                          title: "Exports".tr),
                      customSizedBox(),
                      IndexedStack(
                        index: controller.seslectedIndex,
                        children: const [
                          CustomSearchImportWidget(),
                          CustomAddImportWidget()
                        ],
                      )
                    ],
                  ),
                )),
          ],
        );
      }),
    );
  }
}
