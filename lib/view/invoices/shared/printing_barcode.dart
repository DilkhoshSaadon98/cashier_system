import 'package:cashier_system/controller/printer/invoice_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';

class PrintingBarcode extends StatelessWidget {
  const PrintingBarcode({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(InvoiceController());
    return GetBuilder<InvoiceController>(builder: (controller) {
      return PdfPreview(
        canChangeOrientation: false,
        canDebug: false,
        onError: (context, error) {
          return Text(error.toString());
        },
        dynamicLayout: true,
        loadingWidget: const CircularProgressIndicator(),
        useActions: true,
        enableScrollToPage: true,
        actionBarTheme: PdfActionBarTheme(
          textStyle: titleStyle.copyWith(color: white),
          iconColor: secondColor,
          backgroundColor: primaryColor,
        ),
        build: (format) {
          return controller.generateBarcode(
              controller.itemsBarcodeContrller.text.isEmpty
                  ? "Test Barcode"
                  : controller.itemsBarcodeContrller.text,
              controller.itemsNameContrller.text.isEmpty
                  ? "Test Item Name"
                  : controller.itemsNameContrller.text,
              controller.itemsPriceController.text.isEmpty
                  ? "3500"
                  : controller.itemsPriceController.text,
              int.tryParse(controller.numberOfPrintsController.text) ?? 1);
        },
      );
    });
  }
}
