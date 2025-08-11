import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/screen_routes.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget screenActionButtonWidget(
  BuildContext context, {
  Color? backColor,
  void Function()? onPressedSearch,
  void Function()? onPressedPrint,
  void Function()? onPressedClear,
  void Function()? onPressedRemove,
  void Function()? onPressedAdd,
}) {
  return Container(
      width: Get.width,
      height: 50,
      alignment: Alignment.center,
      color: backColor ?? primaryColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (onPressedSearch != null)
              CircleAvatar(
                  radius: 25,
                  backgroundColor: buttonColor,
                  child: IconButton(
                      tooltip: TextRoutes.searchItems.tr,
                      onPressed: onPressedSearch,
                      icon: const Icon(
                        Icons.search,
                        size: 25,
                        color: white,
                      ))),
            if (onPressedAdd != null) ...[
              horizontalGap(),
              CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.teal,
                  child: IconButton(
                      onPressed: onPressedAdd,
                      tooltip: TextRoutes.add.tr,
                      icon: const Icon(
                        size: 25,
                        Icons.add,
                        color: white,
                      ))),
            ],
            if (onPressedPrint != null) ...[
              horizontalGap(),
              CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.blue,
                  child: GestureDetector(
                    onLongPress: () {
                      Get.toNamed(AppRoute.invoiceScreen);
                    },
                    child: IconButton(
                        tooltip:
                            '${TextRoutes.print.tr}\n${TextRoutes.longPressToUpdateSettings.tr}',
                        onPressed: onPressedPrint,
                        icon: const Icon(
                          size: 25,
                          Icons.print,
                          color: white,
                        )),
                  ))
            ],
            if (onPressedClear != null) ...[
              horizontalGap(),
              CircleAvatar(
                  radius: 25,
                  backgroundColor: secondColor,
                  child: IconButton(
                      onPressed: onPressedClear,
                      tooltip: TextRoutes.clearFileds.tr,
                      icon: const Icon(
                        size: 25,
                        Icons.refresh_outlined,
                        color: white,
                      ))),
            ],
            if (onPressedRemove != null) ...[
              horizontalGap(),
              CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.red,
                  child: IconButton(
                      onPressed: onPressedRemove,
                      tooltip: TextRoutes.remove.tr,
                      icon: const Icon(
                        size: 25,
                        Icons.clear,
                        color: white,
                      ))),
            ]
          ],
        ),
      ));
}
