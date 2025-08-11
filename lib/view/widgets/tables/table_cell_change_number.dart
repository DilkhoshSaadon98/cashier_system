import 'package:cashier_system/core/constant/color.dart';
import 'package:flutter/material.dart';

Widget tableCellChangeNumber(String text,
    {double cellWidth = 75,
    void Function()? onTapAdd,
    void Function()? onTapRemove}) {
  return SizedBox(
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      excludeFromSemantics: true,
      onTap: () {},
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onDoubleTap: onTapAdd,
              child: IconButton(
                  onPressed: onTapAdd,
                  icon: const Icon(
                    Icons.add,
                    color: primaryColor,
                  )),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onDoubleTap: onTapRemove,
              child: IconButton(
                  onPressed: onTapRemove,
                  icon: const Icon(
                    Icons.remove,
                    color: Colors.red,
                  )),
            ),
          ),
        ],
      ),
    ),
  );
}
