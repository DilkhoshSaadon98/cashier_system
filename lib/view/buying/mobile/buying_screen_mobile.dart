import 'package:cashier_system/controller/buying/buying_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/date_picker.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/buttons/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/drop_downs/custom_drop_down_search.dart';
import 'package:cashier_system/core/shared/drop_downs/custom_drop_down_search_users.dart';
import 'package:cashier_system/core/shared/custom_formfield_global.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/custom_table_headers.dart';
import 'package:cashier_system/core/shared/custom_table_widget.dart';
import 'package:cashier_system/view/buying/components/custom_dropdown_buying.dart';
import 'package:cashier_system/view/buying/windows/view_buying/view_buying_table.dart';
import 'package:cashier_system/view/widgets/tables/table_widget.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyingScreenMobile extends StatelessWidget {
  const BuyingScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(BuyingController());
    return Scaffold(
      backgroundColor: mobileScreenBackgroundColor,
      appBar: customAppBarTitle("Buying", true),
      body: GetBuilder<BuyingController>(builder: (controller) {
        return DefaultTabController(
          initialIndex: 0,
          length: 2,
          child: Column(
            children: [
              Container(
                color: tableHeaderColor,
                child: TabBar(
                    dividerColor: primaryColor,
                    dividerHeight: 1,
                    unselectedLabelColor: white,
                    indicatorColor: secondColor,
                    indicatorSize: TabBarIndicatorSize.tab,
                    automaticIndicatorColorAdjustment: true,
                    labelColor: secondColor,
                    onTap: (index) {},
                    tabs: [
                      Tab(
                        child: Text(
                          "Search".tr,
                          style: titleStyle.copyWith(color: white),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Add".tr,
                          style: titleStyle.copyWith(color: white),
                        ),
                      ),
                    ]),
              ),
              Expanded(
                  child: TabBarView(
                children: [
                  //? View Side :
                  Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Order By",
                            textAlign: TextAlign.start,
                            style: titleStyle.copyWith(color: primaryColor),
                          ),
                          verticalGap(5),
                          CustomDropDownBuying(
                              contrllerId: controller.groupByIdController,
                              contrllerName: controller.groupByNameController,
                              color: primaryColor,
                              iconData: Icons.category,
                              title: "order items",
                              listData: [
                                SelectedListItem(
                                    name: 'Items Name', value: 'items_name'),
                                SelectedListItem(
                                    name: 'Supplier Name', value: 'users_name'),
                                SelectedListItem(
                                    name: 'Buying Date',
                                    value: 'purchase_date'),
                              ]),
                          verticalGap(5),
                          Text(
                            "Search By",
                            textAlign: TextAlign.start,
                            style: titleStyle.copyWith(color: primaryColor),
                          ),
                          verticalGap(5),
                          Form(
                            child: Expanded(
                              child: ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return verticalGap(10);
                                  },
                                  itemCount: controller.itemsTitle.length,
                                  itemBuilder: (context, index) {
                                    return CustomTextFormFieldGlobal(
                                        onTap: index == 2
                                            ? () {
                                                selectDate(
                                                    context,
                                                    controller.itemsController[
                                                        index]!);
                                              }
                                            : null,
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
                          customButtonGlobal(() async {
                            controller.getPurchaseData(isInitialSearch: true);
                            Get.to(() => const ViewBuyingTable(
                                  showBackButton: true,
                                ));
                          }, "Show Data", Icons.search, primaryColor, white,
                              null, 50)
                        ],
                      )),
                  //? Add Side
                  GetBuilder<BuyingController>(builder: (controller) {
                    return Column(
                      children: [
                        // Expanded(
                        //   flex: 2,
                        //   child: TableWidget(
                        //     allSelected: false,
                        //     flexes: [1, 1, 1, 1, 1, 1, 1],
                        //     columns: [
                        //       "",
                        //       "Code",
                        //       "Items Name",
                        //       "Purchase Price",
                        //       "QTY",
                        //       "Total Price",
                        //       "Total Price Discount"
                        //     ],
                        //     rows: controller.rows,
                        //   ),
                        // ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Form(
                                  //  key: controller.formKey,
                                  child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomDropDownSearchUsersGlobal(
                                          listData:
                                              controller.dropDownListUsers,
                                          color: primaryColor,
                                          contrllerId:
                                              controller.supplierIdController,
                                          contrllerName:
                                              controller.supplierNameController,
                                          title: "Supplier Name",
                                          iconData: Icons.person,
                                          valid: (value) {
                                            return validInput(
                                              value!,
                                              0,
                                              1000,
                                              "",
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: CustomDropDownSearch(
                                            valid: (value) {
                                              return validInput(
                                                  value!, 0, 1000, "");
                                            },
                                            iconData: Icons.payment,
                                            title: "Payment",
                                            color: primaryColor,
                                            contrllerName: controller
                                                .paymentMethodNameController,
                                            contrllerId: controller
                                                .paymentMethodIdController,
                                            listData: [
                                              SelectedListItem(
                                                  name: "Cash", value: "cash"),
                                              SelectedListItem(
                                                  name: "Dept", value: "dept"),
                                            ]),
                                      ),
                                    ],
                                  ),
                                  verticalGap(5),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomTextFormFieldGlobal(
                                            suffixIconData: Icons.check,
                                            hinttext: "Discount",
                                            labeltext: "Discount",
                                            mycontroller: controller
                                                .purchaseDiscountController,
                                            iconData: Icons.discount_outlined,
                                            valid: (value) {
                                              return validInput(
                                                  value!, 0, 100, "realNumber",
                                                  required: false);
                                            },
                                            borderColor: primaryColor,
                                            isNumber: true),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: CustomTextFormFieldGlobal(
                                            suffixIconData: Icons.check,
                                            hinttext: "Fees",
                                            labeltext: "Fees",
                                            mycontroller: controller
                                                .purchaseFeesController,
                                            iconData: Icons.discount_outlined,
                                            valid: (value) {
                                              return validInput(
                                                  value!, 0, 100, "realNumber",
                                                  required: false);
                                            },
                                            onChanged: (value) {
                                              // controller
                                              //     .calculateDiscount(value);
                                            },
                                            borderColor: primaryColor,
                                            isNumber: true),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: customButtonGlobal(() async {
                                          controller.addItems(context);
                                        }, "Save", Icons.save, buttonColor,
                                            white, null, 50),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: customButtonGlobal(() async {
                                          controller.calculatePrice();
                                        }, "Calculate", Icons.calculate,
                                            whiteButtonColor, white),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ))
            ],
          ),
        );
      }),
    );
  }
}
