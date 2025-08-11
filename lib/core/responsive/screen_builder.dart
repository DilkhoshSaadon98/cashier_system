import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:flutter/material.dart';

class ScreenBuilder extends StatelessWidget {
  final Widget windows, mobile;

  // Constructor to receive desktop and mobile widgets
  const ScreenBuilder({
    super.key,
    required this.windows,
    required this.mobile,
  });

  @override
  Widget build(BuildContext context) {
    // Get device orientation
    Orientation orientation = MediaQuery.of(context).orientation;

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < mobileScreenWidth;
        if (orientation == Orientation.landscape) {
          return windows;
        }

        return isMobile ? mobile : windows;
      },
    );
  }
}
