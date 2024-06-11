import 'package:cashier_system/controller/buying/buying_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/constant/routes.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_formfield_global.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/custom_table_header_global.dart';
import 'package:cashier_system/view/buying/components/custom_dropdown_buying.dart';
import 'package:cashier_system/view/buying/view_details/view_buying_details_table.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewBuyingDetailsScreen extends StatelessWidget {
  const ViewBuyingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
              flex: 7,
              child: Scaffold(
                appBar: customAppBarTitle("Details View"),
                body: Column(
                  children: [
                    CustomTableHeaderGlobal(
                        data: const [
                          "Select",
                          "NO",
                          "Total Price",
                          "Purchaes Date",
                          "Supplier Name",
                          "Payment"
                        ],
                        onDoubleTap: () {},
                        flex: const [1, 2, 3, 3, 3, 1]),
                    const BuyingTableDetailsRows()
                  ],
                ),
              )),
          Expanded(
            flex: 2,
            child: GetBuilder<BuyingController>(builder: (controller) {
              return Container(
                  color: primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomHeaderScreen(
                        imagePath: AppImageAsset.buyingIcons,
                        root: () {
                          Get.toNamed(AppRoute.catagoriesScreen);
                        },
                        title: "Buying",
                      ),
                      customSizedBox(25),
                      Text(
                        "Order By",
                        textAlign: TextAlign.start,
                        style: titleStyle.copyWith(color: white),
                      ),
                      customSizedBox(5),
                      CustomDropDownBuying(
                          contrllerId: controller.groupByIdController,
                          contrllerName: controller.groupByNameController,
                          color: white,
                          iconData: Icons.category,
                          title: "order items",
                          listData: [
                            SelectedListItem(
                                name: 'Items Name', value: 'items_name'),
                            SelectedListItem(
                                name: 'Supplier Name', value: 'users_name'),
                            SelectedListItem(
                                name: 'Buying Date', value: 'purchase_date'),
                          ]),
                      customSizedBox(5),
                      Text(
                        "Search By",
                        textAlign: TextAlign.start,
                        style: titleStyle.copyWith(color: white),
                      ),
                      customSizedBox(5),
                      Form(
                        child: SizedBox(
                          height: 350,
                          child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return customSizedBox(10);
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
                                    borderColor: white,
                                    isNumber: false);
                              }),
                        ),
                      ),
                      const Spacer(),
                      customButtonGlobal(() async {
                        await controller.getPurchaseDetailsData(controller
                            .purchaseDetailsData[0].purchaseNumber
                            .toString());
                      }, "Search", Icons.search)
                    ],
                  ));
            }),
          ),
        ],
      ),
    );
  }
}
