import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';

Widget tableCell(
  String text, {
  void Function()? onTap,
  void Function()? onSecondaryTap,
  void Function(TapDownDetails)? onTapDown,
}) {
  final localizedText = text.tr;

  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onLongPress: onTap,
    onTapDown: onTapDown,
    onSecondaryTapDown: onTapDown,
    onSecondaryTap: onSecondaryTap,
    child: Tooltip(
      message: localizedText,
      showDuration: const Duration(seconds: 2),
      waitDuration: const Duration(seconds: 2),
      textStyle: bodyStyle.copyWith(color: white),
      // ignore: deprecated_member_use
      decoration: BoxDecoration(color: primaryColor.withOpacity(.7)),
      child: Center(
        child: SelectableText(
          localizedText,
          style: bodyStyle.copyWith(),
          maxLines: 1,

          enableInteractiveSelection: true,

          // ignore: deprecated_member_use
          toolbarOptions: const ToolbarOptions(copy: true, selectAll: true),
        ),
      ),
    ),
  );
}
