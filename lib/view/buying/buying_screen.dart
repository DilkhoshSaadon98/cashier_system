import 'package:cashier_system/controller/buying/buying_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/constant/routes.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/shared/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_drop_down_search.dart';
import 'package:cashier_system/core/shared/custom_formfield_global.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/view/buying/add_buying/add_buying_table.dart';
import 'package:cashier_system/view/buying/components/custom_dropdown_buying.dart';
import 'package:cashier_system/view/buying/view_buying/view_buying_table.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyingScreen extends StatelessWidget {
  const BuyingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(BuyingController());
    return Scaffold(
      body: Row(
        children: [
          GetBuilder<BuyingController>(builder: (controller) {
            return Expanded(
                flex: 7,
                child: IndexedStack(
                  index: controller.currentIndex,
                  children: const [
                    //! View Items:
                    ViewBuyingTable(),
                    //! Add Items:
                    AddBuyingTable(),
                  ],
                ));
          }),
          Expanded(
              flex: 2,
              child: GetBuilder<BuyingController>(builder: (controller) {
                return Container(
                  color: primaryColor,
                  child: DefaultTabController(
                    initialIndex: 0,
                    length: 2,
                    child: Column(
                      children: [
                        TabBar(
                            dividerColor: primaryColor,
                            dividerHeight: 1,
                            unselectedLabelColor: white,
                            indicatorColor: secondColor,
                            indicatorSize: TabBarIndicatorSize.tab,
                            automaticIndicatorColorAdjustment: true,
                            labelColor: secondColor,
                            onTap: (index) {
                              if (index == 0) {
                                controller.updateIndex(0);
                              } else if (index == 1) {
                                controller.updateIndex(1);
                              }
                            },
                            tabs: const [
                              Tab(
                                icon: Icon(
                                  Icons.remove_red_eye,
                                  color: white,
                                ),
                              ),
                              Tab(
                                icon: Icon(
                                  Icons.add,
                                  color: white,
                                ),
                              ),
                            ]),
                        Expanded(
                            child: TabBarView(
                          children: [
                            Container(
                                color: primaryColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: ListView(
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
                                        contrllerId:
                                            controller.groupByIdController,
                                        contrllerName:
                                            controller.groupByNameController,
                                        color: white,
                                        iconData: Icons.category,
                                        title: "order items",
                                        listData: [
                                          SelectedListItem(
                                              name: 'Items Name',
                                              value: 'items_name'),
                                          SelectedListItem(
                                              name: 'Supplier Name',
                                              value: 'users_name'),
                                          SelectedListItem(
                                              name: 'Buying Date',
                                              value: 'purchase_date'),
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
                                        height: 300,
                                        child: ListView.separated(
                                            separatorBuilder: (context, index) {
                                              return customSizedBox(10);
                                            },
                                            itemCount:
                                                controller.itemsTitle.length,
                                            itemBuilder: (context, index) {
                                              return CustomTextFormFieldGlobal(
                                                  onTap: index == 2
                                                      ? () {
                                                          controller.selectDate(
                                                              context,
                                                              controller
                                                                      .itemsController[
                                                                  index]!);
                                                        }
                                                      : null,
                                                  mycontroller: controller
                                                      .itemsController[index],
                                                  hinttext: controller
                                                      .itemsTitle[index],
                                                  labeltext: controller
                                                      .itemsTitle[index],
                                                  iconData:
                                                      Icons.search_outlined,
                                                  valid: (value) {
                                                    return validInput(
                                                        value!, 0, 100, "");
                                                  },
                                                  borderColor: white,
                                                  isNumber: false);
                                            }),
                                      ),
                                    ),
                                    customButtonGlobal(() async {
                                      controller.getPurchaseData();
                                    }, "Search", Icons.search)
                                  ],
                                )),
                            //! Add Side
                            Container(
                              color: primaryColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: GetBuilder<BuyingController>(
                                  builder: (controller) {
                                return ListView(
                                  children: [
                                    CustomHeaderScreen(
                                      imagePath: AppImageAsset.buyingIcons,
                                      root: () {
                                        Get.toNamed(AppRoute.catagoriesScreen);
                                      },
                                      title: "Buying",
                                    ),
                                    customSizedBox(25),
                                    Form(
                                        key: controller.formKey,
                                        child: Column(
                                          children: [
                                            CustomDropDownSearch(
                                                contrllerId: controller
                                                    .supplierIdController,
                                                contrllerName: controller
                                                    .supplierNameController,
                                                iconData: Icons.person,
                                                title: "Supplier Name",
                                                listData: controller
                                                    .usersDropDownData),
                                            customSizedBox(10),
                                            CustomDropDownSearch(
                                                iconData: Icons.payment,
                                                title: "Payment",
                                                contrllerName: controller
                                                    .paymentMethodNameController,
                                                contrllerId: controller
                                                    .paymentMethodIdController,
                                                listData: [
                                                  SelectedListItem(
                                                      name: "Cash",
                                                      value: "cash"),
                                                  SelectedListItem(
                                                      name: "Dept",
                                                      value: "dept"),
                                                ]),
                                            customSizedBox(10),
                                            CustomTextFormFieldGlobal(
                                                hinttext: "Discount",
                                                labeltext: "Discount",
                                                mycontroller: controller
                                                    .purchaseDiscountController,
                                                iconData:
                                                    Icons.discount_outlined,
                                                valid: (value) {
                                                  return validInput(
                                                      value!, 0, 100, "number");
                                                },
                                                borderColor: white,
                                                isNumber: true),
                                            customSizedBox(10),
                                            CustomTextFormFieldGlobal(
                                                hinttext: "Fees",
                                                labeltext: "Fees",
                                                mycontroller: controller
                                                    .purchaseFeesController,
                                                iconData:
                                                    Icons.discount_outlined,
                                                valid: (value) {
                                                  return validInput(
                                                      value!, 0, 100, "number");
                                                },
                                                borderColor: white,
                                                isNumber: true),
                                          ],
                                        )),
                                    customButtonGlobal(() async {
                                      controller.addItems(context);
                                    }, "Save", Icons.save, white, primaryColor),
                                    customButtonGlobal(() async {
                                      controller
                                          .calculateDiscount(); // await controller.addItems();
                                    }, "Calculate", Icons.save, white,
                                        primaryColor),
                                  ],
                                );
                              }),
                            ),
                          ],
                        ))
                      ],
                    ),
                  ),
                );
              })),
        ],
      ),
    );
  }
}
