import 'package:cashier_system/controller/buying/buying_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddBuyingTable extends StatelessWidget {
  const AddBuyingTable({super.key});

  @override
  Widget build(BuildContext context) {
   Get.put(BuyingController());
    return GetBuilder<BuyingController>(
      builder: (controller) {
        return Scaffold(
          appBar: customAppBarTitle("Buying Items"),
          floatingActionButton: FloatingActionButton.extended(
              shape: const CircleBorder(),
              backgroundColor: primaryColor,
              label: const Icon(
                Icons.add,
                color: secondColor,
              ),
              onPressed: () {
                controller.rows.add(controller.createRow());
              }),
          body: Container(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: SizedBox(
                width: Get.width,
                child: DataTable(
                  dataRowColor: WidgetStatePropertyAll(tableRowColor),
                  //  dataTextStyle: titleStyle,
                  dividerThickness: 1,
                  headingRowColor: WidgetStatePropertyAll(primaryColor),
                  headingTextStyle: titleStyle.copyWith(color: white),
                  border: TableBorder.all(width: 2, color: thirdColor),
                  columns: const [
                    DataColumn(
                        headingRowAlignment: MainAxisAlignment.center,
                        label: Text(textAlign: TextAlign.center, 'Item Code')),
                    DataColumn(
                        headingRowAlignment: MainAxisAlignment.center,
                        label: Text('Item Name')),
                    DataColumn(
                        headingRowAlignment: MainAxisAlignment.center,
                        label: Text('Buying Price')),
                    DataColumn(
                        headingRowAlignment: MainAxisAlignment.center,
                        label: Text('Quantity')),
                    DataColumn(
                        headingRowAlignment: MainAxisAlignment.center,
                        label: Text('Total Price')),
                  ],
                  rows: controller.rows,
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
