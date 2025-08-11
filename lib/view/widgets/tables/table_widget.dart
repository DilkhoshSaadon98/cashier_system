// ignore_for_file: deprecated_member_use

import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/custom_scroll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TableWidget extends StatelessWidget {
  final List<String> columns;
  final List<List<Widget>> rows;
  final List<int> flexes;
  final bool showHeader;
  final ScrollController? horizontalScrollController;
  final ScrollController? verticalScrollController;
  final void Function(int rowIndex)? onRowDoubleTap;
  final void Function(int columnIndex)? onHeaderDoubleTap;
  final bool allSelected;

  const TableWidget({
    super.key,
    required this.columns,
    required this.rows,
    required this.flexes,
    this.showHeader = true,
    this.horizontalScrollController,
    this.verticalScrollController,
    this.onRowDoubleTap,
    this.onHeaderDoubleTap,
    required this.allSelected,
  });

  @override
  Widget build(BuildContext context) {
    int totalFlex = flexes.reduce((a, b) => a + b);
    double columnBaseWidth = 95.0;
    double tableWidth = totalFlex * columnBaseWidth;

    return ScrollConfiguration(
      behavior: CustomScrollBehavior(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: horizontalScrollController,
        child: SizedBox(
          width: tableWidth.w,
          child: Column(
            children: [
              if (showHeader)
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: buttonColor,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade400, width: 1),
                    ),
                  ),
                  child: Row(
                    children: List.generate(
                      columns.length,
                      (index) {
                        if (index == 0) {
                          return GestureDetector(
                            onDoubleTap: () {
                              if (onHeaderDoubleTap != null) {
                                onHeaderDoubleTap!(index);
                              }
                            },
                            child: Container(
                              width: 50.w,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      color: Colors.grey.shade300, width: 1),
                                ),
                              ),
                              child: Checkbox(
                                value: allSelected,
                                onChanged: (bool? value) {
                                  if (onHeaderDoubleTap != null) {
                                    onHeaderDoubleTap!(index);
                                  }
                                },
                              ),
                            ),
                          );
                        } else {
                          return Flexible(
                            flex: flexes[index],
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      color: Colors.grey.shade300, width: 1),
                                ),
                              ),
                              child: Text(
                                columns[index].tr,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: bodyStyle.copyWith(color: white),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              Expanded(
                child: Container(
                  color: white,
                  child: SingleChildScrollView(
                    controller: verticalScrollController,
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: List.generate(rows.length, (rowIndex) {
                        final row = rows[rowIndex];
                        bool isSelected =
                            row.last.key == const ValueKey("selected");
                        bool isGift = row.last.key == const ValueKey("gift");

                        return Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue.withOpacity(0.15)
                                : isGift
                                    ? Colors.red.withOpacity(0.1)
                                    : Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.shade300, width: 0.8),
                            ),
                          ),
                          child: Row(
                            children: List.generate(row.length - 1, (colIndex) {
                              if (colIndex == 0) {
                                return Container(
                                  width: 50.w,
                                  alignment: Alignment.centerLeft,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.w),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                          color: Colors.grey.shade200,
                                          width: 0.8),
                                    ),
                                  ),
                                  child: row[colIndex],
                                );
                              } else {
                                return Flexible(
                                  flex: flexes[colIndex],
                                  child: GestureDetector(
                                    onDoubleTap: () {
                                      if (onRowDoubleTap != null) {
                                        onRowDoubleTap!(rowIndex);
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.w),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                              color: Colors.grey.shade200,
                                              width: 0.8),
                                        ),
                                      ),
                                      child: row[colIndex],
                                    ),
                                  ),
                                );
                              }
                            }),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
