import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/controller/cashier/cashier_definition_controller.dart';
import 'package:cashier_system/controller/printer/sunmi_printer_controller.dart';
import 'package:cashier_system/controller/printer/invoice_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/screen_routes.dart';
import 'package:cashier_system/core/dialogs/confirm_dialog.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/core/dialogs/snackbar_helper.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/buttons/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_text_field_widget.dart';
import 'package:cashier_system/data/model/categories_model.dart';
import 'package:cashier_system/data/model/items_model.dart';
import 'package:cashier_system/view/cashier/components/drop_down_search_users_cashier.dart';
import 'package:cashier_system/view/cashier/windows/action/components/custom_cashier_dialog.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/view/cashier/windows/action/components/export_pdf_dialog.dart';
import 'package:cashier_system/view/cashier/windows/action/components/show_last_invoices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CashierConstantController extends CashierDefinitionController {
  List<Map<String, dynamic>> buttonsDetails = [
    //?0 Delay Details:
    {
      'title': TextRoutes.delay,
      'icon': FontAwesomeIcons.circlePause,
      'function': (String parameter, [String? itemsCount, String? cartNumber]) {
        CashierController cashierController = Get.find();
        cashierController.delayCart();
      },
      'on_long_press': () {},
      'color': const Color(0xffFFAF45),
      'tool_tip': "${TextRoutes.pauseInvoiceForWhile.tr}\nCTRL + D",
      'keyboard': [LogicalKeyboardKey.control, LogicalKeyboardKey.keyD],
    },
    //?1 Print Details:
    {
      'title': TextRoutes.print,
      'icon': Icons.local_print_shop_outlined,
      'function': (String parameter,
          [String? itemsCount, String? cartNumber]) async {
        InvoiceController invoiceController = Get.put(InvoiceController());
        CashierController cashierController = Get.put(CashierController());
        String selectedPrinter =
            myServices.sharedPreferences.getString("selected_printer") ??
                "A4 Printer";
        if (cashierController.cartData.isNotEmpty) {
          invoiceController.loadPreferences();
          invoiceController.update();
          Map<String, List<String>> result = {
            "#": [],
            "Code": [],
            "Name": [],
            "QTY": [],
            "Price": [],
            "Total Price": [],
            "Type": [],
          };

          for (var i = 0; i < cashierController.cartData.length; i++) {
            var item = cashierController.cartData[i];
            //     String itemsName = combineLaptopDetails(item);

            // Add data to result map
            result["#"]!.add((i + 1).toString());
            result["Code"]!.add(item.itemsId.toString());
            result["Name"]!.add(item.itemsName.tr);
            result["QTY"]!.add(item.cartItemsCount.toString());
            result["Price"]!.add(item.itemsSellingPrice.toString());
            double totalPrice =
                (item.cartItemsCount) * (item.itemsSellingPrice);
            result["Total Price"]!.add(totalPrice.toString());

            // Add item type
            //   result["Type"]!.add(item.itemsType?.toString() ?? '');
          }

          // Prepare the invoice data
          Map<String, dynamic> invoiceData = {
            "Customer Name": cashierController.cartData[0].usersName ?? " ",
            "Organizer Name":
                myServices.sharedPreferences.getString("admins_username") ??
                    "Admin",
            "Total Price": cashierController.cartTotalPrice.toStringAsFixed(2),
            "Number Of Items": cashierController.cartItemsCount.toString(),
            "Customer Phone": cashierController.cartData[0].usersName ?? " ",
            "Customer Address": cashierController.cartData[0].usersName ?? " ",
            "Invoice number": cashierController.maxInvoiceNumber.toString(),
            "Date": currentTime.toString(),
            "Discount":
                cashierController.cartData[0].cartDiscount.toStringAsFixed(2),
            "Taxes": cashierController.cartData[0].cartTax.toStringAsFixed(2),
          };
          try {
            if (myServices.sharedPreferences.getString("selected_printer") ==
                null) {
              myServices.sharedPreferences
                  .setString('selected_printer', "A4 Printer");
            }
            if (selectedPrinter == "A4 Printer") {
              invoiceController.printInvoice(invoiceData, result, "bills");
            } else if (selectedPrinter == "A5 Printer") {
              invoiceController.printInvoice(invoiceData, result, "bills");
            } else if (selectedPrinter == 'Mini Printer') {
              invoiceController.printInvoice(invoiceData, result, "bills");
            } else if (selectedPrinter == "SUNMI Printer") {
              PrinterController printerController =
                  Get.put(PrinterController());
              printerController.printTable(
                invoiceController.selectedHeaders,
                invoiceController.selectedColumns,
                invoiceData,
                result,
              );
            } else if (selectedPrinter == "Mini Printer") {
              PrinterController printerController =
                  Get.put(PrinterController());
              printerController.printTable(
                invoiceController.selectedHeaders,
                invoiceController.selectedColumns,
                invoiceData,
                result,
              );
            }
          } catch (e) {
            showErrorDialog(e.toString(), message: TextRoutes.failUpdateData);
          }
        } else {
          showErrorSnackBar(TextRoutes.emptyCart);
        }
      },
      'on_long_press': () {
        Get.toNamed(AppRoute.invoiceScreen);
      },
      'color': const Color(0xff41C9E2),
      'tool_tip':
          "${TextRoutes.printReceipt.tr}\nCTRL + P \n ${TextRoutes.longPressToUpdateSettings.tr}",
      'keyboard': [LogicalKeyboardKey.control, LogicalKeyboardKey.keyP],
    },
    //?2 Order Discount Details:
    {
      'title': TextRoutes.orderDiscount,
      'icon': Icons.discount,
      'function': (String parameter, [String? itemsCount, String? cartNumber]) {
        CashierController cashierController = Get.find();
        cashierDialog(
          TextRoutes.orderDiscount,
          Icons.discount,
          cashierController.buttonActionsController!,
          () {
            if (!cashierController.formState.currentState!.validate()) {
              showErrorSnackBar(TextRoutes.formValidationFailed);
              return;
            }

            cashierController.cartDiscountingByValue(
                cashierController.buttonActionsController!.text);
            cashierController.buttonActionsController!.clear();
          },
          () {
            cashierController.cartDiscountingByValue('0');
          },
        );
      },
      'on_long_press': () {},
      'color': const Color(0xff76ABAE),
      'tool_tip':
          "${TextRoutes.discountSpecifiedAmountFromInvoice.tr}\nCTRL + O",
      'keyboard': [LogicalKeyboardKey.control, LogicalKeyboardKey.keyO],
    },
    //?3 Percent Discount Details:
    {
      'title': TextRoutes.percentDiscount,
      'icon': Icons.percent_outlined,
      'function': (String parameter, [String? itemsCount, String? cartNumber]) {
        CashierController cashierController = Get.find();
        cashierDialog(
          TextRoutes.percentDiscount,
          Icons.percent_outlined,
          cashierController.buttonActionsController!,
          () {
            if (!cashierController.formState.currentState!.validate()) {
              showErrorSnackBar(TextRoutes.formValidationFailed);
              return;
            }
            cashierController.percentageDiscountingItems(
              cashierController.selectedRows,
              cashierController.buttonActionsController!.text,
            );
            cashierController.buttonActionsController!.clear();
          },
          () {
            cashierController.percentageDiscountingItems(
              cashierController.selectedRows,
              '0',
            );
          },
        );
      },
      'on_long_press': () {},
      'color': const Color(0xff9BCF53),
      'tool_tip': "${TextRoutes.percentageDiscountFromInvoice.tr}\nCTRL + I",
      'keyboard': [LogicalKeyboardKey.control, LogicalKeyboardKey.keyI],
    },
    //?4 QTY Details:
    {
      'title': TextRoutes.qty,
      'icon': FontAwesomeIcons.layerGroup,
      'function': (String parameter, [String? itemsCount, String? cartNumber]) {
        CashierController cashierController = Get.find();
        if (cashierController.selectedRows.isNotEmpty) {
          cashierDialog(
            TextRoutes.qty,
            Icons.numbers,
            cashierController.buttonActionsController!,
            () {
              if (!cashierController.formState.currentState!.validate()) {
                showErrorSnackBar(TextRoutes.formValidationFailed);
                return;
              }
              cashierController.updateItemQuantity(
                  cashierController.selectedRows,
                  cashierController.buttonActionsController!.text);
              cashierController.buttonActionsController!.clear();
            },
            () {
              cashierController.updateItemQuantity(
                  cashierController.selectedRows, '1');
            },
          );
        } else {
          showErrorSnackBar(TextRoutes.selectOneRowAtLeast);
        }
      },
      'on_long_press': () {},
      'color': const Color(0xff2C7865),
      'tool_tip': "${TextRoutes.changeQuantityOfSelectedItem.tr}\nCTRL + Q",
      'keyboard': [LogicalKeyboardKey.control, LogicalKeyboardKey.keyQ],
    },
    //?5 Edit Price Details:
    {
      'title': TextRoutes.editPrice,
      'icon': FontAwesomeIcons.moneyBill,
      'function': (String parameter, [String? itemsCount, String? cartNumber]) {
        CashierController cashierController = Get.find();
        if (cashierController.selectedRows.isNotEmpty) {
          cashierDialog(
            TextRoutes.editPrice,
            FontAwesomeIcons.moneyBill,
            cashierController.buttonActionsController!,
            () {
              cashierController.updateItemPrice(cashierController.selectedRows,
                  cashierController.buttonActionsController!.text);
              cashierController.buttonActionsController!.clear();
            },
            () {},
          );
        } else {
          showErrorSnackBar(TextRoutes.selectOneRowAtLeast.tr);
        }
      },
      'on_long_press': () {},
      'color': const Color.fromARGB(255, 74, 194, 188),
      'tool_tip': "${TextRoutes.changePriceOfSelectedItem.tr}\n",
      'keyboard': [],
    },
    //?6 Gift Details:
    {
      'title': TextRoutes.gift,
      'icon': Icons.card_giftcard_outlined,
      'function': (String parameter, [String? itemsCount, String? cartNumber]) {
        CashierController cashierController = Get.find();
        if (cashierController.selectedRows.isNotEmpty) {
          cashierController.cartItemGift(cashierController.selectedRows);
          cashierController.selectedRows.clear();
        } else {
          showErrorSnackBar(TextRoutes.selectOneRowAtLeast.tr);
        }
      },
      'on_long_press': () {},
      'color': const Color(0xffD6589F),
      'tool_tip': "${TextRoutes.addSelectedItemAsGiftToInvoice.tr}\nCTRL + G",
      'keyboard': [LogicalKeyboardKey.control, LogicalKeyboardKey.keyG],
    },
    //?7 Delete Item Details:
    {
      'title': TextRoutes.deleteItem,
      'icon': FontAwesomeIcons.xmark,
      'function': (String parameter, [String? itemsCount, String? cartNumber]) {
        CashierController cashierController = Get.find();
        if (cashierController.selectedRows.isNotEmpty) {
          cashierController.deleteCartItem(cashierController.selectedRows);
          cashierController.selectedRows.clear();
        } else {
          showErrorSnackBar(TextRoutes.selectOneRowAtLeast.tr);
        }
      },
      'on_long_press': () {},
      'color': const Color(0xffFF204E),
      'tool_tip': "${TextRoutes.deleteSelectedItems.tr}\nCTRL + Delete",
      'keyboard': [LogicalKeyboardKey.control, LogicalKeyboardKey.delete],
    },
    //?8 Delete Cart Details:
    {
      'title': TextRoutes.deleteCart,
      'icon': Icons.delete_sweep_outlined,
      'function': (String parameter, [String? itemsCount, String? cartNumber]) {
        CashierController cashierController = Get.find();
        cashierController.deleteCart();
      },
      'on_long_press': () {},
      'color': const Color.fromARGB(255, 185, 15, 49),
      'tool_tip': "${TextRoutes.deleteCurrentCart.tr}\nCTRL + Backspace",
      'keyboard': [LogicalKeyboardKey.control, LogicalKeyboardKey.backspace],
    },
    //?9 Customer Name Details:
    {
      'title': TextRoutes.customerName,
      'icon': Icons.person,
      'function': (String parameter, [String? itemsCount, String? cartNumber]) {
        CashierController cashierController = Get.find();
        cashierController.getUsers().then((value) {
          Get.defaultDialog(
            title: "",
            titleStyle: titleStyle,
            backgroundColor: white,
            content: GetBuilder<CashierController>(builder: (controller) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: 400.w,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          cashierController.checkValue != true
                              ? TextRoutes.customerName.tr
                              : TextRoutes.addNewCustomer.tr,
                          style: titleStyle.copyWith(fontSize: 20),
                        ),
                        verticalGap(25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              TextRoutes.addNewAccount.tr,
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
                            ? Column(
                                children: [
                                  DropDownSearchUsersCashier(
                                      title:
                                          TextRoutes.searchForCustomerName.tr,
                                      color: primaryColor,
                                      iconData: Icons.person,
                                      contrllerId: cashierController
                                          .cartOwnerIdController,
                                      contrllerName: cashierController
                                          .cartOwnerNameController,
                                      listData:
                                          cashierController.dropDownListUsers),
                                  Container(
                                    width: Get.width,
                                    alignment: Alignment.centerRight,
                                    child: TextButton.icon(
                                        onPressed: () {
                                          controller.cartOwnerNameUpdate(null);
                                          Get.back();
                                        },
                                        icon: const Icon(
                                          Icons.restart_alt_rounded,
                                          color: primaryColor,
                                        ),
                                        label: Text(
                                          TextRoutes.removeUser.tr,
                                          style:
                                              bodyStyle.copyWith(fontSize: 10),
                                        )),
                                  )
                                ],
                              )
                            : Form(
                                key: cashierController.formState,
                                child: Column(
                                  children: [
                                    CustomTextFieldWidget(
                                        controller: cashierController
                                            .usernameController!,
                                        borderColor: primaryColor,
                                        hinttext: TextRoutes.fullName.tr,
                                        labeltext: TextRoutes.fullName.tr,
                                        iconData: Icons.person,
                                        valid: (value) {
                                          return validInput(value!, 1, 400, '');
                                        },
                                        fieldColor: white,
                                        isNumber: false),
                                    verticalGap(),
                                    CustomTextFieldWidget(
                                        fieldColor: white,
                                        controller:
                                            cashierController.phoneController!,
                                        borderColor: primaryColor,
                                        hinttext: TextRoutes.phoneNumber.tr,
                                        labeltext: TextRoutes.phoneNumber.tr,
                                        iconData: Icons.phone,
                                        valid: (value) {
                                          return validInput(value!, 1, 50, '');
                                        },
                                        isNumber: false),
                                    verticalGap(),
                                    CustomTextFieldWidget(
                                        controller: cashierController
                                            .addressController!,
                                        borderColor: primaryColor,
                                        fieldColor: white,
                                        hinttext: TextRoutes.address.tr,
                                        labeltext: TextRoutes.address.tr,
                                        iconData: Icons.gps_fixed,
                                        valid: (value) {
                                          return validInput(value!, 1, 1000, '',
                                              required: false);
                                        },
                                        isNumber: false),
                                    verticalGap(),
                                    CustomTextFieldWidget(
                                        controller:
                                            cashierController.noteController!,
                                        borderColor: primaryColor,
                                        fieldColor: white,
                                        hinttext: TextRoutes.note.tr,
                                        labeltext: TextRoutes.note.tr,
                                        iconData: Icons.description_outlined,
                                        valid: (value) {
                                          return validInput(value!, 1, 2000, '',
                                              required: false);
                                        },
                                        isNumber: false),
                                  ],
                                ),
                              ),
                        verticalGap(25),
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
                              }, TextRoutes.submit, Icons.check, primaryColor,
                                white, Get.width, 50)
                      ],
                    ),

                    /// Close Button (Top Right)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close_rounded,
                            color: Colors.black54),
                        onPressed: () => Get.back(),
                        tooltip: TextRoutes.close,
                        splashRadius: 20,
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        });
      },
      'on_long_press': () {},
      'color': const Color(0xffF2613F),
      'tool_tip': "${TextRoutes.addCustomerNameToInvoice.tr}\nCTRL + N",
      'keyboard': [LogicalKeyboardKey.control, LogicalKeyboardKey.keyN],
    },
    //?10 Tax Details:
    {
      'title': TextRoutes.tax,
      'icon': FontAwesomeIcons.moneyBillWheat,
      'function': (String parameter, [String? itemsCount, String? cartNumber]) {
        TextEditingController? taxController = TextEditingController();
        CashierController cashierController = Get.find();
        cashierDialog(
          TextRoutes.tax,
          Icons.money,
          taxController,
          () {
            if (cashierController.cartData.isNotEmpty) {
              if (!cashierController.formState.currentState!.validate()) {
                showErrorSnackBar(TextRoutes.formValidationFailed);
                return;
              }

              cashierController.cartTax(taxController.text);
              taxController.clear();
            } else {
              showErrorSnackBar(TextRoutes.emptyCart);
            }
          },
          () {
            Get.back();
            cashierController.cartTax('0');
          },
        );
      },
      'on_long_press': () {},
      'color': const Color(0xff77B0AA),
      'tool_tip': "${TextRoutes.addExtraTaxToInvoice.tr}\nCTRL + T",
      'keyboard': [LogicalKeyboardKey.control, LogicalKeyboardKey.keyT],
    },
    //?11 Dept / Cash Details:
    {
      'title': TextRoutes.cash,
      'icon': Icons.monetization_on_outlined,
      'function': (String parameter, [String? itemsCount, String? cartNumber]) {
        CashierController cashierController = Get.find();
        if (cashierController.cartData.isNotEmpty) {
          bool isCurrentlyCash =
              cashierController.cartData[0].cartCash == TextRoutes.cash;
          String newState = isCurrentlyCash ? TextRoutes.dept : TextRoutes.cash;
          cashierController.cartCashState(newState);
        } else {
          showErrorSnackBar(TextRoutes.emptyCart);
        }
      },
      'on_long_press': () {},
      'color': const Color(0xff8DECB4),
      'tool_tip':
          "${TextRoutes.toggleBetweenCashAndCreditInvoice.tr}\nCTRL + C",
      'keyboard': [LogicalKeyboardKey.control, LogicalKeyboardKey.keyC],
    },
    //?12 Cashback / Cash Details:
    {
      'title': TextRoutes.cashbackCash,
      'icon': Icons.money,
      'function': (String parameter, [String? itemsCount, String? cartNumber]) {
        CashierController cashierController = Get.find();
        if (cashierController.cartData.isNotEmpty) {
          showConfirmDialog(
              TextRoutes.confirm, TextRoutes.areYouSureToCashbackSelectedItems,
              () {
            Get.back();
            cashierController.cashBack();
          });
        } else {
          showErrorSnackBar(TextRoutes.emptyCart);
        }
      },
      'on_long_press': () {},
      'color': const Color.fromARGB(255, 15, 113, 60),
      'tool_tip':
          "${TextRoutes.toggleBetweenCashbackAndNormalCash.tr}\nCTRL + Z",
      'keyboard': [LogicalKeyboardKey.control, LogicalKeyboardKey.keyZ],
    },
    //?13 Export PDF Details:
    {
      'title': TextRoutes.exportPDF,
      'icon': Icons.import_export_rounded,
      'function': (String parameter, [String? itemsCount, String? cartNumber]) {
        InvoiceController invoiceController = Get.put(InvoiceController());
        CashierController cashierController = Get.put(CashierController());

        if (cashierController.cartData.isNotEmpty) {
          invoiceController.loadPreferences();
          invoiceController.update();

          // Prepare the table data
          Map<String, List<String>> result = {
            "#": [],
            TextRoutes.code: [],
            TextRoutes.itemsName: [],
            "QTY": [],
            "Price": [],
            "Total Price": [],
            "Type": [],
          };

          for (var i = 0; i < cashierController.cartData.length; i++) {
            var item = cashierController.cartData[i];

            result["#"]!.add((i + 1).toString());
            result[TextRoutes.code]!.add(item.itemsId.toString());
            result[TextRoutes.itemsName]!.add(item.itemsName);
            result["QTY"]!.add(item.cartItemsCount.toString());
            result["Price"]!.add(item.itemsSellingPrice.toString());
            double totalPrice = item.cartItemsCount * item.itemsSellingPrice;
            result["Total Price"]!.add(totalPrice.toString());
            //  result["Type"]!.add(item.itemsType.toString());
          }

          // Prepare the invoice data
          Map<String, dynamic> invoiceData = {
            TextRoutes.customerName:
                cashierController.cartData[0].mainUnitName.toString().tr,
            TextRoutes.organizer:
                myServices.sharedPreferences.getString("admins_username") ??
                    "Admin",
            TextRoutes.totalPrice:
                cashierController.cartTotalPrice.toStringAsFixed(2),
            TextRoutes.totalItemsNumber:
                cashierController.cartItemsCount.toString(),
            TextRoutes.phoneNumber:
                cashierController.cartData[0].usersName ?? "",
            TextRoutes.address: cashierController.cartData[0].usersName ?? "",
            TextRoutes.invoice: cashierController.maxInvoiceNumber.toString(),
            TextRoutes.date: currentTime.toString(),
            TextRoutes.discount:
                cashierController.cartData[0].cartDiscount.toStringAsFixed(2),
            TextRoutes.tax:
                cashierController.cartData[0].cartTax.toStringAsFixed(2),
          };
          try {
            invoiceController.exportInvoicePdf(invoiceData, result, "bills");
          } catch (e) {
            showErrorDialog(e.toString(), message: TextRoutes.failUpdateData);
          }
        } else {
          showErrorSnackBar(TextRoutes.emptyCart);
        }
      },
      'on_long_press': () {
        customExportPDF();
      },
      'color': const Color(0xff279EFF),
      'tool_tip':
          "${TextRoutes.exportPdfFileForCurrentInvoice.tr}\nCTRL + F \n ${TextRoutes.longPressToUpdateSettings.tr}",
      'keyboard': [LogicalKeyboardKey.control, LogicalKeyboardKey.keyF],
    },
    //?14 Edit Previous Details:
    {
      'title': TextRoutes.editPrevious,
      'icon': Icons.recycling_rounded,
      'function': (String parameter, [String? itemsCount, String? cartNumber]) {
        CashierController cashierController = Get.find();
        cashierController.getLastInvoices().then(
          (value) {
            customDialogShowInvoices(TextRoutes.lastInvoices);
          },
        );
      },
      'on_long_press': () {},
      'color': const Color(0xff279EFF),
      'tool_tip': "${TextRoutes.editSelectedInvoice.tr}\nCTRL + E",
      'keyboard': [LogicalKeyboardKey.control, LogicalKeyboardKey.keyE],
    },
    //?15 EDit Layout:
    {
      'title': TextRoutes.layout,
      'icon': Icons.vertical_split,
      'function': (String parameter, [String? itemsCount, String? cartNumber]) {
        CashierController cashierController = Get.find();
        cashierController.switchShowGridData();
      },
      'on_long_press': () {
        CashierController cashierController = Get.find();
        cashierController.changeGridExpanded();
      },
      'color': const Color(0xff279EFF),
      'tool_tip':
          "${TextRoutes.changeLayoutOfScreen.tr}\n${TextRoutes.longPressToUpdateSettings.tr}\nCTRL + E",
      'keyboard': [LogicalKeyboardKey.control, LogicalKeyboardKey.keyL],
    },
  ];
  List<Map> footerData = [
    {
      'title': TextRoutes.totalItemsNumber,
      'value': 1,
      'on_tap': null,
    },
    {
      'title': TextRoutes.customerName,
      'value': 3,
      'on_tap': () {
        CashierController cashierController = Get.find();
        cashierController.getUsers().then((value) {
          Get.defaultDialog(
            title: "",
            titleStyle: titleStyle,
            backgroundColor: white,
            content: GetBuilder<CashierController>(builder: (controller) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: 400.w,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          cashierController.checkValue != true
                              ? TextRoutes.customerName.tr
                              : TextRoutes.addNewCustomer.tr,
                          style: titleStyle.copyWith(fontSize: 20),
                        ),
                        verticalGap(25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              TextRoutes.addNewAccount.tr,
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
                            ? Column(
                                children: [
                                  DropDownSearchUsersCashier(
                                      title:
                                          TextRoutes.searchForCustomerName.tr,
                                      color: primaryColor,
                                      iconData: Icons.person,
                                      contrllerId: cashierController
                                          .cartOwnerIdController,
                                      contrllerName: cashierController
                                          .cartOwnerNameController,
                                      listData:
                                          cashierController.dropDownListUsers),
                                  Container(
                                    width: Get.width,
                                    alignment: Alignment.centerRight,
                                    child: TextButton.icon(
                                        onPressed: () {
                                          controller.cartOwnerNameUpdate(null);
                                          Get.back();
                                        },
                                        icon: const Icon(
                                          Icons.restart_alt_rounded,
                                          color: primaryColor,
                                        ),
                                        label: Text(
                                          TextRoutes.removeUser.tr,
                                          style:
                                              bodyStyle.copyWith(fontSize: 10),
                                        )),
                                  )
                                ],
                              )
                            : Form(
                                key: cashierController.formState,
                                child: Column(
                                  children: [
                                    CustomTextFieldWidget(
                                        controller: cashierController
                                            .usernameController!,
                                        fieldColor: white,
                                        borderColor: primaryColor,
                                        hinttext: TextRoutes.fullName.tr,
                                        labeltext: TextRoutes.fullName.tr,
                                        iconData: Icons.person,
                                        valid: (value) {
                                          return validInput(value!, 1, 400, '');
                                        },
                                        isNumber: false),
                                    verticalGap(),
                                    CustomTextFieldWidget(
                                        fieldColor: white,
                                        controller:
                                            cashierController.phoneController!,
                                        borderColor: primaryColor,
                                        hinttext: TextRoutes.phoneNumber.tr,
                                        labeltext: TextRoutes.phoneNumber.tr,
                                        iconData: Icons.phone,
                                        valid: (value) {
                                          return validInput(value!, 1, 50, '');
                                        },
                                        isNumber: false),
                                    verticalGap(),
                                    CustomTextFieldWidget(
                                        fieldColor: white,
                                        controller: cashierController
                                            .addressController!,
                                        borderColor: primaryColor,
                                        hinttext: TextRoutes.address.tr,
                                        labeltext: TextRoutes.address.tr,
                                        iconData: Icons.gps_fixed,
                                        valid: (value) {
                                          return validInput(value!, 1, 1000, '',
                                              required: false);
                                        },
                                        isNumber: false),
                                    verticalGap(),
                                    CustomTextFieldWidget(
                                        fieldColor: white,
                                        controller:
                                            cashierController.noteController!,
                                        borderColor: primaryColor,
                                        hinttext: TextRoutes.note.tr,
                                        labeltext: TextRoutes.note.tr,
                                        iconData: Icons.description_outlined,
                                        valid: (value) {
                                          return validInput(value!, 1, 2000, '',
                                              required: false);
                                        },
                                        isNumber: false),
                                  ],
                                ),
                              ),
                        verticalGap(25),
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
                              }, TextRoutes.submit, Icons.check, primaryColor,
                                white, Get.width, 50)
                      ],
                    ),

                    /// Close Button (Top Right)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close_rounded,
                            color: Colors.black54),
                        onPressed: () => Get.back(),
                        tooltip: TextRoutes.close,
                        splashRadius: 20,
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        });
      },
    },
    {
      'title': TextRoutes.invoice,
      'value': 3,
      'on_tap': null,
    },
    {
      'title': TextRoutes.discount,
      'value': 3,
      'on_tap': () {
        CashierController cashierController = Get.find();
        cashierDialog(
          TextRoutes.orderDiscount,
          Icons.discount,
          cashierController.buttonActionsController!,
          () {
            if (!cashierController.formState.currentState!.validate()) {
              showErrorSnackBar(TextRoutes.formValidationFailed);
              return;
            }

            cashierController.cartDiscountingByValue(
                cashierController.buttonActionsController!.text);
            cashierController.buttonActionsController!.clear();
          },
          () {
            cashierController.cartDiscountingByValue('0');
          },
        );
      },
    },
    {
      'title': TextRoutes.tax,
      'value': 3,
      'on_tap': () {
        TextEditingController? taxController = TextEditingController();
        CashierController cashierController = Get.find();
        cashierDialog(
          TextRoutes.tax,
          Icons.money,
          taxController,
          () {
            if (cashierController.cartData.isNotEmpty) {
              if (!cashierController.formState.currentState!.validate()) {
                showErrorSnackBar(TextRoutes.formValidationFailed);
                return;
              }

              cashierController.cartTax(taxController.text);
              taxController.clear();
            } else {
              showErrorSnackBar(TextRoutes.emptyCart);
            }
          },
          () {
            Get.back();
            cashierController.cartTax('0');
          },
        );
      },
    },
    {
      'title': TextRoutes.organizer,
      'value': 3,
      'on_tap': null,
    },
  ];
  List<String> cashierFooter = [
    TextRoutes.totalItemsNumber,
    TextRoutes.customerName,
    TextRoutes.invoice,
    TextRoutes.discount,
    TextRoutes.tax,
    TextRoutes.organizer,
  ];
  final List<ItemsModel> data = [];
  List<CategoriesModel> categoriesData = [];
}
