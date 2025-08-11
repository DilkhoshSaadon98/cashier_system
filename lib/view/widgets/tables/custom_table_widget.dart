import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/view/widgets/tables/custom_table_headers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTableWidget extends StatelessWidget {
  final List<String> columns;
  final List<DataRow> rows;
  final List<double> cellWidth;
  final bool? showHeader;
  final ScrollController? horizontalScrollControllers;
  final ScrollController? verticalScrollControllers;

  const CustomTableWidget({
    super.key,
    required this.columns,
    required this.rows,
    required this.cellWidth,
    this.showHeader,
    this.horizontalScrollControllers,
    this.verticalScrollControllers,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: horizontalScrollControllers,
      child: Column(
        children: [
          // if (showHeader ?? false)
          //   SizedBox(
          //     height: 50,
          //     child: DataTable(
          //       headingRowHeight: 45,
          //       // ignore: deprecated_member_use
          //       dataRowHeight: 40,
          //       border: TableBorder.all(width: 0.5),

          //       dataTextStyle: titleStyle.copyWith(fontSize: 14.sp),
          //       headingRowColor: WidgetStateProperty.all(buttonColor),
          //       columns: customTableHeaders(columns, cellWidth),
          //       rows: const [],
          //     ),
          //   ),
          Expanded(
            child: SingleChildScrollView(
              controller: verticalScrollControllers,
              scrollDirection: Axis.vertical,
              child: DataTable(
                headingRowHeight: 45.h,
                // ignore: deprecated_member_use
                dataRowHeight: 40.h,
                border: TableBorder.all(width: 0.5),

                dataRowColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      // ignore: deprecated_member_use
                      return primaryColor.withOpacity(0.1);
                    }
                    return Colors.white;
                  },
                ),
                dataTextStyle: titleStyle.copyWith(fontSize: 14.sp),
                headingRowColor: WidgetStateProperty.all(buttonColor),
                columns: customTableHeaders(columns, cellWidth),
                rows: rows,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
