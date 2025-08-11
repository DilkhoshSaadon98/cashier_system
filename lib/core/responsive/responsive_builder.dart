import 'package:flutter/widgets.dart';

class ResponsiveBuilder {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 850;
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
      MediaQuery.of(context).size.width > 850;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;
}
