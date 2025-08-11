import 'package:cashier_system/controller/reports/financial_reports_controller.dart';
import 'package:cashier_system/controller/reports/inventory_reports_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/view/widgets/tables/table_cell.dart';
import 'package:cashier_system/view/widgets/tables/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class IncomeStatementTable extends StatelessWidget {
  final FinancialReportsController controller;
  const IncomeStatementTable({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 15,
      children: [
        Container(
          alignment: AlignmentDirectional.center,
          width: 500,
          height: 75,
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 46, 107, 48)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              Text(
                "total revenues",
                style: titleStyle.copyWith(color: white),
              ),
              Text(
                formattingNumbers(controller.totalRevenues),
                style: titleStyle.copyWith(color: white),
              ),
            ],
          ),
        ),
        Container(
          alignment: AlignmentDirectional.center,
          width: 500,
          height: 75,
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 46, 59, 107)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              Text(
                "total expenses",
                style: titleStyle.copyWith(color: white),
              ),
              Text(
                formattingNumbers(controller.totalExpenses),
                style: titleStyle.copyWith(color: white),
              ),
            ],
          ),
        ),
        Container(
          alignment: AlignmentDirectional.center,
          width: 500,
          height: 75,
          decoration: BoxDecoration(
              color: controller.totalProfits.isLowerThan(0)
                  ? Colors.red
                  : controller.totalProfits.isGreaterThan(0)
                      ? Colors.greenAccent
                      : Colors.amber),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              Text(
                "total profits",
                style: titleStyle.copyWith(color: white),
              ),
              Text(
                formattingNumbers(controller.totalProfits),
                style: titleStyle.copyWith(color: white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
