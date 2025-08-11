import 'package:cashier_system/controller/printer/invoice_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class PrintingWidget extends StatefulWidget {
  final Map headerData;
  final Map tableData;

  const PrintingWidget({
    super.key,
    required this.headerData,
    required this.tableData,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PrintingWidgetState createState() => _PrintingWidgetState();
}

class _PrintingWidgetState extends State<PrintingWidget> {
  @override
  Widget build(BuildContext context) {
    Get.put(InvoiceController());

    return Scaffold(
      backgroundColor: white,
      body: GetBuilder<InvoiceController>(builder: (controller) {
        return Column(
          children: [
            Expanded(
              child: PdfPreview(
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
                  if (controller.isA4Format) {
                    return controller.generateA4Pdf(
                        PdfPageFormat.a4,
                        {
                          "Customer Name": "Test Customer",
                          "Organizer Name": "Admin",
                          "Total Price": "25000",
                          "Number Of Items": "12",
                          "Customer Phone": "07510000000",
                          "Customer Address": "Text Address",
                          "Invoice number": "1564",
                          "Date": "15/12/2024",
                          "Discount": "5000",
                          "Taxes": "0",
                          "Payment": "Cash".tr
                        },
                        {
                          "#": List.generate(40, (index) => "${index + 1}"),
                          "Code": [
                            "A01",
                            "B02",
                            "C03",
                            "D04",
                            "A05",
                            "B06",
                            "C07",
                            "D08",
                            "A09",
                            "B10",
                            "C11",
                            "D12",
                            "A13",
                            "B14",
                            "C15",
                            "D16",
                            "A17",
                            "B18",
                            "C19",
                            "D20",
                            "C21",
                            "D22",
                            "A23",
                            "B24",
                            "C25",
                            "D26",
                            "A27",
                            "B28",
                            "C29",
                            "D30",
                            "C31",
                            "D32",
                            "A33",
                            "B34",
                            "C35",
                            "D36",
                            "A37",
                            "B38",
                            "C39",
                            "D40",
                          ],
                          "Name": [
                            "Product 1",
                            "Product 2",
                            "Product 3",
                            "Product 4",
                            "Product 5",
                            "Product 6",
                            "Product 7",
                            "Product 8",
                            "Product 9",
                            "Product 10",
                            "Product 11",
                            "Product 12",
                            "Product 13",
                            "Product 14",
                            "Product 15",
                            "Product 16",
                            "Product 17",
                            "Product 18",
                            "Product 19",
                            "Product 20",
                            "Product 21",
                            "Product 22",
                            "Product 23",
                            "Product 24",
                            "Product 25",
                            "Product 26",
                            "Product 27",
                            "Product 28",
                            "Product 29",
                            "Product 30",
                            "Product 30",
                            "Product 31",
                            "Product 32",
                            "Product 33",
                            "Product 34",
                            "Product 35",
                            "Product 36",
                            "Product 37",
                            "Product 38",
                            "Product 39",
                            "Product 40",
                          ],
                          "QTY": List.generate(
                              40, (index) => "${(index + 1) * 10}"),
                          "Price": List.generate(
                              40, (index) => "${(index + 1) * 5}.00"),
                          "Total Price": List.generate(
                              40, (index) => "${(index + 1) * 50}.00"),
                          "Type": List.generate(
                              40,
                              (index) =>
                                  "Type ${String.fromCharCode(65 + (index % 26))}"),
                        },
                        "bills");
                  }
                  if (controller.isA5Format) {
                    return controller.generateA5Pdf(
                        PdfPageFormat.a5,
                        {
                          "Customer Name": "Test Customer",
                          "Customer Phone": "07510407010",
                          "Customer Address": "Test Address",
                          "Date": "2024/10/24-02:23",
                          "Total Price": "500"
                        },
                        {
                          "#": List.generate(4, (index) => "${index + 1}"),
                          "Code": [
                            "A01",
                            "B02",
                            "C03",
                            "D04",
                          ],
                          "Name": [
                            "Product 1",
                            "Product 2",
                            "Product 3",
                            "Product 4",
                          ],
                          "QTY": List.generate(
                              4, (index) => "${(index + 1) * 10}"),
                          "Price": List.generate(
                              4, (index) => "${(index + 1) * 5}.00"),
                          "Total Price": List.generate(
                              4, (index) => "${(index + 1) * 50}.00"),
                          "Type": List.generate(
                              4,
                              (index) =>
                                  "Type ${String.fromCharCode(65 + (index % 26))}"),
                        },
                        "bills");
                  } else {
                    return controller.generateMiniRecivePdf(
                      format,
                      "",
                      {
                        "Customer Name": "Test Customer",
                        "Organizer Name": "Admin",
                        "Total Price": "25000",
                        "Number Of Items": "12",
                        "Customer Phone": "07510000000",
                        "Customer Address": "Text Address",
                        "Invoice number": "1564",
                        "Date": "15/12/2024",
                        "Discount": "5000",
                        "Taxes": "0",
                        "Payment": "Cash".tr
                      },
                      {
                        "#": List.generate(5, (index) => "${index + 1}"),
                        "Code": [
                          "A01",
                          "B02",
                          "C03",
                          "D04",
                          "A05",
                        ],
                        "Name": [
                          "العنصر 1",
                          "Product 2",
                          "Product 3",
                          "Product 4",
                          "Product 5",
                        ],
                        "QTY":
                            List.generate(5, (index) => "${(index + 1) * 10}"),
                        "Price":
                            List.generate(5, (index) => "${(index + 1) * 5}.0"),
                        "Total Price": List.generate(
                            5, (index) => "${(index + 1) * 50}.0"),
                        "Type": List.generate(
                            5,
                            (index) =>
                                "Type ${String.fromCharCode(65 + (index % 26))}"),
                      },
                    );
                  }
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
