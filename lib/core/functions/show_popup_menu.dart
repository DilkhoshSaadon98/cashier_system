import 'package:cashier_system/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:get/get.dart';

class CustomShowPopupMenu {
  Offset tapPosition = Offset.zero;

  void storeTapPosition(TapDownDetails details) {
    tapPosition = details.globalPosition;
  }

  void showPopupMenu(BuildContext context, List<String> titles,
      List<VoidCallback> onTap) async {
    if (titles.length != onTap.length) {
      throw ArgumentError('Titles and onTap lists must be of the same length');
    }

    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    await showMenu(
      context: context,
      color: primaryColor.withOpacity(0.9),
      elevation: 1,
      position: RelativeRect.fromRect(
        tapPosition & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items: List<PopupMenuEntry<String>>.generate(
        titles.length,
        (index) => PopupMenuItem<String>(
          value: titles[index],
          child: Text(
            titles[index].tr,
            style: bodyStyle.copyWith(color: white),
          ),
        ),
      ),
    ).then((String? result) {
      if (result != null) {
        final int index = titles.indexOf(result);
        if (index != -1) {
          onTap[index]();
        }
      }
    });
  }
}
