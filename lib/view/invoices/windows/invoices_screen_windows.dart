import 'package:cashier_system/controller/printer/invoice_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/functions/change_direction.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/responsive/divide_screen_widget.dart';
import 'package:cashier_system/core/responsive/screen_builder.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/view/invoices/shared/design_barcode.dart';
import 'package:cashier_system/view/invoices/shared/design_page.dart';
import 'package:cashier_system/view/invoices/shared/printing_barcode.dart';
import 'package:cashier_system/view/invoices/shared/printing_widget.dart';
import 'package:cashier_system/view/invoices/mobile/invoice_screen_mobile.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';




class InvoicesScreenWindows extends StatelessWidget {
  const InvoicesScreenWindows({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// class InvoicesScreenWindows extends StatelessWidget {
//   const InvoicesScreenWindows({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Get.put(InvoiceController());
//     return ScreenBuilder(
//       windows: Scaffold(
//         backgroundColor: white,
//         body: GetBuilder<InvoiceController>(builder: (controller) {
//           return DivideScreenWidget(
//             //? Display Print layout:
//             showWidget: controller.selectedIndex == 0
//                 ? const PrintingWidget(
//                     headerData: {},
//                     tableData: {},
//                   )
//                 : const PrintingBarcode(),
//             //? Customize Print layout:

//             actionWidget: DefaultTabController(
//                 length: 2,
//                 child: Column(
//                   children: [
//                     const CustomHeaderScreen(
//                       imagePath: AppImageAsset.settingIcons,
//                       title: TextRoutes.invoices,
//                     ),
//                     verticalGap(),
//                     Container(
//                       color: buttonColor,
//                       child: TabBar(
//                         dividerColor: primaryColor,
//                         dividerHeight: 1,
//                         unselectedLabelColor: white,
//                         indicatorColor: secondColor,
//                         indicatorSize: TabBarIndicatorSize.tab,
//                         automaticIndicatorColorAdjustment: true,
//                         dragStartBehavior: DragStartBehavior.start,
//                         labelColor: secondColor,
//                         onTap: (index) {
//                           controller.changeIndex(index);
//                           if (index == 1) {
//                             controller.getItems();
//                           }
//                         },
//                         tabs: [
//                           Tab(
//                             child: Text(
//                               TextRoutes.invoices.tr,
//                               style: bodyStyle.copyWith(color: white),
//                             ),
//                           ),
//                           Tab(
//                             child: Text(
//                               TextRoutes.barcode.tr,
//                               style: bodyStyle.copyWith(color: white),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const Expanded(
//                         child: TabBarView(children: [
//                       DesignPage(
//                         isWindows: true,
//                       ),
//                       DesignBarcode(
//                         isWindows: true,
//                       ),
//                     ]))
//                   ],
//                 )),
//           );
//         }),
//       ),
//       mobile: const InvoiceScreenMobile(),
//     );
//   }
// }
