import 'package:cashier_system/controller/buying/buying_details_view_controller.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/custom_table_headers.dart';
import 'package:cashier_system/core/shared/custom_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewBuyingDetailsScreenMobile extends StatelessWidget {
  final bool? showBackButton;
  const ViewBuyingDetailsScreenMobile({super.key, this.showBackButton});

  @override
  Widget build(BuildContext context) {
    BuyingDetailsViewController controller =
        Get.put(BuyingDetailsViewController());
    return Scaffold(
      appBar: customAppBarTitle("Details View", controller.showBackButton),
      body: Column(
        children: [
          GetBuilder<BuyingDetailsViewController>(builder: (controller) {
            return CustomTableWidget(
                columns: customTableHeaders([
                  "Code",
                  "Items Name",
                  "Purchase Price",
                  "QTY",
                  "Supplier Name",
                  "Date",
                  "Payment"
                ]),
                rows: [
                  // ...List<DataRow>.generate(
                  //     controller.purchaseDetailsData.length, (index) {
                  //   var dataItem = controller.purchaseDetailsData[index];
                  //   return DataRow(cells: [
                  //     DataCell(Center(
                  //       child: Text(dataItem.purchaseItemsId.toString()),
                  //     )),
                  //     DataCell(Center(
                  //       child: Text(dataItem.itemName!),
                  //     )),
                  //     DataCell(Center(
                  //       child: Text(formattingNumbers(dataItem.purchasePrice)),
                  //     )),
                  //     DataCell(Center(
                  //       child: Text(dataItem.purchaseQuantity.toString()),
                  //     )),
                  //     DataCell(Center(
                  //       child: Text(dataItem.supplierName ?? "UNKNOWN".tr),
                  //     )),
                  //     DataCell(Center(
                  //       child: Text(dataItem.purchaseDate!),
                  //     )),
                  //     DataCell(Center(
                  //       child: Text(dataItem.purchasePayment!),
                  //     )),
                  //   ]);
                  // })
                ]);
          }),
        ],
      ),
    );
  }
}
