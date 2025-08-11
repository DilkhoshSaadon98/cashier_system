import 'package:cashier_system/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> selectDate(
  BuildContext context,
  TextEditingController controller,
) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    locale: const Locale('ar'),
    barrierColor: primaryColor.withOpacity(.3),
    initialDate: DateTime.now(),
    firstDate: DateTime(2024, 1),
    lastDate: DateTime(2101),
    builder: (context, child) => child!,
  );

  if (picked != null) {
    controller.text = DateFormat('yyyy-MM-dd HH:mm:ss').format(picked);
  }
}
