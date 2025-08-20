import 'package:cashier_system/controller/printer/invoice_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/responsive/divide_screen_widget.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/drop_downs/drop_down_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SaleInvoiceScreen extends StatelessWidget {
  const SaleInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(InvoiceController());
    return Scaffold(
      body: DivideScreenWidget(
          showWidget: Container(),
          actionWidget: GetBuilder<InvoiceController>(builder: (controller) {
            return ListView(
              children: [
                const CustomHeaderScreen(
                  imagePath: AppImageAsset.saleInvoicesSvg,
                  title: TextRoutes.saleInvoice,
                  showBackButton: true,
                ),
                verticalGap(),
                DropDownMenu(
                  items: const [TextRoutes.a4Printer, TextRoutes.miniPrinter],
                  onChanged: (value) {
                    controller.changePrinter(value!);
                  },
                  selectedValue: controller.selectedPrinter,
                  contentColor: primaryColor,
                  fieldColor: white,
                ),
                verticalGap(),
                
              ],
            );
          })),
    );
  }
}
