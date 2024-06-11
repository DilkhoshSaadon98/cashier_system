import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/controller/cashier/cashier_definition_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/shared/custom_buttton_global.dart';
import 'package:cashier_system/view/cashier/components/right_side/components/custom_cashier_dialog.dart';
import 'package:cashier_system/core/shared/custom_formfield_global.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/custom_snack_bar.dart';
import 'package:cashier_system/view/cashier/components/right_side/components/custom_diplay_users.dart';
import 'package:cashier_system/view/cashier/components/right_side/components/show_last_invoices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CashierConstantController extends CashierDefinitionController {
  List<Map<String, dynamic>> buttonsDetails = [
    //! Print Function
    {
      'title': "Print",
      'icon': Icons.local_print_shop_outlined,
      'function': (String parameter,
          [String? itemsCount, String? cartNumber]) {},
      'color': const Color(0xff41C9E2),
      'keyboard': [LogicalKeyboardKey.control, LogicalKeyboardKey.keyP]
    },
    //! Delay Function
    {
      'title': "Delay",
      'icon': FontAwesomeIcons.circlePause,
      'function': (String parameter, [String? itemsCount, String? cartNumber]) {
        //! Delay Function
        CashierController cashierController = Get.put(CashierController());
        cashierController.delayCart();
      },
      'color': const Color(0xffFFAF45),
      'keyboard': [LogicalKeyboardKey.control, LogicalKeyboardKey.keyD]
    },
    //! Item Discount Function
    {
      'title': "Item Discount",
      'icon': Icons.discount_outlined,
      'function': (String parameter, [String? itemsCount, String? cartNumber]) {
        CashierController cashierController = Get.put(CashierController());
        if (cashierController.selectedRows.isNotEmpty) {
          cashierDialog("Item Discount", Icons.local_offer_outlined,
              cashierController.buttonActionsController!, () {
            cashierController.dicountingItems(cashierController.selectedRows,
                cashierController.buttonActionsController!.text);
            cashierController.buttonActionsController!.clear();
          });
        } else {
          customSnackBar("Error", "Please select one row at least");
        }
      },
      'color': const Color(0xff9BCF53),
      'keyboard': [LogicalKeyboardKey.control, LogicalKeyboardKey.keyI]
    },
    //! Cart Discount Function:
    {
      'title': "Order Discount",
      'icon': FontAwesomeIcons.moneyCheckDollar,
      'function': (String parameter, [String? itemsCount, String? cartNumber]) {
        CashierController cashierController = Get.put(CashierController());
        cashierDialog("Order Discount", Icons.percent,
            cashierController.buttonActionsController!, () {
          cashierController.percentDiscounting(
              cashierController.buttonActionsController!.text);
          cashierController.buttonActionsController!.clear();
        });
      },
      'color': const Color(0xff76ABAE),
      'keyboard': [LogicalKeyboardKey.control, LogicalKeyboardKey.keyO]
    },
    //! QTY Function
    {
      'title': "QTY",
      'icon': FontAwesomeIcons.layerGroup,
      'function': (String parameter, [String? itemsCount, String? cartNumber]) {
        CashierController cashierController = Get.put(CashierController());
        if (cashierController.selectedRows.isNotEmpty) {
          cashierDialog(
              "QTY", Icons.numbers, cashierController.buttonActionsController!,
              () {
            cashierController.updateItemQuantity(cashierController.selectedRows,
                cashierController.buttonActionsController!.text);
            cashierController.buttonActionsController!.clear();
          });
        } else {
          customSnackBar("Error", "Please select one row at least");
        }
      },
      'color': const Color(0xff2C7865),
      'keyboard': [LogicalKeyboardKey.control, LogicalKeyboardKey.keyQ]
    },
    //! Gift
    {
      'title': "Gift",
      'icon': Icons.card_giftcard_outlined,
      'function': (String parameter, [String? itemsCount, String? cartNumber]) {
        CashierController cashierController = Get.put(CashierController());
        if (cashierController.selectedRows.isNotEmpty) {
          cashierController.cartItemGift(
            cashierController.selectedRows,
          );
          cashierController.selectedRows.clear();
        } else {
          customSnackBar("Error", "Please select one row at least");
        }
      },
      'color': const Color(0xffD6589F),
      'keyboard': [LogicalKeyboardKey.control, LogicalKeyboardKey.keyG]
    },
    //! Delete Items Function:
    {
      'title': "Delete Item",
      'icon': FontAwesomeIcons.xmark,
      'function': (String parameter, [String? itemsCount, String? cartNumber]) {
        CashierController cashierController = Get.put(CashierController());
        if (cashierController.selectedRows.isNotEmpty) {
          cashierController.deleteCartItem(cashierController.selectedRows);
          cashierController.selectedRows.clear();
        } else {
          customSnackBar("Error", "Please select one row at least");
        }
      },
      'color': const Color(0xffFF204E),
      'keyboard': [LogicalKeyboardKey.control, LogicalKeyboardKey.delete]
    },
    //! Delete Cart Function
    {
      'title': "Delete Cart",
      'icon': Icons.delete_sweep_outlined,
      'function': (String parameter, [String? itemsCount, String? cartNumber]) {
        CashierController cashierController = Get.put(CashierController());
        cashierController.deleteCart();
      },
      'color': const Color.fromARGB(255, 185, 15, 49),
      'keyboard': [LogicalKeyboardKey.control, LogicalKeyboardKey.backspace]
    },
    //! Owner Name
    {
      'title': "Customer Name",
      'icon': Icons.person,
      'function': (String parameter, [String? itemsCount, String? cartNumber]) {
        CashierController cashierController = Get.put(CashierController());
        Get.defaultDialog(
          title: "",
          titleStyle: titleStyle,
          content: GetBuilder<CashierController>(builder: (controller) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: 600,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    cashierController.checkValue != true
                        ? "Customer Name".tr
                        : "Add New Customer".tr,
                    style: titleStyle.copyWith(fontSize: 20),
                  ),
                  customSizedBox(25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Add New Account?".tr,
                        style: bodyStyle,
                      ),
                      Checkbox(
                          value: cashierController.checkValue,
                          onChanged: (value) {
                            cashierController.checkValueFunction();
                          })
                    ],
                  ),
                  cashierController.checkValue != true
                      ? CustomDropDownSearchUsers(
                          title: "Search for Customer Name".tr,
                          color: primaryColor,
                          iconData: Icons.person,
                          contrllerId: cashierController.cartOwnerIdController,
                          contrllerName:
                              cashierController.cartOwnerNameController,
                          listData: cashierController.dropDownListUsers)
                      : Form(
                          key: cashierController.formstate,
                          child: Column(
                            children: [
                              CustomTextFormFieldGlobal(
                                  mycontroller:
                                      cashierController.usernameController!,
                                  borderColor: primaryColor,
                                  hinttext: "Full Name",
                                  labeltext: 'Full Name',
                                  iconData: Icons.person,
                                  valid: (value) {
                                    return validInput(value!, 1, 400, '');
                                  },
                                  isNumber: false),
                              customSizedBox(),
                              CustomTextFormFieldGlobal(
                                  mycontroller:
                                      cashierController.phoneController!,
                                  borderColor: primaryColor,
                                  hinttext: "Phone Number",
                                  labeltext: 'Phone Number',
                                  iconData: Icons.phone,
                                  valid: (value) {
                                    return validInput(value!, 1, 20, '');
                                  },
                                  isNumber: false),
                              customSizedBox(),
                              CustomTextFormFieldGlobal(
                                  mycontroller:
                                      cashierController.addressController!,
                                  borderColor: primaryColor,
                                  hinttext: "Address",
                                  labeltext: 'Address',
                                  iconData: Icons.gps_fixed,
                                  valid: (value) {
                                    return validInput(value!, 1, 100, '');
                                  },
                                  isNumber: false),
                              customSizedBox(),
                              CustomTextFormFieldGlobal(
                                  mycontroller:
                                      cashierController.noteController!,
                                  borderColor: primaryColor,
                                  hinttext: "Note",
                                  labeltext: 'Note',
                                  iconData: Icons.description_outlined,
                                  valid: (value) {
                                    return validInput(value!, 1, 1000, '');
                                  },
                                  isNumber: false),
                            ],
                          ),
                        ),
                  customSizedBox(25),
                  cashierController.checkValue != true
                      ? Container()
                      : customButtonGlobal(() {
                          cashierController.cartOwnerName(
                            cashierController.usernameController!.text,
                            cashierController.phoneController!.text,
                            cashierController.addressController!.text,
                            cashierController.noteController!.text,
                          );
                          controller.getUsers();
                          cashierController.usernameController!.clear();
                          cashierController.phoneController!.clear();
                          cashierController.addressController!.clear();
                          cashierController.noteController!.clear();
                        }, 'Submit', Icons.check, primaryColor, white,
                          Get.width, 50)
                ],
              ),
            );
          }),
        );
      },
      'color': const Color(0xffF2613F),
      'keyboard': [LogicalKeyboardKey.control, LogicalKeyboardKey.keyN]
    },

    //! Tax Function
    {
      'title': "Tax",
      'icon': FontAwesomeIcons.moneyBillWheat,
      'function': (String parameter, [String? itemsCount, String? cartNumber]) {
        TextEditingController? taxController = TextEditingController();
        CashierController cashierController = Get.put(CashierController());
        cashierDialog("Cart Tax", Icons.money, taxController, () {
          cashierController.cartTax(taxController.text);
          taxController.clear();
        });
      },
      'color': const Color(0xff77B0AA),
      'keyboard': [LogicalKeyboardKey.control, LogicalKeyboardKey.keyT]
    },
    //! Cash/ Dept Function
    {
      'title': "Cash / Dept",
      'icon': Icons.monetization_on_outlined,
      'function': (String parameter, [String? itemsCount, String? cartNumber]) {
        CashierController cashierController = Get.put(CashierController());
        String state = "0";
        cashierController.cartData[0].cartCash! == "1"
            ? state = "0"
            : state = "1";
        cashierController.cartCashState(state);
      },
      'color': const Color(0xff8DECB4),
      'keyboard': [LogicalKeyboardKey.control, LogicalKeyboardKey.keyC]
    },
    //! Cashback / Cash Function
    {
      'title': "Cashback / Cash",
      'icon': Icons.money,
      'function': (String parameter,
          [String? itemsCount, String? cartNumber]) {},
      'color': const Color(0xff279EFF),
      'keyboard': [LogicalKeyboardKey.control, LogicalKeyboardKey.keyZ]
    }, //! Dept Function
    //! Export Function
    {
      'title': "Export",
      'icon': Icons.import_export_rounded,
      'function': (String parameter,
          [String? itemsCount, String? cartNumber]) {},
      'color': const Color(0xff279EFF),
      'keyboard': [LogicalKeyboardKey.control, LogicalKeyboardKey.keyF]
    },
    //! Previous Function
    {
      'title': "Edit Previous",
      'icon': Icons.recycling_rounded,
      'function': (String parameter, [String? itemsCount, String? cartNumber]) {
        customDialogShowInvoices(
          "Last Invoices".tr,
        );
      },
      'color': const Color(0xff279EFF),
      'keyboard': [LogicalKeyboardKey.control, LogicalKeyboardKey.keyE]
    },
  ];

  List<String> cashierFooter = [
    "Item Numbers",
    "Customer Name",
    "Invoice Number",
    "Discount",
    "Tax",
    "Invoice Orgnaizer"
  ];
}
