import 'package:cashier_system/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:get/get.dart';

class CustomShowPopupMenu {
  Offset tapPosition = const Offset(100, 100);

  // Store the tap position when the user taps down
  void storeTapPosition(TapDownDetails details) {
    tapPosition =
        details.globalPosition; // Store the global position of the tap
  }

  // Show popup menu at the stored tap position
  void showPopupMenu(BuildContext context, List<String> titles,
      List<VoidCallback> onTap) async {
    if (titles.length != onTap.length) {
      throw ArgumentError('Titles and onTap lists must be of the same length');
    }
    await showMenu(
      context: context,
      color: whiteNeon,
      elevation: 1,
      position: RelativeRect.fromLTRB(
        tapPosition.dx,
        tapPosition.dy + 20,
        MediaQuery.of(context).size.width - tapPosition.dx, // Right padding
        MediaQuery.of(context).size.height - tapPosition.dy, // Bottom padding
      ),
      items: List<PopupMenuEntry<String>>.generate(
        titles.length,
        (index) => PopupMenuItem<String>(
          value: titles[index],
          child: Text(
            titles[index].tr,
            style: bodyStyle.copyWith(color: primaryColor),
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
