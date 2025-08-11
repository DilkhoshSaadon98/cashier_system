import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:flutter/material.dart';
// ignore: must_be_immutable
class CustomTableWidget extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final double? headerHight;
  final double? cellsHight;
  double? columnSpacing;
  CustomTableWidget(
      {super.key,
      required this.columns,
      required this.rows,
      this.columnSpacing,
      this.headerHight,
      this.cellsHight});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          headingRowHeight: headerHight ?? 40,
          // ignore: deprecated_member_use
          dataRowHeight: cellsHight ?? 35,
          border: TableBorder.all(width: 0.5),
          dataRowColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                // ignore: deprecated_member_use
                return primaryColor.withOpacity(0.1);
              }
              return Colors.white; // Default color for unselected rows
            },
          ),
          headingRowColor: WidgetStateProperty.all(tableHeaderColor),
          dataTextStyle: titleStyle.copyWith(fontSize: 14),
          columns: columns,
          rows: rows,
        ),
      ),
    );
  }
}
