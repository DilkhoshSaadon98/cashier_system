import 'package:cashier_system/core/constant/color.dart';
import 'package:flutter/material.dart';

Widget tableCellChangeNumber(String text,
    {double cellWidth = 75,
    void Function()? onTapAdd,
    void Function(String)? onValueChanged,
    void Function()? onTapRemove}) {
  TextEditingController qtyController = TextEditingController();
  qtyController.text = text;
  return SizedBox(
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      excludeFromSemantics: true,
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
              flex: 2,
              child: TextFormField(
                controller: qtyController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                  border: UnderlineInputBorder(),
                  
                ),
                onChanged: onValueChanged,
              )),
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
