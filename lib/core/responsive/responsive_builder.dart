import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:flutter/material.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget windows, mobile;
  const ResponsiveBuilder(
      {super.key, required this.windows, required this.mobile});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return constraints.maxWidth > mobileScreeenWidth ? windows : mobile;
    });
  }
}
