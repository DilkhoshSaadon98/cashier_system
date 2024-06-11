import 'package:cashier_system/controller/imp_exp/import_export_controller.dart';
import 'package:cashier_system/view/import_export/components/import/import_screen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImportExportScreen extends StatelessWidget {
  const ImportExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ImportExportController());
    return const Scaffold(
      body:ImportScreen()
     
    );
  }
}
