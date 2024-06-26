import 'dart:typed_data';

import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart' as pw;

class PrintingWidget extends StatelessWidget {
  const PrintingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PdfPreview(
          actionBarTheme: PdfActionBarTheme(
              textStyle: titleStyle.copyWith(color: white),
              iconColor: secondColor,
              backgroundColor: primaryColor),
          build: (format) {
            return generatePdf(format, "Test");
          }),
    );
  }

  Future<Uint8List> generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) =>
            pw.Column(children: [pw.Container(child: pw.Text("Test Text"))]),
      ),
    );

    return pdf.save();
  }
}
