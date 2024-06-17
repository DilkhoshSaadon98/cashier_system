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
                "NO",
                "Total Price",
                "Purchaes Date",
                "Supplier Name",
                "Payment"
              ],
              onDoubleTap: () {},
              flex: const [2, 3, 3, 3, 1]),
          const BuyingTableRows()
        ],
      ),
    );
  }
}
