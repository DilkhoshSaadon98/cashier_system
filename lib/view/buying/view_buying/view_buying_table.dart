import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/custom_table_header_global.dart';
import 'package:cashier_system/view/buying/components/buying_table_view.dart';
import 'package:flutter/material.dart';

class ViewBuyingTable extends StatelessWidget {
  const ViewBuyingTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarTitle("Buying View"),
      body: Column(
        children: [
          CustomTableHeaderGlobal(
              data: const [
                "Select",
                "NO",
                "Items Name",
                "Items Purchase",
                "QTY",
                "Purchaes Date",
                "Supplier Name",
                "Payment"
              ],
              onDoubleTap: () {},
              flex: const [1, 1, 3, 2, 1, 2, 2, 1]),
          const BuyingTableRows()
        ],
      ),
    );
  }
}
