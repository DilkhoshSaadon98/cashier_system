import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/custom_divider.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewCreditorDetails extends StatelessWidget {
  const ViewCreditorDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarTitle("View Data", true),
      body: Container(
        padding: const EdgeInsets.all(15),
        width: Get.width,
        child: Wrap(
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.center,
          runSpacing: 10,
          spacing: 20,
          children: [
            _buildCard("Dept Invoices", "Total Invoices",
                "Total Invoices Balance", 5, 5),
            _buildCard(
                "Imports", "Total Imports", "Total Imports Balance", 5, 5),
            _buildCard(
                "Exports", "Total Exports", "Total Exports Balance", 5, 5),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      String title, String label1, String label2, int value1, int value2) {
    return SizedBox(
      height: 300,
      width: 300,
      child: Card(
        color: Colors.grey[300],
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: titleStyle.copyWith(fontSize: 26),
              ),
              customSizedBox(),
              customDivider(),
              customSizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    label1,
                    style: bodyStyle.copyWith(fontSize: 20),
                  ),
                  Text(
                    value1.toString(),
                    style: bodyStyle.copyWith(fontSize: 20),
                  ),
                ],
              ),
              customSizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    label2,
                    style: bodyStyle.copyWith(fontSize: 20),
                  ),
                  Text(
                    formattingNumbers(value2),
                    style: bodyStyle.copyWith(fontSize: 20),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
