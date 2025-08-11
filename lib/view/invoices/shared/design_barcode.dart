import 'package:cashier_system/controller/printer/invoice_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/shared/buttons/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_formfield_global.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/view/invoices/shared/custom_drop_down_items_invoice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class DesignBarcode extends StatelessWidget {
  final bool isWindows;
  const DesignBarcode({super.key, required this.isWindows});

  @override
  Widget build(BuildContext context) {
    Get.put(InvoiceController());
    return GetBuilder<InvoiceController>(builder: (controller) {
      return Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            CustomDropDownItemsInvoice(
              onTap: () {},
              hinttext: "Search",
              data: controller.dropDownList,
              priceController: controller.itemsPriceController,
              nameController: controller.itemsNameContrller,
              barcodeController: controller.itemsBarcodeContrller,
              codeController: controller.itemsCodeController,
              valid: (value) {
                return validInput(value!, 0, 200, "");
              },
              color: primaryColor,
              isNumber: false,
            ),
            verticalGap(10),
            CustomTextFormFieldGlobal(
              hinttext: "Barcode width",
              labeltext: "Barcode width",
              iconData: Icons.photo_size_select_large_outlined,
              valid: (value) {
                return validInput(value!, 0, 4, "number");
              },
              borderColor: primaryColor,
              onChanged: (value) {
                double newValue = double.tryParse(value) ?? 0.0;
                if (newValue > 0) {
                  myServices.sharedPreferences
                      .setString("barcode_width", newValue.toString());
                  controller.update();
                }
              },
              isNumber: true,
            ),
            verticalGap(10),
            CustomTextFormFieldGlobal(
              hinttext: 'Barcode height',
              labeltext: "Barcode height",
              iconData: Icons.photo_size_select_large_outlined,
              valid: (value) {
                return validInput(value!, 0, 4, "number");
              },
              borderColor: primaryColor,
              onChanged: (value) {
                double newValue = double.tryParse(value) ?? 0.0;
                if (newValue > 0) {
                  myServices.sharedPreferences
                      .setString("barcode_height", newValue.toString());
                  controller.update();
                }
              },
              isNumber: true,
            ),

            verticalGap(),
            // Number of Pcs Input
            CustomTextFormFieldGlobal(
              hinttext: "Number of prints",
              labeltext: "Number of prints",
              mycontroller: controller.numberOfPrintsController,
              iconData: Icons.layers,
              valid: (value) {
                return validInput(value!, 0, 10, "number");
              },
              borderColor: primaryColor,
              isNumber: true,
            ),
            verticalGap(),
            // Print Button
            customButtonGlobal(() async {
              var pdfData = await controller.generateBarcode(
                  controller.itemsBarcodeContrller.text.isEmpty
                      ? "Test Barcode"
                      : controller.itemsPriceController.text,
                  controller.itemsNameContrller.text.isEmpty
                      ? "Item Name"
                      : controller.itemsNameContrller.text,
                  controller.itemsPriceController.text.isEmpty
                      ? "3500"
                      : controller.itemsPriceController.text,
                  int.tryParse(controller.numberOfPrintsController.text) ?? 1);
              // ignore: use_build_context_synchronously

              if (myServices.sharedPreferences.getString("label_printer") ==
                  null) {
                // ignore: use_build_context_synchronously
                var url = await Printing.pickPrinter(context: context);
                myServices.sharedPreferences
                    .setString("label_printer", url!.name);
              }
              await Printing.directPrintPdf(
                  printer: Printer(
                      url: myServices.sharedPreferences
                          .getString("label_printer")!),
                  onLayout: (PdfPageFormat format) async => pdfData);
            }, "Print".tr, Icons.print, buttonColor, white),
            customButtonGlobal(() async {
              // ignore: use_build_context_synchronously
              var url = await Printing.pickPrinter(context: context);
              myServices.sharedPreferences
                  .setString("label_printer", url!.name);
            }, "Pick Printer".tr, Icons.search, white, primaryColor),
          ],
        ),
      );
    });
  }
}
