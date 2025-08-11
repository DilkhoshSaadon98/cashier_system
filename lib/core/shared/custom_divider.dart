import 'package:cashier_system/core/constant/color.dart';
import 'package:flutter/material.dart';

Widget customDivider([Color? color]) {
  return Divider(
    thickness: 1,
    color:color?? primaryColor,
  );
}
