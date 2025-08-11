import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class CustomTableHeaderGlobal extends StatelessWidget {
  final List<String> data;
  final List<int> flex;
  void Function()? onDoubleTap;
  CustomTableHeaderGlobal({
    super.key,
    required this.data,
    required this.onDoubleTap,
    required this.flex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: tableHeaderColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(data.length, (index) {
            return Expanded(
              flex: flex[index],
              child: GestureDetector(
                onDoubleTap: index == 0 ? onDoubleTap : null,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: tableHeaderColor,
                      border: Border.all(width: .3, color: primaryColor)),
                  child: Text(
                    data[index].tr,
                    style: titleStyle.copyWith(color: white),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
