import 'package:cashier_system/controller/setting/setting_controller.dart';

class InvoiceController extends SettingController {
  List<String> tablesTileTitle = [
    "Item Code",
    "Item Name",
    "Item Type",
    "Item QTY",
    "Item Price",
    "Item Total Price",
  ];
  List<bool> tablesTileState = [
    true,
    true,
    false,
    false,
    false,
    false,
  ];
  List<String> tileTitle = [
    "Customer Name",
    "Orgnizer Name",
    "Account Name",
    "Number Of Items",
    "Customer Phone",
    "Customer Address",
    "Invoice number",
    "Date",
    "Discount",
    "Taxes",
  ];
  List<bool> tileState = [
    true,
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  // Method to get selected columns
  List<String> get selectedColumns {
    List<String> selected = ["#"];
    for (int i = 0; i < tablesTileState.length; i++) {
      if (tablesTileState[i]) {
        selected.add(tablesTileTitle[i]);
      }
    }
    return selected;
  }
}
