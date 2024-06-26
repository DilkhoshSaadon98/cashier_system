import 'dart:async';
import 'dart:io';

import 'package:cashier_system/core/functions/upload_file.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvoiceController extends GetxController {
  String selectedHeaderImage = "";
  double headerHeight = 35.0;
  int preSelectedLength = 0;
  final double additionalHeight = 30.0;

  void headerListHeight() {
    if ((selectedColumnsHeader.length > preSelectedLength) &&
        selectedColumnsHeader.length.isEven) {
      headerHeight += additionalHeight;
    } else if ((selectedColumnsHeader.length < preSelectedLength) &&
        preSelectedLength.isEven) {
      headerHeight -= additionalHeight;
    }
    preSelectedLength = selectedColumnsHeader.length;
  }

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

  File? footerFile;
  File? headerFile;
  Size? imageSizeFuture;

  void choseHeaderFile() async {
    headerFile = await fileUploadGallery();
    ImageProvider imageProvider = headerFile != null
        ? FileImage(headerFile!)
        : AssetImage(
            selectedHeaderImage.isEmpty
                ? 'assets/header.png'
                : selectedHeaderImage,
          ) as ImageProvider;
    imageSizeFuture = await getImageSize(imageProvider);
    update();
  }

  choseFooterFile() async {
    footerFile = await fileUploadGallery();
    update();
  }

  List<String> tablesTileTitle = [
    "Item Code",
    "Item Name",
    "Item Type",
    "Item QTY",
    "Item Price",
    "Item Total Price",
  ];
  List<bool> tablesTileState = [
    true,
    true,
    false,
    false,
    false,
    false,
  ];
  List<String> tileTitle = [
    "Customer Name:",
    "Orgnizer Name:",
    "Account Name:",
    "Number Of Items:",
    "Customer Phone:",
    "Customer Address:",
    "Invoice number:",
    "Date:",
    "Discount:",
    "Taxes:",
  ];
  List<bool> tileState = [
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
  ];
  List<String> get selectedColumnsHeader {
    List<String> selected = [];
    for (int i = 0; i < tileState.length; i++) {
      if (tileState[i]) {
        selected.add(tileTitle[i]);
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

  @override
  void onInit() {
    imageSizeFuture = Size(Get.width, 200);
    super.onInit();
  }
}
