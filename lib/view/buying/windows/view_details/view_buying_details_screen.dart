import 'package:cashier_system/controller/buying/buying_details_view_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/constant/screen_routes.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/buttons/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_formfield_global.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/custom_table_headers.dart';
import 'package:cashier_system/core/shared/custom_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewBuyingDetailsScreen extends StatelessWidget {
  const ViewBuyingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BuyingDetailsViewController controller =
        Get.put(BuyingDetailsViewController());
    return Scaffold(
      body: Row(
        children: [
          Expanded(
              flex: 7,
              child: Scaffold(
                appBar: customAppBarTitle("Details View"),
                body: Column(
                  children: [
                    GetBuilder<BuyingDetailsViewController>(builder: (context) {
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
                            //   var dataItem =
                            //       controller.purchaseDetailsData[index];
                            //   return DataRow(cells: [
                            //     DataCell(Center(
                            //       child: Text(dataItem.purchaseId.toString()),
                            //     )),
                            //     DataCell(Center(
                            //       child: Text(dataItem.itemName!),
                            //     )),
                            //     DataCell(Center(
                            //       child: Text(formattingNumbers(
                            //           dataItem.purchasePrice)),
                            //     )),
                            //     DataCell(Center(
                            //       child: Text(
                            //           dataItem.purchaseQuantity.toString()),
                            //     )),
                            //     DataCell(Center(
                            //       child: Text(
                            //           dataItem.supplierName ?? "UNKNOWN".tr),
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
              )),
          Expanded(
            flex: 2,
            child:
                GetBuilder<BuyingDetailsViewController>(builder: (controller) {
              return Container(
                  color: primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomHeaderScreen(
                        imagePath: AppImageAsset.buyingIcons,
                        title: "Buying",
                      ),
                      verticalGap(25),
                      Text(
                        "Search By".tr,
                        textAlign: TextAlign.start,
                        style: titleStyle.copyWith(color: white),
                      ),
                      verticalGap(5),
                      Form(
                        child: SizedBox(
                          height: 350,
                          child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return verticalGap(10);
                              },
                              itemCount: controller.itemsTitle.length,
                              itemBuilder: (context, index) {
                                return CustomTextFormFieldGlobal(
                                    mycontroller:
                                        controller.itemsController[index],
                                    hinttext: controller.itemsTitle[index],
                                    labeltext: controller.itemsTitle[index],
                                    iconData: Icons.search_outlined,
                                    valid: (value) {
                                      return validInput(value!, 0, 100, "");
                                    },
                                    borderColor: primaryColor,
                                    isNumber: false);
                              }),
                        ),
                      ),
                      const Spacer(),
                      customButtonGlobal(() async {
                        await controller.getPurchaseDetailsData(controller
                            .purchaseDetailsData[0].purchaseNumber
                            .toString());
                      }, "Search", Icons.search, buttonColor, white),
                      GestureDetector(
                        onLongPress: () {
                          Get.toNamed(AppRoute.invoiceScreen);
                        },
                        child: customButtonGlobal(() async {
                          controller.printingData();
                        }, "Print", Icons.print, Colors.blueAccent, white),
                      )
                    ],
                  ));
            }),
          ),
        ],
      ),
    );
  }
}
