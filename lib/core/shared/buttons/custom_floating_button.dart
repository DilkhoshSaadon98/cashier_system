import 'package:cashier_system/core/constant/color.dart';
import 'package:flutter/material.dart';

Widget customFloatingButton(
    bool showBackToTopButton, ScrollController scrollController) {
  return showBackToTopButton
      ? FloatingActionButton.small(
        
          backgroundColor: primaryColor,
          onPressed: () {
            scrollController.animateTo(
              0.0,
              duration: const Duration(milliseconds: 100),
              curve: Curves.fastLinearToSlowEaseIn,
            );
          },
          child: const Icon(
            Icons.keyboard_arrow_up,
            color: secondColor,
          ),
        )
      : Container();
}
