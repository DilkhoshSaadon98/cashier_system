import 'package:cashier_system/controller/buying/buying_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/functions/date_picker.dart';
import 'package:cashier_system/core/functions/formating_numbers.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/responsive/divide_screen_widget.dart';
import 'package:cashier_system/core/shared/buttons/screen_action_buttons.dart';
import 'package:cashier_system/core/shared/buttons/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_divider.dart';
import 'package:cashier_system/core/shared/custom_text_field_widget.dart';
import 'package:cashier_system/core/shared/drop_downs/custom_drop_down_search_users.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/drop_downs/drop_down_menu.dart';
import 'package:cashier_system/view/buying/windows/add_buying/add_buying_table.dart';
import 'package:cashier_system/view/buying/windows/view_buying/view_buying_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyingScreenWindows extends StatelessWidget {
  const BuyingScreenWindows({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(BuyingController());
    return Scaffold(
      backgroundColor: white,
      body: DivideScreenWidget(
        showWidget: GetBuilder<BuyingController>(builder: (controller) {
          return controller.selectedSection == TextRoutes.view
              ? const ViewBuyingTable()
              :
              //! Add Items:
              const AddBuyingTable();
        }),
        actionWidget: GetBuilder<BuyingController>(builder: (controller) {
          return Column(
            children: [
              const CustomHeaderScreen(
                imagePath: AppImageAsset.buyingIcons,
                title: TextRoutes.purchaes,
              ),
              verticalGap(),
              DropDownMenu(
                items: const [
                  TextRoutes.view,
                  TextRoutes.add,
                ],
                selectedValue: controller.selectedSection,
                contentColor: white,
                fieldColor: buttonColor,
                onChanged: (value) {
                  controller.changeSection(value);
                },
              ),
              verticalGap(),
              //! View Side
              controller.selectedSection == TextRoutes.view
                  ? Expanded(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                TextRoutes.searchBy.tr,
                                style: titleStyle.copyWith(color: white),
                              ),
                              verticalGap(5),
                              ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: controller.searchFields.length,
                                separatorBuilder: (_, __) => verticalGap(10),
                                itemBuilder: (context, index) {
                                  final fields = controller.searchFields[index];
                                  final title = fields['title'];
                                  final textController = fields['controller'];
                                  final readONly = fields['read_only'];
                                  final icon = fields['icon'];
                                  if (title == TextRoutes.paymentString) {
                                    return DropDownMenu(
                                        selectedValue: controller
                                            .selectedSearchPaymentMethod,
                                        items: const [
                                          TextRoutes.all,
                                          TextRoutes.cash,
                                          TextRoutes.dept
                                        ],
                                        contentColor: white,
                                        fieldColor: primaryColor,
                                        onChanged: (value) {
                                          controller
                                              .changeSearchPaymentMethod(value);
                                        });
                                  }
                                  return CustomTextFieldWidget(
                                    onTap: title == TextRoutes.date
                                        ? () {
                                            selectDate(context, textController);
                                          }
                                        : null,
                                    controller: textController,
                                    hinttext: title,
                                    labeltext: title,
                                    iconData: icon,
                                    fieldColor: primaryColor,
                                    valid: (value) =>
                                        validInput(value!, 0, 100, ""),
                                    borderColor: white,
                                    isNumber: false,
                                    readOnly: readONly,
                                  );
                                },
                              ),
                              verticalGap(20),
                            ],
                          ),
                          screenActionButtonWidget(
                            context,
                            backColor: primaryColor,
                            onPressedClear: () {},
                            onPressedPrint: () {
                              final selectedExportData = controller.purchaseData
                                  .where(
                                    (item) => controller.selectedRows
                                        .contains(item.purchaseNumber),
                                  )
                                  .toList();
                              controller.printingData(selectedExportData);
                            },
                            onPressedSearch: () {
                              controller.getPurchaseData(isInitialSearch: true);
                            },
                            onPressedRemove: () {},
                          )
                        ],
                      ),
                    )
                  :
                  //! Add Side
                  GetBuilder<BuyingController>(builder: (controller) {
                      return Form(
                        key: controller.detailsFormKey,
                        child: Column(
                          children: [
                            CustomDropDownSearchUsersGlobal(
                              listData: controller.dropDownListUsers,
                              color: primaryColor,
                              contrllerId: controller.supplierIdController,
                              contrllerName: controller.supplierNameController,
                              title: TextRoutes.supplierName,
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
                            verticalGap(10),
                            DropDownMenu(
                                contentColor: white,
                                fieldColor: primaryColor,
                                selectedValue: controller.paymentMethod,
                                items: const [
                                  TextRoutes.cash,
                                  TextRoutes.dept,
                                ],
                                onChanged: (value) {
                                  controller.changePaymentMethod(value!);
                                }),
                            verticalGap(10),
                            CustomTextFieldWidget(
                                valid: (value) {
                                  return validInput(value!, 0, 100, "",
                                      required: false);
                                },
                                onTap: () {
                                  selectDate(
                                      context, controller.dateController);
                                },
                                hinttext: TextRoutes.date,
                                labeltext: TextRoutes.date,
                                controller: controller.dateController,
                                iconData: Icons.date_range,
                                fieldColor: primaryColor,
                                borderColor: white,
                                readOnly: true,
                                isNumber: false),
                            verticalGap(10),
                            CustomTextFieldWidget(
                                valid: (value) {
                                  return validInput(
                                      value!, 0, 100, "realNumber",
                                      required: false);
                                },
                                suffixIconData: Icons.check,
                                hinttext: TextRoutes.discount,
                                labeltext: TextRoutes.discount,
                                controller:
                                    controller.purchaseDiscountController,
                                iconData: Icons.discount_outlined,
                                fieldColor: primaryColor,
                                borderColor: white,
                                isNumber: true),
                            verticalGap(10),
                            CustomTextFieldWidget(
                                suffixIconData: Icons.check,
                                hinttext: TextRoutes.fees,
                                labeltext: TextRoutes.fees,
                                controller: controller.purchaseFeesController,
                                iconData: Icons.monetization_on,
                                valid: (value) {
                                  return validInput(
                                      value!, 0, 100, "realNumber",
                                      required: false);
                                },
                                fieldColor: primaryColor,
                                borderColor: white,
                                isNumber: true),
                            customDivider(white),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  TextRoutes.totalPurchaesPrice,
                                  style: titleStyle.copyWith(color: white),
                                ),
                                Text(
                                  formattingNumbers(
                                      controller.totalPurchaseCalculatedPrice),
                                  style: titleStyle.copyWith(color: white),
                                ),
                              ],
                            ),
                            verticalGap(),
                            customButtonGlobal(() async {
                              controller.calculatePrice();
                            }, "Calculate", Icons.save, white, primaryColor),
                            verticalGap(5),
                            if (controller.showSaveButton)
                              customButtonGlobal(() async {
                                controller.addItems(context);
                              }, "Save", Icons.save, buttonColor, white),
                          ],
                        ),
                      );
                    }),
            ],
          );
        }),
      ),
    );
  }
}
