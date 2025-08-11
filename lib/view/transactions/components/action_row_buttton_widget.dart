import 'package:cashier_system/core/constant/color.dart';
import 'package:flutter/material.dart';

Widget actionRowButtonWidget({
  final Function()? onPressedAdd,
  final Function()? onPressedPrint,
  final Function()? onPressedClearFileds,
  final Function()? onPressedRemove,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      CircleAvatar(
        backgroundColor: Colors.red,
        radius: 25,
        child: IconButton(
            onPressed: onPressedRemove,
            icon: const Icon(
              Icons.delete_sweep_outlined,
              color: white,
            )),
      ),
      CircleAvatar(
          backgroundColor: secondColor,
          radius: 25,
          child: IconButton(
              onPressed: onPressedClearFileds,
              icon: const Icon(Icons.refresh, color: white))),
      CircleAvatar(
          backgroundColor: thirdColor,
          radius: 25,
          child: IconButton(
              onPressed: onPressedPrint,
              icon: const Icon(Icons.print, color: white))),
      CircleAvatar(
          backgroundColor: Colors.teal,
          radius: 25,
          child: IconButton(
              onPressed: onPressedAdd,
              icon: const Icon(Icons.add, color: white))),
    ],
  );
}
