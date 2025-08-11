import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/dialogs/custom_snack_bar.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'dart:async';

import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

class PrinterController extends GetxController {
  bool isConnected = false;
  String errorMessage = '';
  bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";
  @override
  void onInit() {
    super.onInit();
    _initializePrinter();
  }

  Future<bool?> bindingPrinter() async {
    try {
      final bool result = await SunmiPrinter.bindingPrinter() ?? false;
      return result;
    } on MissingPluginException catch (e) {
      showErrorDialog("$e",
          title: "Error", message: "Error during connecting to printer.");
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error during connecting printer.");
    } finally {
      update(); // Update UI if necessary
    }
    return null;
  }

//? Initialize Printer:
  Future<void> _initializePrinter() async {
    try {
      bindingPrinter().then((bool? isBind) async {
        SunmiPrinter.paperSize().then((int size) {
          paperSize = size;
          update();
        });

        SunmiPrinter.printerVersion().then((String version) {
          printerVersion = version;
          update();
        });

        SunmiPrinter.serialNumber().then((String serial) {
          serialNumber = serial;
        });

        printBinded = isBind!;
        update();
      });
    } catch (err) {
      errorMessage = err.toString();
    }
    update();
  }

  // Function to print simple text with custom styles
  Future<void> printText(String content, SunmiStyle style) async {
    try {
      if (isConnected) {
        await SunmiPrinter.startTransactionPrint(true);
        await SunmiPrinter.printText(content, style: style);
        await SunmiPrinter.lineWrap(1);
        await SunmiPrinter.exitTransactionPrint(true);
      } else {
        errorMessage = "Printer is not connected.";
      }
    } catch (err) {
      errorMessage = err.toString();
    } finally {
      update();
    }
  }

//? Barcode Printer:
  Future<void> printBarcode(String? text, int? width, int? height,
      String? itemName, String? itemPrice, int printQuantity) async {
    await SunmiPrinter.initPrinter();
    int size = await SunmiPrinter.paperSize();
    customSnackBar("Hint", size.toString(), true);
    for (int i = 0; i < printQuantity; i++) {
      await SunmiPrinter.printBarCode(
        text ?? '12345678',
        barcodeType: SunmiBarcodeType.CODE128,
        textPosition: SunmiBarcodeTextPos.NO_TEXT,
        height: height ?? 30,
      );
      await SunmiPrinter.printRow(
        cols: [
          ColumnMaker(
            text: itemName ?? "Unknown Item",
            width: size == 20 ? 20 : 30,
            align: SunmiPrintAlign.CENTER,
          ),
        ],
      );
      await SunmiPrinter.printRow(
        cols: [
          ColumnMaker(
            text: 'Price:',
            width: 15,
            align: SunmiPrintAlign.LEFT,
          ),
          ColumnMaker(
            text: itemPrice ?? "0.00",
            width: size == 20 ? 15 : 20,
            align: SunmiPrintAlign.RIGHT,
          ),
        ],
      );
      await SunmiPrinter.lineWrap(2);
    }
    await SunmiPrinter.startTransactionPrint(true);
  }

  Future<Uint8List> readFileBytes(String path) async {
    ByteData fileData = await rootBundle.load(path);
    Uint8List fileUnit8List = fileData.buffer
        .asUint8List(fileData.offsetInBytes, fileData.lengthInBytes);
    return fileUnit8List;
  }

  Future<Uint8List> getImageFromAsset(String iconPath) async {
    return await readFileBytes(iconPath);
  }

