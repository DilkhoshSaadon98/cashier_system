import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/responsive/responsive_builder.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showFormDialog(BuildContext context,
    {bool? isUpdate, String? addText, String? editText, Widget? child}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(constRadius),
          side: const BorderSide(
            color: primaryColor,
            width: .5,
          ),
        ),
        titlePadding:
            const EdgeInsets.only(left: 16, right: 8, top: 16, bottom: 0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  !(isUpdate ?? false)
                      ? (addText ?? '').tr.toUpperCase()
                      : (editText ?? '').tr.toUpperCase(),
                  style: titleStyle,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
              tooltip: TextRoutes.close.tr,
            ),
          ],
        ),
        content: child,
      );
    },
  );
}

Widget dialogButtonWidget(BuildContext context, void Function()? onPressed) {
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: ResponsiveBuilder.isMobile(context)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: _buildButtons(
                context,
                onPressed,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: _buildButtons(
                context,
                onPressed,
              ),
            ));
}

List<Widget> _buildButtons(
  BuildContext context,
  void Function()? onPressed,
) {
  return [
    SizedBox(
      width: 130,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.cancel),
        label: Text(
          TextRoutes.cancel.tr,
          overflow: TextOverflow.clip,
          style: bodyStyle.copyWith(color: white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
      ),
    ),
    !ResponsiveBuilder.isMobile(context) ? horizontalGap(5) : verticalGap(5),
    SizedBox(
      width: 130,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.check),
        label: Text(
          TextRoutes.submit.tr,
          overflow: TextOverflow.clip,
          style: bodyStyle.copyWith(color: white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
    ),
  ];
}
