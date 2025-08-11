import 'dart:io';

import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadImage extends StatelessWidget {
  final void Function()? onTap;
  final void Function()? onRemove;
  final File? file;
  const UploadImage({
    super.key,
    this.onTap,
    this.onRemove,
    this.file,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onTap,
      child: Center(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 200,
                width: double.infinity,
                color: whiteNeon,
                child: file == null
                    ? Center(
                        child: Text(
                          TextRoutes.uploadImage.tr,
                          style: titleStyle.copyWith(),
                        ),
                      )
                    : Image.file(
                        file!,
                        fit: BoxFit.contain,
                      ),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: IconButton(
                onPressed: onTap,
                icon: const Icon(
                  Icons.add_a_photo,
                  size: 25,
                  color: primaryColor,
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              child: IconButton(
                onPressed: onRemove,
                icon: const Icon(
                  Icons.image_not_supported_outlined,
                  size: 25,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    
  }
}
