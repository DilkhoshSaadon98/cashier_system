import 'package:cashier_system/controller/imp_exp/export_controller.dart';
import 'package:cashier_system/controller/imp_exp/import_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/constant/routes.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/view/import_export/components/custom_expansion_tile.dart';
import 'package:cashier_system/view/import_export/components/export/export_add_widget.dart';
import 'package:cashier_system/view/import_export/components/export/export_search_widget.dart';
import 'package:cashier_system/view/import_export/components/export/export_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExportScreen extends StatelessWidget {
  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ExportController());
    return Scaffold(
      body: GetBuilder<ExportController>(builder: (controller) {
        return Row(
          children: [
            //! Left Side Import:
            const Expanded(flex: 6, child: ExportTableWidget()),
            //! Right Side Import:
            Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                      color: primaryColor,
                      border: Border.all(width: .5, color: primaryColor)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: ListView(
                    children: [
                      //! Header Side
                      CustomHeaderScreen(
                          title: 'Exports'.tr,
                          imagePath: AppImageAsset.importIcons,
                          root: () {
                            Get.offAndToNamed(AppRoute.exportScreen);
                          }),
                      customSizedBox(25),
                      //! ExpansionTile Import
                      CustomExpansionTileWidget(
                          expanded: false,
                          onTapSearch: () {
                            Get.offAndToNamed(AppRoute.importScreen);
                            controller.changeSelectedScreenTitle("Search");
                            controller.changeSelectedIndex(0);
                            ImportController importController =
                                Get.put(ImportController());
                            importController.getImportData();
                            controller.clearFileds();
                          },
                          onTapAdd: () {
                            Get.offAndToNamed(AppRoute.importScreen);
                            controller.changeSelectedScreenTitle("Add");
                            controller.changeSelectedIndex(1);
                            ImportController importController =
                                Get.put(ImportController());
                            importController.getImportData();
                            controller.clearFileds();
                          },
                          backColor: const Color(0xff135D66),
                          searchColor: const Color(0xff77B0AA),
                          addColor: white,
                          title: "Imports".tr),

                      customSizedBox(10),
                      //! ExpansionTile Export
                      CustomExpansionTileWidget(
                          expanded: true,
                          onTapSearch: () {
                            Get.offAndToNamed(AppRoute.exportScreen);
                            controller.changeSelectedScreenTitle("Search");
                            controller.changeSelectedIndex(0);
                            controller.clearFileds();
                          },
                          onTapAdd: () {
                            Get.offAndToNamed(AppRoute.exportScreen);
                            controller.changeSelectedScreenTitle("Add");
                            controller.changeSelectedIndex(1);
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
                          CustomSearchExportWidget(),
                          CustomAddExportWidget()
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
