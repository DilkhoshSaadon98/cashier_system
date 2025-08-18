import 'dart:async';
import 'dart:io';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/dialogs/custom_snack_bar.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/core/functions/change_direction.dart';
import 'package:cashier_system/core/functions/upload_file.dart';
import 'package:cashier_system/data/model/items_model.dart';
import 'package:cashier_system/data/model/locale/custom_selected_list_items.dart';
import 'package:cashier_system/core/class/sqldb.dart';
import 'package:cashier_system/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class InvoiceController extends GetxController {
  Color currentColor =
      Color(myServices.sharedPreferences.getInt('selected_color') ??
          // ignore: deprecated_member_use
          primaryColor.value);
  double? barcodeWidth;
  double? barcodeHeight;
  int selectedIndex = 0;
  void changeIndex(int index) {
    if (index != 2) {
      selectedIndex = index;
      update();
    }
  }

  //?Expanded List:
  bool isSelectPrinterExpanded = false;
  bool isA4SettingExpanded = false;
  bool isMiniPrinterSettingExpanded = false;
  isSelectPrinterExpandedChanged() {
    isSelectPrinterExpanded = !isSelectPrinterExpanded;
    update();
  }

  isA4SettingExpandedChanged() {
    isA4SettingExpanded = !isA4SettingExpanded;
    update();
  }

  isMiniPrinterSettingExpandedChanged() {
    isMiniPrinterSettingExpanded = !isMiniPrinterSettingExpanded;
    update();
  }

  bool autoPrint = true;

  void autoPrintChange(value) {
    autoPrint = value;
    myServices.systemSharedPreferences.setBool("auto_print", value);
    update();
  }

  String selectedHeaderImage = "";
  double headerHeight = 25;
  double footerHeight = 35;
  String? selectedPrinters =
      myServices.sharedPreferences.getString("selected_printer") ??
          "A4 Printer";
  PdfPageFormat? pdfPageFormat;
  PdfPageFormat? pdfMiniPageFormat;
  TextEditingController reciveSizeControllerName = TextEditingController();
  TextEditingController reciveSizeControllerValue = TextEditingController();
  TextEditingController miniReciveSizeControllerValue = TextEditingController();
  TextEditingController miniReciveSizeControllerName = TextEditingController();
  TextEditingController miniReciveHeighController = TextEditingController();
  TextEditingController itemsPriceController = TextEditingController();
  TextEditingController itemsCodeController = TextEditingController();
  TextEditingController itemsNameContrller = TextEditingController();
  TextEditingController itemsBarcodeContrller = TextEditingController();
  TextEditingController numberOfPrintsController = TextEditingController();
  //* Items Store Data:
  List<CustomSelectedListItems> dropDownList = [];
  List<ItemsModel> listDataSearch = [];
  //* Show header images data:
  //bool showHeaderForAllPage = false;
  bool showA4HeadersImage = true;
  bool? showMiniReciveHeadersImage;
  int groupValueState = 1;
  int? groupValuePaperSize;
  //* Store headers footer files:
  File? footerFile;
  File? a4HeaderFile;
  File? miniHeaderFile;
  //*  Image Sizes
  Size? imageSizeFuture = const Size(0, 0);
  Size? miniImageSizeFuture = const Size(0, 0);
  //* Check Paper State:
  bool isA4Format = true;
  bool isA5Format = false;
  bool isASunmiFormat = false;
  bool isXPrinterFormat = false;
  //* Header and Column (title , state):
  //? Table Columns
  List<String> tablesTileTitle = [
    "Code",
    "Name",
    "QTY",
    "Price",
    "Total Price",
    "Type",
  ];
  List<bool> tablesTileState = [
    true,
    true,
    false,
    false,
    false,
    false,
  ];

  //? Headers:
  List<String> headersTitle = [
    "Customer Name",
    "Invoice number",
    "Customer Phone",
    "Customer Address",
    "Number Of Items",
    "Date",
    "Organizer Name",
    "Total Price",
    "Discount",
    "Taxes",
    "Payment",
  ];
  List<bool> headersState = [
    true,
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  //? Footers:
  List<String> footersTitle = [
    "Customer Name",
    "Invoice number",
    "Customer Phone",
    "Customer Address",
    "Number Of Items",
    "Date",
    "Organizer Name",
    "Total Price",
    "Discount",
    "Taxes",
    "Payment",
  ];
  List<bool> footersState = [
    true,
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  //? Set tile state:
  void setHeadersTitleState(int index, bool value) {
    headersState[index] = value;
    savePreferences();
    update();
  }

  void setFootersTitleState(int index, bool value) {
    footersState[index] = value;
    savePreferences();
    update();
  }

  void setTablesTileState(int index, bool value) {
    tablesTileState[index] = value;
    savePreferences();
    update();
  }

  List<String> get selectedHeaders {
    List<String> selected = [];
    for (int i = 0; i < headersState.length; i++) {
      if (headersState[i]) {
        selected.add(headersTitle[i]);
      }
    }
    return selected;
  }

  List<String> get selectedFooters {
    List<String> selected = [];
    for (int i = 0; i < footersTitle.length; i++) {
      if (footersState[i]) {
        selected.add(footersTitle[i]);
      }
    }
    return selected;
  }

  List<String> get selectedColumns {
    List<String> selected = ["#"];
    for (int i = 0; i < tablesTileState.length; i++) {
      if (tablesTileState[i]) {
        selected.add(tablesTileTitle[i]);
      }
    }
    return selected;
  }

  //? showA4HeaderImage
  void showA4HeaderImage(bool value) {
    showA4HeadersImage = value;
    myServices.sharedPreferences.setBool("show_a4_image", showA4HeadersImage);
    update();
  }

//? showMiniReciveHeaderImage
  void showMiniReciveHeaderImage(bool value) {
    showMiniReciveHeadersImage = value;
    myServices.sharedPreferences
        .setBool("show_mini_image", showMiniReciveHeadersImage!);
    update();
  }

//? showMiniReciveHeaderImage
  void switchPrinterLayout(int value) {
    groupValueState = value;
    myServices.sharedPreferences
        .setBool("group_layout", groupValueState == 1 ? true : false);
    update();
  }

  //? switchMiniPrinterPaperSize:
  void switchMiniPrinterPaperSize(int value) {
    groupValuePaperSize = value;
    myServices.sharedPreferences
        .setBool("paper_size_80", groupValuePaperSize == 1 ? true : false);
    update();
  }

//? Get Items For Search;
  Future<void> getItems() async {
    SqlDb sqlDb = SqlDb();
    try {
      var response = await sqlDb.getAllData("itemsView");
      if (response['status'] == "success") {
        listDataSearch.clear();
        dropDownList.clear();
        List responsedata = response['data'];
        listDataSearch.addAll(responsedata.map((e) => ItemsModel.fromMap(e)));
        for (int i = 0; i < listDataSearch.length; i++) {
          dropDownList.add(CustomSelectedListItems(
              name: listDataSearch[i].itemsName,
              desc:  listDataSearch[i].itemsName,
              value: listDataSearch[i].itemsId.toString(),
              price: listDataSearch[i].itemsSellingPrice.toString(),
              type: listDataSearch[i].itemsBarcode));
        }
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error fetching items");
    } finally {
      update();
    }
  }

  Future<void> saveColor(Color color) async {
    currentColor = color;
    savePreferences();
  }

  //? Load and refresh header parts
  void loadHeaderParts() async {
    if (a4HeaderFile == null) {
      String? a4HeaderFilePath =
          myServices.sharedPreferences.getString('a4HeaderFilePath');
      if (a4HeaderFilePath != null && File(a4HeaderFilePath).existsSync()) {
        a4HeaderFile = File(a4HeaderFilePath);
        imageSizeFuture = await getImageSize(FileImage(a4HeaderFile!));
      }
    }

    // Load Mini Receipt Header Image
    if (miniHeaderFile == null) {
      String? miniHeaderFilePath =
          myServices.sharedPreferences.getString('miniHeaderFilePath');
      if (miniHeaderFilePath != null && File(miniHeaderFilePath).existsSync()) {
        miniHeaderFile = File(miniHeaderFilePath);
        miniImageSizeFuture = await getImageSize(FileImage(miniHeaderFile!));
      }
    }

    // Load Footer Image
    if (footerFile == null) {
      String? footerFilePath =
          myServices.sharedPreferences.getString('footerFilePath');
      if (footerFilePath != null && File(footerFilePath).existsSync()) {
        footerFile = File(footerFilePath);
      }
    }

    // Calculate Header Height Based on Selected Columns
    headerListHeight();

    // Trigger a UI refresh
    update();
  }

  //? Change Invoice Page size if (A4 format is true);
  void changeInvoicePageSize(String value) {
    switch (value) {
      case "A3":
        pdfPageFormat = PdfPageFormat.a3;
        break;
      case "A4":
        pdfPageFormat = PdfPageFormat.a4;
        break;
      case "A5":
        pdfPageFormat = PdfPageFormat.a5;
        break;
      case "A6":
        pdfPageFormat = PdfPageFormat.a6;
        break;
      default:
        pdfPageFormat = PdfPageFormat.a4;
    }
    myServices.sharedPreferences.setString("invoicePageSize", value);
    update();
  }

  void changePrinter(String printer) {
    selectedPrinters = printer;
    savePreferences();
    switchPrinter();
    update();
  }

  void pickPrinter() async {
    var url = await Printing.pickPrinter(context: navigatorKey.currentContext!);
    myServices.sharedPreferences.setString("printer_url", url!.name);
  }

//? Headers data height:
  void headerListHeight() {
    if (selectedHeaders.isEmpty) {
      headerHeight = 0.0;
    } else {
      // Divide selectedHeaders into rows of 3 items per row
      headerHeight = 25 + ((selectedHeaders.length - 1) ~/ 3) * 25;
      savePreferences();
    }
    update();
  }

  //? Footer data height:
  void footerListHeight() {
    if (selectedFooters.isEmpty) {
      footerHeight = 0.0;
    } else {
      footerHeight = 25.0 + ((selectedFooters.length - 1) ~/ 2) * 25.0;
      savePreferences();
    }
    update();
  }

//? get image Size :
  Future<Size> getImageSize(ImageProvider imageProvider) async {
    final Completer<Size> completer = Completer<Size>();
    final ImageStreamListener listener =
        ImageStreamListener((ImageInfo info, bool _) {
      final Size imageSize = Size(
        info.image.width.toDouble(),
        info.image.height.toDouble(),
      );
      completer.complete(imageSize);
    });

    final ImageStream imageStream =
        imageProvider.resolve(const ImageConfiguration());
    imageStream.addListener(listener);

    return completer.future;
  }

//? Choose Header Image
  void chosea4HeaderFile() async {
    a4HeaderFile = await fileUploadGallery();
    if (a4HeaderFile != null) {
      ImageProvider imageProvider = FileImage(a4HeaderFile!);
      imageSizeFuture = await getImageSize(imageProvider);
      savePreferences();
      update();
    }
  }

  void removeA4HeaderFile() async {
    myServices.sharedPreferences.remove("a4HeaderFilePath");
    a4HeaderFile!.delete();
    loadPreferences();
    update();
  }

//? Choose Mini recive Image
  void chooseMiniReciveHeaderFile() async {
    miniHeaderFile = await fileUploadGallery();
    if (miniHeaderFile != null) {
      ImageProvider imageProvider = FileImage(miniHeaderFile!);
      miniImageSizeFuture = await getImageSize(imageProvider);
      savePreferences();
      update();
    }
  }

  void removeMiniReciveHeaderFile() async {
    myServices.sharedPreferences.remove("miniHeaderFilePath");
    miniHeaderFile!.delete();
    loadPreferences();
    update();
  }

//? Choose Footer File:
  void choseFooterFile() async {
    footerFile = await fileUploadGallery();
    savePreferences();
    update();
  }

  //? Save local data:
  void savePreferences() {
    myServices.sharedPreferences.setStringList(
        'headers_state', headersState.map((e) => e.toString()).toList());
    myServices.sharedPreferences.setStringList(
        'footers_state', footersState.map((e) => e.toString()).toList());
    myServices.sharedPreferences.setStringList(
        'tables_state', tablesTileState.map((e) => e.toString()).toList());
    myServices.sharedPreferences
        .setString('selected_printer', selectedPrinters ?? "A4 Printer");
    if (a4HeaderFile != null) {
      myServices.sharedPreferences
          .setString('a4HeaderFilePath', a4HeaderFile!.path);
    }
    if (miniHeaderFile != null) {
      myServices.sharedPreferences
          .setString('miniHeaderFilePath', miniHeaderFile!.path);
    }
    if (footerFile != null) {
      myServices.sharedPreferences
          .setString('footerFilePath', footerFile!.path);
    }
    // ignore: deprecated_member_use
    myServices.sharedPreferences.setInt('selected_color', currentColor.value);
  }

  //? Load local data:
  void loadPreferences() async {
    try {
      headersState = myServices.sharedPreferences
              .getStringList('headers_state')
              ?.map((e) => e == 'true')
              .toList() ??
          headersState;
      footersState = myServices.sharedPreferences
              .getStringList('footers_state')
              ?.map((e) => e == 'true')
              .toList() ??
          footersState;
      tablesTileState = myServices.sharedPreferences
              .getStringList('tables_state')
              ?.map((e) => e == 'true')
              .toList() ??
          tablesTileState;
      String? a4HeaderFilePath =
          myServices.sharedPreferences.getString('a4HeaderFilePath');
      if (a4HeaderFilePath != null) {
        File a4HeaderFile = File(a4HeaderFilePath);
        ImageProvider imageProvider = FileImage(a4HeaderFile);
        imageSizeFuture = await getImageSize(imageProvider);
      }

      String? miniHeaderFilePath =
          myServices.sharedPreferences.getString('miniHeaderFilePath');
      if (miniHeaderFilePath != null) {
        miniHeaderFile = File(miniHeaderFilePath);
        ImageProvider imageProvider = FileImage(miniHeaderFile!);
        miniImageSizeFuture = await getImageSize(imageProvider);
      }

      String? footerFilePath =
          myServices.sharedPreferences.getString('footerFilePath');
      if (footerFilePath != null && File(footerFilePath).existsSync()) {
        footerFile = File(footerFilePath);
      }

      currentColor =
          Color(myServices.sharedPreferences.getInt('selected_color') ??
              // ignore: deprecated_member_use
              primaryColor.value);
      showA4HeadersImage =
          myServices.sharedPreferences.getBool("show_a4_image") ?? true;
      showMiniReciveHeadersImage =
          myServices.sharedPreferences.getBool("show_mini_image") ?? true;
      selectedPrinters =
          myServices.sharedPreferences.getString("selected_printer") ??
              "A4 Printer";
      groupValueState =
          myServices.sharedPreferences.getBool("group_layout") ?? false ? 1 : 0;
      barcodeWidth = double.tryParse(
              myServices.sharedPreferences.getString("barcode_width") ??
                  "161.0") ??
          161.0;
      barcodeHeight = double.tryParse(
              myServices.sharedPreferences.getString("barcode_height") ??
                  "60") ??
          60;
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error during upload printer data");
    } finally {
      update();
    }
  }

  void changeMiniRecivePageSize(String value) {
    pdfMiniPageFormat = PdfPageFormat(
        double.tryParse(value) ?? 38.0 * PdfPageFormat.mm,
        1000 * PdfPageFormat.mm);
    myServices.sharedPreferences.setString("miniInvoicePageSize", value);
    update();
  }

  //? Data transpose:
  List<List<dynamic>> transposeData(Map<String, List<dynamic>> data) {
    final numRows = data.values.first.length;

    final rows = <List<dynamic>>[];

    for (int i = 0; i < numRows; i++) {
      final row = data.entries.map((entry) => entry.value[i]).toList();
      rows.add(row);
    }

    return rows;
  }

  //? Data Filtering
  Map<String, List<dynamic>> filterData(
      Map<String, List<dynamic>> data, List<String> selectedColumns) {
    final filteredData = <String, List<dynamic>>{};

    for (final column in selectedColumns) {
      if (data.containsKey(column)) {
        filteredData[column] = data[column]!;
      }
    }

    return filteredData;
  }

  Future<PdfPageFormat> switchPrinter() async {
    PdfPageFormat pageFormat = PdfPageFormat.a4;
    isA4Format = false;
    isA5Format = false;
    isASunmiFormat = false;
    isXPrinterFormat = false;

    if (selectedPrinters == "A4 Printer") {
      pageFormat = PdfPageFormat.a4;
      isA4Format = true;
    }
    if (selectedPrinters == "A5 Printer") {
      pageFormat = PdfPageFormat.a5;
      isA5Format = true;
    }
    if (selectedPrinters == "Mini Printer") {
      pageFormat =
          const PdfPageFormat(58.0 * PdfPageFormat.mm, 1000 * PdfPageFormat.mm);
      isXPrinterFormat = true;
    }
    if (selectedPrinters == "SUNMI Printer") {
      pageFormat =
          const PdfPageFormat(58.0 * PdfPageFormat.mm, 1000 * PdfPageFormat.mm);
      isASunmiFormat = true;
    }
    update();
    return pageFormat;
  }

  Future<void> printInvoice(Map<String, dynamic> headerData,
      Map<String, List<dynamic>> tableData, String invoiceType,
      {List<String>? passedHeaders}) async {
    try {
      final format = await switchPrinter();
      Uint8List? pdf;

      // A4 format PDF generation
      if (isA4Format) {
        pdf = await generateA4Pdf(format, headerData, tableData, invoiceType,
            passedDataColumn: passedHeaders);
      }

      // A5 format PDF generation
      if (isA5Format) {
        pdf = await generateA5Pdf(format, headerData, tableData, invoiceType,
            passedDataColumn: passedHeaders);
      }

      // X Printer format PDF generation
      if (isXPrinterFormat) {
        pdf = await generateMiniRecivePdf(format, "", headerData, tableData);
      }

      // Proceed with printing
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf!,
      );
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error occurred during printing");
    }
  }

  Future<Uint8List> generateA4Pdf(
      PdfPageFormat format,
      Map<String, dynamic> headerData,
      Map<String, List<dynamic>> tableData,
      String invoiceType,
      {List<String>? passedDataColumn}) async {
    //? Font Style
    final ttf = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Barlow/Barlow-Regular.ttf'),
    );
    final arabicFontBold = pw.Font.ttf(
      await rootBundle
          .load("assets/fonts/Noto_Kufi_Arabic/static/NotoKufiArabic-Bold.ttf"),
    );
    final arabicFontRegular = pw.Font.ttf(
      await rootBundle.load(
          "assets/fonts/Noto_Kufi_Arabic/static/NotoKufiArabic-Regular.ttf"),
    );

    //? Text style:

    final customTitleStyleArabicRegular = pw.TextStyle(
      fontFallback: [arabicFontRegular],
      font: arabicFontRegular,
      fontSize: 12.0,

      // ignore: deprecated_member_use
      color: PdfColor.fromInt(black.value),
    );
    final customTitleStyle = pw.TextStyle(
      fontFallback: [arabicFontBold],
      font: ttf,
      fontSize: 12.0,
      // ignore: deprecated_member_use
      color: PdfColor.fromInt(currentColor.value),
    );
    //? Page Format:
    final pdf = pw.Document(version: PdfVersion.pdf_1_4, compress: true);
    List<String> tableHeaders = passedDataColumn ?? selectedColumns;
    //? Data filter:
    final filteredData =
        filterData(tableData, passedDataColumn ?? selectedColumns);
    //? Transposing data:
    final rows = transposeData(filteredData);
    //? Table Headers:

    //? Row height can be dynamic, depending on content
    double rowHeight = 18.0;
    final double pageHeight = format.height;
    //? First Page :-----------------------------------------------
    //* Available height for the first page
    double availableHeightFirstPage = pageHeight -
        (showA4HeadersImage
            ? imageSizeFuture!.height > 200
                ? 200
                : imageSizeFuture?.height ?? 0
            : 0) -
        headerHeight -
        (2 * 15);
    //* Rows per page for the first page
    int rowsPerPageFirstPage = ((availableHeightFirstPage / rowHeight) -
            (imageSizeFuture!.height > 200 // Conditional check
                ? 19 // If true
                : 15)) // If false
        .floor();

    //? Second Page :-----------------------------------------------
    //* Available height for subsequent pages (without the footer)
    double availableHeightOtherPages =
        !showA4HeadersImage ? pageHeight - (2 * 15) : availableHeightFirstPage;

    //* Rows per page for other pages (without the header image)
    int rowsPerPageOtherPages =
        ((availableHeightOtherPages / rowHeight) - 15).floor();

    final List<List<List<dynamic>>> paginatedRows = [];

    // Adjust if headers are shown on other pages
    if (showA4HeadersImage) {
      rowsPerPageOtherPages = rowsPerPageFirstPage;
      availableHeightOtherPages = availableHeightFirstPage;
    }

    if (rows.length > rowsPerPageFirstPage) {
      //* Add rows for the first page
      paginatedRows.add(rows.sublist(0, rowsPerPageFirstPage));

      //* For remaining rows after the first page
      int remainingRows = rows.length - rowsPerPageFirstPage;

      // If remaining rows fit on the last page (second page in case of 2 pages)
      if (remainingRows <= rowsPerPageOtherPages) {
        //* Available height for the last page (subtracting footerHeight)
        double availableHeightLastPage = pageHeight - footerHeight - (2 * 15);
        int rowsPerPageLastPage =
            ((availableHeightLastPage / rowHeight) - 15).floor();

        if (remainingRows <= rowsPerPageLastPage) {
          // Add the remaining rows to the last page
          paginatedRows.add(rows.sublist(
              rowsPerPageFirstPage,
              rowsPerPageFirstPage + rowsPerPageLastPage > rows.length
                  ? rows.length
                  : rowsPerPageFirstPage + rowsPerPageLastPage));
        } else {
          paginatedRows.add(rows.sublist(
              rowsPerPageFirstPage,
              rowsPerPageFirstPage + rowsPerPageOtherPages > rows.length
                  ? rows.length
                  : rowsPerPageFirstPage + rowsPerPageOtherPages));

          paginatedRows.add([]);
        }
      } else {
        //* For more than two pages: Add middle pages first, then last page
        for (int i = rowsPerPageFirstPage; i < rows.length;) {
          remainingRows = rows.length - i;

          // If this is the last page
          if (remainingRows <= rowsPerPageOtherPages) {
            //* Available height for the last page (subtracting footerHeight)
            double availableHeightLastPage =
                pageHeight - footerHeight - (2 * 15);
            int rowsPerPageLastPage =
                ((availableHeightLastPage / rowHeight) - 15).floor();

            // Check if the remaining rows fit with the footer
            if (remainingRows <= rowsPerPageLastPage) {
              // Add the last page rows
              paginatedRows.add(
                rows.sublist(
                    i,
                    i + rowsPerPageLastPage > rows.length
                        ? rows.length
                        : i + rowsPerPageLastPage),
              );
            } else {
              // Add remaining rows to the current page
              paginatedRows.add(
                rows.sublist(
                    i,
                    i + rowsPerPageOtherPages > rows.length
                        ? rows.length
                        : i + rowsPerPageOtherPages),
              );

              // Add an empty page for the footer
              paginatedRows.add([]);
            }
            break;
          } else {
            // Add intermediate pages (not the last)
            paginatedRows.add(
              rows.sublist(
                  i,
                  i + rowsPerPageOtherPages > rows.length
                      ? rows.length
                      : i + rowsPerPageOtherPages),
            );
            i += rowsPerPageOtherPages;
          }
        }
      }
    } else {
      // If everything fits on the first page
      paginatedRows.add(rows);
    }

    for (int i = 0; i < paginatedRows.length; i++) {}

    //? Print each page:
    for (int pageNumber = 0; pageNumber < paginatedRows.length; pageNumber++) {
      pdf.addPage(
        pw.Page(
          textDirection: screenDirection() == TextDirection.ltr
              ? pw.TextDirection.ltr
              : pw.TextDirection.rtl,
          margin: pw.EdgeInsets.zero,
          pageFormat: format,
          build: (context) {
            final pageWidth = context.page.pageFormat.width;
            final adaptiveColumnWidths =
                getAdaptiveColumnWidths(filteredData, invoiceType);
            return pw.Container(
              width: pageWidth,
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  //? Check if it is the first page:

                  //! Header Section:
                  showA4HeadersImage || pageNumber == 0
                      ? pw.Header(
                          level: 1,
                          child: pw.Column(
                            children: [
                              //? Image :
                              buildHeaderImage(isA4Format),
                              //? Titles:
                              pw.Container(
                                margin: const pw.EdgeInsets.symmetric(
                                    horizontal: 5),
                                height: headerHeight,
                                child: pw.GridView(
                                  crossAxisCount: 3,
                                  children: selectedHeaders
                                      // Filter titles where the headerData for that title is not null
                                      .where(
                                          (title) => headerData[title] != null)
                                      .map((title) {
                                    return pw.Container(
                                      padding: const pw.EdgeInsets.all(4),
                                      child: pw.Text(
                                        "${title.tr}: ${headerData[title]}",
                                        style: customTitleStyleArabicRegular
                                            .copyWith(
                                          fontSize: 10,
                                          color: PdfColor.fromInt(
                                              // ignore: deprecated_member_use
                                              black.value), // Use color safely
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )
                            ],
                          ),
                        )
                      : pw.Container(),
                  //! Table Body Section:
                  pw.Container(
                    margin: const pw.EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: pw.Table(
                      columnWidths: invoiceType == "inventory"
                          ? const {
                              0: pw.FixedColumnWidth(15),
                              1: pw.FixedColumnWidth(30),
                              2: pw.FixedColumnWidth(20),
                              3: pw.FixedColumnWidth(15),
                              4: pw.FixedColumnWidth(20),
                            }
                          : invoiceType == "buying"
                              ? const {
                                  0: pw.FixedColumnWidth(10),
                                  1: pw.FixedColumnWidth(30),
                                  2: pw.FixedColumnWidth(15),
                                  3: pw.FixedColumnWidth(10),
                                  4: pw.FixedColumnWidth(10),
                                  5: pw.FixedColumnWidth(10),
                                  6: pw.FixedColumnWidth(20),
                                }
                              : adaptiveColumnWidths,
                      border: const pw.TableBorder(),
                      children: [
                        pw.TableRow(
                          decoration: pw.BoxDecoration(
                            // ignore: deprecated_member_use
                            color: PdfColor.fromInt(currentColor.value),
                            border: pw.Border.all(
                                // ignore: deprecated_member_use
                                color: PdfColor.fromInt(Colors.black.value)),
                          ),
                          children: [
                            //? Table Headers:
                            ...tableHeaders.map((header) {
                              return pw.Container(
                                height: 30,
                                alignment: pw.Alignment.center,
                                decoration: pw.BoxDecoration(
                                  border: pw.Border.all(
                                    width: .5,
                                    // ignore: deprecated_member_use
                                    color: PdfColor.fromInt(white.value),
                                  ),
                                ),
                                child: pw.Text(
                                  header.tr,
                                  textAlign: pw.TextAlign.center,
                                  style: customTitleStyleArabicRegular.copyWith(
                                    // ignore: deprecated_member_use
                                    color: PdfColor.fromInt(white.value),
                                    fontSize: calculateFontSize(
                                        header, pageWidth, 12.0),
                                  ),
                                  maxLines: 1,
                                ),
                              );
                            }),
                          ],
                        ),
                        //? Table content:
                        ...paginatedRows[pageNumber].map(
                          (row) => pw.TableRow(
                            children: row.map((cell) {
                              return pw.Container(
                                alignment: pw.Alignment.center,
                                height: 25,
                                decoration: pw.BoxDecoration(
                                    border: pw.Border.all(
                                        width: .5,
                                        // ignore: deprecated_member_use
                                        color: PdfColor.fromInt(black.value))),
                                child: pw.Text(
                                  cell.toString(),
                                  textAlign: pw.TextAlign.center,
                                  style: customTitleStyleArabicRegular.copyWith(
                                    // ignore: deprecated_member_use
                                    color: PdfColor.fromInt(black.value),
                                    fontSize: calculateFontSize(
                                        cell.toString(), pageWidth, 10.0),
                                  ),
                                  maxLines: 2,
                                  overflow: pw.TextOverflow.visible,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  pw.Spacer(),
                  pw.Footer(
                    trailing: pw.Container(
                      alignment: pw.Alignment.bottomRight,
                      padding: const pw.EdgeInsets.only(right: 15, bottom: 15),
                      child: pw.Text(
                        "Page ${pageNumber + 1} of ${paginatedRows.length}",
                        style: customTitleStyle.copyWith(
                          // ignore: deprecated_member_use
                          color: PdfColor.fromInt(black.value),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    return pdf.save();
  }

  Future<Uint8List> generateA5Pdf(
      PdfPageFormat format,
      Map<String, dynamic> headerData,
      Map<String, List<dynamic>> tableData,
      String invoiceType,
      {List<String>? passedDataColumn}) async {
    final arabicFontRegular = pw.Font.ttf(
      await rootBundle.load(
          "assets/fonts/Noto_Kufi_Arabic/static/NotoKufiArabic-Regular.ttf"),
    );

    // Load the image from assets
    final ByteData imageData =
        await rootBundle.load('assets/print_background.png');

    // Convert ByteData to Uint8List
    final Uint8List imageBytes = imageData.buffer.asUint8List();

    final customTitleStyleArabicRegular = pw.TextStyle(
      fontFallback: [arabicFontRegular],
      font: arabicFontRegular,
      fontSize: 12.0,
      // ignore: deprecated_member_use
      color: PdfColor.fromInt(currentColor.value),
    );

    // Create PDF document
    final pdf = pw.Document(version: PdfVersion.pdf_1_4, compress: true);

    List<String> tableHeaders =
        passedDataColumn ?? ["بها", "هژمار", "بابەت", "سەرجەم"];
    // Adjust the page format to be in landscape mode
    final pageFormat = format.landscape; // Ensure the page is in landscape
    final filteredData = filterData(
        tableData,
        passedDataColumn ??
            [
              "Price",
              "QTY",
              "Name",
              "Total Price",
            ]);
    //? Transposing data:
    final rows = transposeData(filteredData);
    final List<List<List<dynamic>>> paginatedRows = [];
    int rowsPerPage = 5; // Fixed number of rows per page

    if (rows.isNotEmpty) {
      for (int i = 0; i < rows.length; i += rowsPerPage) {
        paginatedRows.add(
          rows.sublist(
            i,
            i + rowsPerPage > rows.length ? rows.length : i + rowsPerPage,
          ),
        );
        if (rows.length < 5) {
          int emptyRows = rowsPerPage - rows.length;
          for (int j = 0; j < emptyRows; j++) {
            paginatedRows[i].add(passedDataColumn != null
                ? ["", "", "", "", ""]
                : ["", "", "", ""]);
          }
        }
      }
    }
    for (int pageNumber = 0; pageNumber < paginatedRows.length; pageNumber++) {
      pdf.addPage(
        pw.Page(
          textDirection: pw.TextDirection.rtl,
          margin: pw.EdgeInsets.zero,
          orientation: pw.PageOrientation.landscape,
          pageFormat: pageFormat,
          build: (context) {
            final pageWidth = pageFormat.width;
            final pageHeight = pageFormat.height;
            Color a5Color =
                currentColor; // ?? Color.fromARGB(255, 156, 67, 57);
            return pw.Container(
              alignment: pw.Alignment.center,
              width: pageWidth,
              height: pageHeight,
              decoration: pw.BoxDecoration(
                // ignore: deprecated_member_use
                color: PdfColor.fromInt(a5Color.value),
                image: pw.DecorationImage(
                  image: pw.MemoryImage(imageBytes), // Use the loaded image
                  fit:
                      pw.BoxFit.cover, // Scale the image (cover, contain, etc.)
                ),
              ),
              child: pw.Container(
                width: pageWidth - 75,
                height: pageHeight - 75,

                // Design your layout here
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.SizedBox(height: 54),
                    pw.Container(
                      width: pageWidth,
                      child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Container(
                              width: 250,
                              child: pw.Row(children: [
                                pw.Container(
                                  width: 110,
                                ),
                                //? Customer name ------------------------------
                                pw.Container(
                                  width: 190,
                                  alignment: pw.Alignment.bottomRight,
                                  child: pw.Text(
                                      headerData['Customer Name'].toString().tr,
                                      style: customTitleStyleArabicRegular
                                          .copyWith(fontSize: 10)),
                                ),
                              ]),
                            ),
                            pw.SizedBox(width: 5),
                            pw.Container(
                              width: 230,
                              child: pw.Row(children: [
                                pw.Container(
                                  width: 95,
                                ),
                                //? Address ------------------------------
                                pw.Container(
                                  width: 170,
                                  alignment: pw.Alignment.bottomRight,
                                  child: pw.Text(
                                      headerData['Customer Address'] ?? "",
                                      style: customTitleStyleArabicRegular
                                          .copyWith(fontSize: 10)),
                                ),
                              ]),
                            ),
                          ]),
                    ),
                    pw.SizedBox(height: 9),
                    pw.Container(
                      width: pageWidth,
                      child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Container(
                              width: 250,
                              child: pw.Row(children: [
                                pw.Container(
                                  width: 125,
                                ),
                                pw.SizedBox(width: 5),
                                //? Customer Phone ------------------------------
                                pw.Container(
                                  width: 175,
                                  alignment: pw.Alignment.bottomRight,
                                  child: pw.Text(
                                      headerData['Customer Phone'] ?? "",
                                      style: customTitleStyleArabicRegular
                                          .copyWith(fontSize: 10)),
                                ),
                              ]),
                            ),
                            pw.Container(
                              width: 230,
                              child: pw.Row(children: [
                                pw.Container(
                                  width: 130,
                                ),
                                //? Date ------------------------------
                                pw.Container(
                                  width: 145,
                                  alignment: pw.Alignment.bottomRight,
                                  child: pw.Text(headerData['Date'] ?? "",
                                      style: customTitleStyleArabicRegular
                                          .copyWith(fontSize: 10)),
                                ),
                              ]),
                            ),
                          ]),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Container(
                      width: 445,
                      child: pw.Table(
                        columnWidths: invoiceType == "inventory"
                            ? const {
                                0: pw.FixedColumnWidth(15),
                                1: pw.FixedColumnWidth(30),
                                2: pw.FixedColumnWidth(20),
                                3: pw.FixedColumnWidth(15),
                                4: pw.FixedColumnWidth(20),
                              }
                            : invoiceType == "buying"
                                ? const {
                                    0: pw.FixedColumnWidth(10),
                                    1: pw.FixedColumnWidth(30),
                                    2: pw.FixedColumnWidth(15),
                                    3: pw.FixedColumnWidth(10),
                                    4: pw.FixedColumnWidth(10),
                                    5: pw.FixedColumnWidth(10),
                                    6: pw.FixedColumnWidth(20),
                                  }
                                : const {
                                    0: pw.FixedColumnWidth(15),
                                    1: pw.FixedColumnWidth(10),
                                    2: pw.FixedColumnWidth(65),
                                    3: pw.FixedColumnWidth(15),
                                  },
                        defaultVerticalAlignment:
                            pw.TableCellVerticalAlignment.full,
                        border: const pw.TableBorder(),
                        children: [
                          pw.TableRow(
                            children: [
                              //? Table Headers:
                              ...tableHeaders.map((header) {
                                return pw.Container(
                                  height: 21,
                                  alignment: pw.Alignment.center,
                                );
                              }),
                            ],
                          ),
                          ...paginatedRows[pageNumber].map(
                            (row) => pw.TableRow(
                              children: row.map((cell) {
                                return pw.Container(
                                  alignment: pw.Alignment.center,
                                  height: 22,
                                  child: pw.Text(
                                    cell.toString(),
                                    textAlign: pw.TextAlign.center,
                                    style:
                                        customTitleStyleArabicRegular.copyWith(
                                      // ignore: deprecated_member_use
                                      color: PdfColor.fromInt(a5Color.value),
                                      fontSize: calculateFontSize(
                                          cell.toString(), pageWidth, 9),
                                    ),
                                    maxLines: 2,
                                    overflow: pw.TextOverflow.visible,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(height: 12),
                    pw.Container(
                        width: 405,
                        alignment: pw.Alignment.centerRight,
                        child: pw.Text(
                            textAlign: pw.TextAlign.center,
                            style: customTitleStyleArabicRegular.copyWith(
                              // ignore: deprecated_member_use
                              color: PdfColor.fromInt(a5Color.value),
                              fontSize: calculateFontSize(
                                  headerData['Total Price'], pageWidth, 9),
                            ),
                            maxLines: 2,
                            overflow: pw.TextOverflow.visible,
                            headerData['Total Price']))
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
    return pdf.save();
  }

  // Ensure this import is included

  //? Public function to export PDF for other controllers to use
  Future<void> exportInvoicePdf(Map<String, dynamic> headerData,
      Map<String, List<dynamic>> tableData, String invoiceType) async {
    try {
      final format = await switchPrinter();
      Uint8List? pdf;
      if (isA4Format) {
        pdf = await generateA4Pdf(format, headerData, tableData, invoiceType);
      }
      if (isA5Format) {
        pdf = await generateA5Pdf(format, headerData, tableData, invoiceType);
      } else if (isXPrinterFormat) {
        pdf = await generateMiniRecivePdf(format, "", headerData, tableData);
      }
      final appDirectory = await getApplicationDocumentsDirectory();

      String savePath = myServices.sharedPreferences.getString("save_path") ??
          appDirectory.path;

      final file =
          File("$savePath/invoice_${headerData['Invoice number']}.pdf");
      if (myServices.sharedPreferences.getBool("open_file") ?? true) {
        await file.writeAsBytes(pdf!);
        await OpenFile.open(file.path);
      }

      if (myServices.sharedPreferences.getBool("save_file") ?? true) {
        await file.writeAsBytes(pdf!);

        customSnackBar("Success", "PDF exported successfully");
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Export Error",
          message: "Failed to export the invoice as a PDF.");
    }
  }

  //? generateMiniRecivePdf:
  Future<Uint8List> generateMiniRecivePdf(
    PdfPageFormat format,
    String title,
    Map<String, dynamic> headerData,
    Map<String, List<dynamic>> tableData,
  ) async {
    final ttf = pw.Font.ttf(
      await rootBundle.load(
          "assets/fonts/Noto_Kufi_Arabic/static/NotoKufiArabic-Regular.ttf"),
    );
    final arabicFontBold = pw.Font.ttf(await rootBundle
        .load("assets/fonts/Noto_Kufi_Arabic/static/NotoKufiArabic-Bold.ttf"));
    final customTitleStyle = pw.TextStyle(
      fontFallback: [arabicFontBold],
      font: ttf,
      fontSize: 8,
      // ignore: deprecated_member_use
      color: PdfColor.fromInt(primaryColor.value),
    );

    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    PdfPageFormat pageFormat =
        myServices.sharedPreferences.getBool("paper_size_80") ?? true
            ? const PdfPageFormat(200, 2000)
            : const PdfPageFormat(161, 2000);

    // Prepare data for the table
    final filteredData = filterData(tableData, selectedColumns);
    final rows = transposeData(filteredData);
    pdf.addPage(
      pw.Page(
        textDirection: screenDirection() == TextDirection.ltr
            ? pw.TextDirection.ltr
            : pw.TextDirection.rtl,
        margin: pw.EdgeInsets.zero,
        pageFormat: pageFormat,
        build: (context) {
          int rowCount = tableData[selectedColumns[0]]?.length ?? 0;
          final pageWidth = context.page.pageFormat.width;

          return pw.Container(
            width: pageWidth,
            padding: const pw.EdgeInsets.all(2),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  children: [
                    //? Header Image:
                    if (showMiniReciveHeadersImage ?? true)
                      buildHeaderImage(false),
                    //? Header Section:
                    pw.Container(
                      margin: const pw.EdgeInsets.symmetric(horizontal: 2),
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: selectedHeaders.map((title) {
                          return pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(vertical: 2),
                            child: pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  textDirection:
                                      screenDirection() == TextDirection.ltr
                                          ? pw.TextDirection.ltr
                                          : pw.TextDirection.rtl,
                                  "${title.tr}: ",
                                  style: customTitleStyle.copyWith(
                                      // ignore: deprecated_member_use
                                      color: PdfColor.fromInt(black.value)),
                                ),
                                pw.Text(
                                  headerData[title] ?? "",
                                  style: customTitleStyle.copyWith(
                                      // ignore: deprecated_member_use
                                      color: PdfColor.fromInt(black.value)),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                pw.Divider(),
                pw.Divider(),
                if (groupValueState == 0)
                  pw.Table(
                    border:
                        pw.TableBorder.all(color: PdfColors.grey, width: 0.5),
                    children: [
                      //? Table Header
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(
                          color: PdfColors.grey300,
                        ),
                        children: selectedColumns.map((header) {
                          return pw.Container(
                            height: 20,
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              header.tr,
                              textAlign: pw.TextAlign.center,
                              style: customTitleStyle.copyWith(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 6,
                                  // ignore: deprecated_member_use
                                  color: PdfColor.fromInt(black.value)),
                            ),
                          );
                        }).toList(),
                      ),
                      // Table Rows
                      ...rows.map(
                        (row) => pw.TableRow(
                          children: row.map((cell) {
                            double cellWidth =
                                pageWidth / selectedColumns.length;
                            double fontSize =
                                adjustFontSizeBasedOnWidth(cellWidth, 12, 6);
                            return pw.Container(
                              alignment: pw.Alignment.center,
                              height: 20,
                              padding: const pw.EdgeInsets.all(5),
                              decoration: pw.BoxDecoration(
                                  border: pw.Border.all(width: .5)),
                              child: pw.Text(
                                cell.toString().tr,
                                textAlign: pw.TextAlign.center,
                                style: customTitleStyle.copyWith(
                                    fontSize: fontSize,
                                    // ignore: deprecated_member_use
                                    color: PdfColor.fromInt(black.value)),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                if (groupValueState == 1)
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 3),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: List.generate(rowCount, (i) {
                        List<pw.Widget> itemDetails = [];

                        for (String column in selectedColumns) {
                          String value = tableData[column]?[i]?.toString() ??
                              ''; // Get the value for each column
                          itemDetails.add(pw.Text('${column.tr}: $value',
                              style: customTitleStyle.copyWith(
                                  fontSize: 8,
                                  // ignore: deprecated_member_use
                                  color: PdfColor.fromInt(black.value))));
                        }

                        return pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            ...itemDetails,
                            pw.Divider(
                                height: 5,
                                thickness: .1,
                                color: PdfColors.black),
                          ],
                        );
                      }),
                    ),
                  ),
                pw.Divider(),
                pw.Text(
                  "${"Discount".tr}: ${headerData['Discount']} IQD",
                  style: customTitleStyle.copyWith(
                      fontSize: 8,
                      // ignore: deprecated_member_use
                      color: PdfColor.fromInt(black.value)),
                ),
                pw.Text(
                  "${"Taxes".tr}: ${headerData['Taxes']} IQD",
                  style: customTitleStyle.copyWith(
                      fontSize: 8,
                      // ignore: deprecated_member_use
                      color: PdfColor.fromInt(black.value)),
                ),
                pw.Text(
                  "${"Total Price".tr}: ${headerData['Total Price']} IQD",
                  style: customTitleStyle.copyWith(
                      fontSize: 8,
                      // ignore: deprecated_member_use
                      color: PdfColor.fromInt(black.value)),
                )
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<Uint8List> generateBarcode(
    String barcodeData,
    String itemName,
    String itemPrice,
    int quantity,
  ) async {
    // Load fonts
    final ttf = pw.Font.ttf(
      await rootBundle.load(
        "assets/fonts/Noto_Kufi_Arabic/static/NotoKufiArabic-Regular.ttf",
      ),
    );
    final arabicFontBold = pw.Font.ttf(
      await rootBundle.load(
        "assets/fonts/Noto_Kufi_Arabic/static/NotoKufiArabic-Bold.ttf",
      ),
    );

    final customTitleStyle = pw.TextStyle(
      fontFallback: [arabicFontBold],
      font: ttf,
      fontSize: 8,
      // ignore: deprecated_member_use
      color: PdfColor.fromInt(black.value),
    );

    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    final barcodeWidth = double.tryParse(
            myServices.sharedPreferences.getString("barcode_width") ?? "135") ??
        135.0;
    final barcodeHeight = double.tryParse(
            myServices.sharedPreferences.getString("barcode_height") ?? "80") ??
        80.0;

    final invoiceIconSvg =
        await rootBundle.loadString('assets/icons/invoice_logo.svg');
    for (int i = 0; i < quantity; i++) {
      pdf.addPage(
        pw.Page(
          textDirection: pw.TextDirection.ltr,
          margin: pw.EdgeInsets.zero,
          pageFormat: PdfPageFormat(barcodeWidth, barcodeHeight),
          build: (context) {
            final pageWidth = context.page.pageFormat.width;
            final pageHeight = context.page.pageFormat.height;

            return pw.Container(
              width: pageWidth,
              padding: const pw.EdgeInsets.all(5),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Container(
                    height: pageHeight * 0.3,
                    alignment: pw.Alignment.center,
                    width: pageWidth,
                    decoration:
                        pw.BoxDecoration(border: pw.Border.all(width: .2)),
                    child: pw.BarcodeWidget(
                      drawText: true,
                      width: pageWidth * 0.8,
                      height: pageHeight * 0.3,
                      data: barcodeData,
                      barcode: pw.Barcode.code128(),
                    ),
                  ),

                  pw.SizedBox(height: 3),
                  //? Name Section
                  pw.Container(
                    alignment: pw.Alignment.center,
                    width: pageWidth,
                    height: pageHeight * 0.2,
                    decoration:
                        pw.BoxDecoration(border: pw.Border.all(width: .2)),
                    child: pw.Text(itemName,
                        textDirection: pw.TextDirection.ltr,
                        textAlign: pw.TextAlign.center,
                        style: customTitleStyle.copyWith(
                            fontSize: pageHeight >= 200 ? 13 : 10)),
                  ),
                  pw.SizedBox(height: 3),
                  //? Logo Section
                  pw.Container(
                    alignment: pw.Alignment.center,
                    width: pageWidth,
                    height: pageHeight * 0.25,
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 10, vertical: 0),
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.SvgImage(
                            svg: invoiceIconSvg,
                            width: 35,
                            height: 35,
                            // ignore: deprecated_member_use
                            colorFilter: PdfColor.fromInt(black.value),
                            fit: pw.BoxFit.fill,
                          ),
                          pw.Container(
                            alignment: pw.Alignment.center,
                            child: pw.Text("Ferminus",
                                style: customTitleStyle.copyWith(
                                    fontSize: pageHeight >= 200 ? 16 : 12,
                                    fontNormal: pw.Font.helveticaBold(),
                                    fontBold: pw.Font.timesBold())),
                          ),
                          pw.Spacer(),
                          pw.Text("Tel: 0750 814 8814",
                              style: customTitleStyle.copyWith(
                                  fontSize: pageHeight >= 200 ? 16 : 10,
                                  fontNormal: pw.Font.helveticaBold(),
                                  fontBold: pw.Font.timesBold())),
                        ]),
                  ),
                  // //? Code Section
                  // pw.Container(
                  //   width: pageWidth - 25,
                  //   height: pageHeight * .13,
                  //   alignment: pw.Alignment.center,
                  //   padding: const pw.EdgeInsets.symmetric(horizontal: 3),
                  //   decoration:
                  //       pw.BoxDecoration(border: pw.Border.all(width: .3)),
                  //   child: pw.Text(itemCode,
                  //       style: customTitleStyle.copyWith(
                  //           fontSize: pageHeight >= 200 ? 16 : 10,
                  //           fontNormal: pw.Font.helveticaBold(),
                  //           fontBold: pw.Font.timesBold())),
                  // ),
                ],
              ),
            );
          },
        ),
      );
    }

    return pdf.save();
  }

  pw.Widget buildItemizedLayout(
    int rowCount,
    Map<String, List<dynamic>> tableData,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: List.generate(rowCount, (i) {
        List<pw.Widget> itemDetails = [];

        for (String column in selectedColumns) {
          String value = tableData[column]?[i]?.toString() ??
              ''; // Get the value for each column
          itemDetails.add(pw.Text('${column.tr}: $value'));
        }

        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            ...itemDetails,
            pw.SizedBox(height: 5),
            pw.Divider(color: PdfColors.grey),
          ],
        );
      }),
    );
  }

  double adjustFontSizeBasedOnWidth(
      double availableWidth, double maxSize, double minSize) {
    if (availableWidth > 300) {
      return maxSize;
    } else if (availableWidth > 200) {
      return (maxSize + minSize) / 2;
    } else {
      return minSize;
    }
  }

  pw.Widget buildHeaderImage(bool isA4Format) {
    // Determine which file to use based on format
    final headerFile = isA4Format ? a4HeaderFile : miniHeaderFile;

    if (headerFile == null) {
      return pw.Container();
    }

    double imageHeight =
        imageSizeFuture!.height > 100 ? 100 : imageSizeFuture?.height ?? 50;
    return pw.Container(
      height: isA4Format ? imageHeight : 50,
      width: Get.width,
      child: pw.Image(
        pw.MemoryImage(headerFile.readAsBytesSync()),
        fit: pw.BoxFit.fill,
      ),
    );
  }

  //? Calculate font size based on text length and available width

  double calculateFontSize(String text, double maxWidth, double baseSize) {
    double fontSize = baseSize;
    if (text.length < 20) {
      fontSize = 8;
    }
    if (text.length > 20) {
      fontSize = baseSize * 0.7;
    } else if (text.length > 40) {
      fontSize = baseSize * 0.5;
    } else if (text.length > 60) {
      fontSize = baseSize * 0.4;
    }
    return fontSize;
  }

//? Dynamically adjust column widths based on content
  Map<int, pw.TableColumnWidth> getAdaptiveColumnWidths(
      Map<String, List<dynamic>> data, String invoiceType) {
    Map<int, pw.TableColumnWidth> columnWidths = {};

    for (int i = 0; i < data.keys.length; i++) {
      final columnName = data.keys.elementAt(i);
      final maxLength = data.values.elementAt(i).fold<int>(
            0,
            (prev, element) => element.toString().length > prev
                ? element.toString().length
                : prev,
          );
      if (invoiceType == "bills") {
        if (columnName == "#") {
          columnWidths[i] = const pw.FixedColumnWidth(30);
        } else if (columnName == "Total Price") {
          columnWidths[i] = const pw.FixedColumnWidth(80);
        } else if (maxLength > 20) {
          columnWidths[i] = const pw.FlexColumnWidth(2);
        } else if (maxLength > 10) {
          columnWidths[i] = const pw.FlexColumnWidth(1);
        } else {
          columnWidths[i] = const pw.FixedColumnWidth(65);
        }
      }
      if (columnName == "#") {
        columnWidths[i] = const pw.FixedColumnWidth(20);
      } else if (columnName == "Code") {
        columnWidths[i] = const pw.FixedColumnWidth(30);
      } else if (columnName == "Name") {
        columnWidths[i] = const pw.FixedColumnWidth(100);
      } else if (columnName == "QTY") {
        columnWidths[i] = const pw.FixedColumnWidth(30);
      } else if (columnName == "Price") {
        columnWidths[i] = const pw.FixedColumnWidth(60);
      } else if (columnName == "Total Price") {
        columnWidths[i] = const pw.FixedColumnWidth(75);
      } else if (columnName == "Type") {
        columnWidths[i] = const pw.FixedColumnWidth(50);
      }
    }

    return columnWidths;
  }

  Future<void> printReceipt(String content) async {
    try {
      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
        final pdf = generatePdf(content);
        return pdf.save();
      });
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error during print");
    }
  }

//? Generate a simple PDF document
  pw.Document generatePdf(String content) {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Text(content); // Center
    }));
    return pdf;
  }

  //? Init controller---------------------------------------------------:
  @override
  void onInit() {
    super.onInit();
    // getItems();
    loadPreferences();
    changeInvoicePageSize(
        myServices.sharedPreferences.getString("invoicePageSize") ?? "A4");
    loadHeaderParts();
    switchPrinter();
  }
}
