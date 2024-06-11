import 'dart:io';

import 'package:file_picker/file_picker.dart';

imageUploadCamera() async {
  //final ImagePickers file = await ImagePickers().getImage();
}

fileUploadGallery([isSvg = false]) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: isSvg
        ? ['svg', 'SVG']
        : ['png', 'PNG', 'JPG', 'jpg', 'JPEG', 'jpeg', 'gif'],
  );
  if (result != null) {
    return File(result.files.single.path!);
  } else {
    return null;
  }
}