  Future<void> printTable(
    List<String> headers,
    List<String> columns,
    Map<dynamic, dynamic> headersData,
    Map<String, List<dynamic>> tableData,
  ) async {
    try {
      await SunmiPrinter.initPrinter();
      //? Image Print if Exist:
      if (myServices.sharedPreferences.getString('miniHeaderFilePath') !=
              null &&
          myServices.sharedPreferences.getBool('show_mini_image') == true) {
        // String? imagePath =
        //     myServices.sharedPreferences.getString('miniHeaderFilePath');

        // Fetch image bytes from the given file path
        Uint8List byte = await getImageFromAsset("assets/ferminus_logo.png");

        // Set the alignment for printing the image
        await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);

        // Start the print transaction
        await SunmiPrinter.startTransactionPrint(true);

        // Print the image
        await SunmiPrinter.printImage(byte);

        // End the print transaction
        await SunmiPrinter.line();
      }

      //? Header Section Print
      for (String header in headers) {
        String data = headersData[header] ?? 'N/A';
        await SunmiPrinter.printText(
          "$header: $data\n",
          style: SunmiStyle(
            fontSize: SunmiFontSize.MD,
            align: SunmiPrintAlign.LEFT,
          ),
        );
      }
      await SunmiPrinter.line();
      //? Print Table:

      if (myServices.sharedPreferences.getBool('group_layout') ?? true) {
        int rowCount = tableData[columns[0]]?.length ?? 0;
        for (int i = 0; i < rowCount; i++) {
          for (String column in columns) {
            String value = tableData[column]?[i]?.toString() ?? '';
            await SunmiPrinter.printText(
              "$column: $value",
              style: SunmiStyle(
                fontSize: SunmiFontSize.MD,
                align: SunmiPrintAlign.LEFT,
              ),
            );
          }
          await SunmiPrinter.line();
        }
      } else {
        int rowCount = tableData[columns[0]]?.length ?? 0;

        for (int i = 0; i < rowCount; i++) {
          String name = tableData['Name']?[i]?.toString() ?? '';
          String qty = tableData['QTY']?[i]?.toString() ?? '';
          String price = tableData['Price']?[i]?.toString() ?? '';
          if (i == 0) {
            await SunmiPrinter.printRow(
              cols: [
                ColumnMaker(
                  text: "Name",
                  width: 10,
                  align: SunmiPrintAlign.LEFT,
                ),
                ColumnMaker(
                  text: "QTY",
                  width: 5,
                  align: SunmiPrintAlign.CENTER,
                ),
                ColumnMaker(
                  text: "Price",
                  width: 10,
                  align: SunmiPrintAlign.RIGHT,
                ),
              ],
            );
            await SunmiPrinter.line(ch: "-", len: 31);
          }
          await SunmiPrinter.printRow(
            cols: [
              ColumnMaker(
                text: name,
                width: 10,
                align: SunmiPrintAlign.LEFT,
              ),
              ColumnMaker(
                text: qty,
                width: 5,
                align: SunmiPrintAlign.CENTER,
              ),
              ColumnMaker(
                text: price,
                width: 10,
                align: SunmiPrintAlign.RIGHT,
              ),
            ],
          );
          await SunmiPrinter.line(ch: ".", len: 31);
        }
      }
      await SunmiPrinter.printText(
        "Discount: ${headersData['Discount']} IQD",
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
          align: SunmiPrintAlign.LEFT,
        ),
      );
      await SunmiPrinter.printText(
        "Taxes: ${headersData['Taxes']} IQD",
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
          align: SunmiPrintAlign.LEFT,
        ),
      );
      await SunmiPrinter.printText(
        "Total Price: ${headersData['Total Price']} IQD",
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
          align: SunmiPrintAlign.LEFT,
        ),
      );
      await SunmiPrinter.line();
      await SunmiPrinter.printText(
        "Developed by MR-ROBOT company",
        style: SunmiStyle(
          fontSize: SunmiFontSize.XS,
          align: SunmiPrintAlign.CENTER,
        ),
      );
      await SunmiPrinter.line();
      await SunmiPrinter.lineWrap(2);
      await SunmiPrinter.startTransactionPrint(true);
    } catch (err) {
      errorMessage = err.toString();
    } finally {
      update();
    }
  }
}
