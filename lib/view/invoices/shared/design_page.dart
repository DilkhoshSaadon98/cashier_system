import 'package:cashier_system/controller/printer/invoice_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/buttons/custom_button_widget.dart';
import 'package:cashier_system/core/shared/buttons/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/drop_downs/drop_down_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DesignPage extends StatelessWidget {
  final bool isWindows;
  const DesignPage({super.key, required this.isWindows});

  @override
  Widget build(BuildContext context) {
    Get.put(InvoiceController());
    return GetBuilder<InvoiceController>(
        init: InvoiceController(),
        builder: (controller) {
          return ListView(
            children: [
              //? Select Printer:
              Text(
                TextRoutes.selectPrinter.tr,
                style: titleStyle.copyWith(
                    fontSize: 16, color: isWindows ? white : primaryColor),
              ),
              DropDownMenu(
                items: const [TextRoutes.a4Printer, TextRoutes.miniPrinter],
                onChanged: (value) {
                  controller.changePrinter(value!);
                },
                selectedValue: controller.selectedPrinter,
                contentColor: white,
                fieldColor: buttonColor,
              ),
              verticalGap(10),
              Text(
                TextRoutes.printerSettings.tr,
                style: bodyStyle.copyWith(color: white),
              ),
              //? Pick Printer
              customButtonWidget(
                  () => controller.pickPrinter(), TextRoutes.pickPrinter,
                  color: primaryColor, textColor: white, iconData: Icons.print),
              verticalGap(10),
              customButtonWidget(
                  () => controller.pickPrinter(), TextRoutes.pickPrinter,
                  color: primaryColor, textColor: white, iconData: Icons.print),
              verticalGap(10),
              //? Customize A4 printer:
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1, color: isWindows ? white : primaryColor)),
                child: ExpansionTile(
                  minTileHeight: 40,
                  backgroundColor: primaryColor,
                  collapsedBackgroundColor: white,
                  onExpansionChanged: (value) {
                    controller.isA4SettingExpandedChanged();
                  },
                  expansionAnimationStyle: AnimationStyle(
                      curve: Curves.easeInCirc,
                      duration: const Duration(milliseconds: 100)),
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(3)),
                  trailing: Icon(
                    Icons.arrow_drop_down_sharp,
                    color:
                        controller.isA4SettingExpanded ? white : primaryColor,
                  ),
                  title: Text("A4 ${"Printer settings".tr}",
                      style: titleStyle.copyWith(
                          color: controller.isA4SettingExpanded
                              ? white
                              : primaryColor)),
                  children: [
                    Container(
                      color: white,
                      child: ListTile(
                        title: Text('Upload header image'.tr,
                            style: bodyStyle.copyWith()),
                        trailing: const Icon(
                          Icons.image,
                          color: primaryColor,
                        ),
                        onTap: () {
                          controller.chosea4HeaderFile();
                        },
                      ),
                    ),
                    Container(
                      color: white,
                      child: ListTile(
                        title: Text('Remove header image'.tr,
                            style: bodyStyle.copyWith()),
                        trailing: const Icon(
                          Icons.hide_image_outlined,
                          color: primaryColor,
                        ),
                        onTap: () {
                          controller.removeA4HeaderFile();
                        },
                      ),
                    ),
                    Container(
                      color: white,
                      child: ListTile(
                        title: Text('Show header image'.tr,
                            style: bodyStyle.copyWith()),
                        trailing: Checkbox(
                            fillColor: WidgetStateProperty.all(primaryColor),
                            checkColor: white,
                            value: controller.showA4HeadersImage,
                            onChanged: (value) {
                              controller.showA4HeaderImage(value!);
                            }),
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),
              verticalGap(10),
              //? Customize Mini recive printer:
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, color: isWindows ? white : primaryColor),
                ),
                child: ExpansionTile(
                  minTileHeight: 40,
                  backgroundColor: primaryColor,
                  collapsedBackgroundColor: white,
                  textColor: white,
                  iconColor: white,
                  collapsedTextColor: white,
                  onExpansionChanged: (value) {
                    controller.isMiniPrinterSettingExpandedChanged();
                  },
                  expansionAnimationStyle: AnimationStyle(
                      curve: Curves.easeInCirc,
                      duration: const Duration(milliseconds: 100)),
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(3)),
                  trailing: Icon(
                    Icons.arrow_drop_down_sharp,
                    color: controller.isMiniPrinterSettingExpanded
                        ? white
                        : primaryColor,
                  ),
                  title: Text("Mini Printer settings".tr,
                      style: titleStyle.copyWith(
                          color: controller.isMiniPrinterSettingExpanded
                              ? white
                              : primaryColor)),
                  children: [
                    Container(
                      color: white,
                      child: ListTile(
                        title: Text('Upload header image'.tr,
                            style: bodyStyle.copyWith()),
                        trailing: const Icon(
                          Icons.image,
                          color: primaryColor,
                        ),
                        onTap: () {
                          controller.chooseMiniReciveHeaderFile();
                        },
                      ),
                    ),
                    Container(
                      color: white,
                      child: ListTile(
                        title: Text('Remove header image'.tr,
                            style: bodyStyle.copyWith()),
                        trailing: const Icon(
                          Icons.hide_image_outlined,
                          color: primaryColor,
                        ),
                        onTap: () {
                          controller.removeMiniReciveHeaderFile();
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: isWindows ? white : primaryColor),
                      ),
                      child: ExpansionTile(
                        minTileHeight: 40,
                        backgroundColor: white,
                        collapsedBackgroundColor: white,
                        textColor: primaryColor,
                        iconColor: primaryColor,
                        collapsedTextColor: primaryColor,
                        expansionAnimationStyle: AnimationStyle(
                            curve: Curves.easeInCirc,
                            duration: const Duration(milliseconds: 100)),
                        shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(3)),
                        trailing: const Icon(
                          Icons.arrow_drop_down_sharp,
                          color: primaryColor,
                        ),
                        title: Text("Roll width".tr, style: bodyStyle),
                        children: [
                          Container(
                            color: Colors.white,
                            child: ListTile(
                              title:
                                  Text('80mm'.tr, style: bodyStyle.copyWith()),
                              trailing: Radio<int>(
                                fillColor:
                                    WidgetStateProperty.all(primaryColor),
                                activeColor: secondColor,
                                groupValue: controller.groupValuePaperSize,
                                value: 1,
                                onChanged: (value) {
                                  if (value != null) {
                                    controller
                                        .switchMiniPrinterPaperSize(value);
                                  }
                                },
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            child: ListTile(
                              title:
                                  Text('58mm'.tr, style: bodyStyle.copyWith()),
                              trailing: Radio<int>(
                                fillColor:
                                    WidgetStateProperty.all(primaryColor),
                                activeColor: secondColor,
                                groupValue: controller.groupValuePaperSize,
                                value: 0,
                                onChanged: (value) {
                                  if (value != null) {
                                    controller
                                        .switchMiniPrinterPaperSize(value);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: white,
                      child: ListTile(
                        title: Text('Show header image'.tr,
                            style: bodyStyle.copyWith()),
                        trailing: Checkbox(
                            fillColor: WidgetStateProperty.all(primaryColor),
                            checkColor: white,
                            value: myServices.sharedPreferences
                                    .getBool("show_mini_image") ??
                                controller.showMiniReciveHeadersImage,
                            onChanged: (value) {
                              controller.showMiniReciveHeaderImage(value!);
                            }),
                        onTap: () {},
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        title:
                            Text('Group Print'.tr, style: bodyStyle.copyWith()),
                        trailing: Radio<int>(
                          fillColor: WidgetStateProperty.all(primaryColor),
                          activeColor: secondColor,
                          groupValue: controller
                              .groupValueState, // Current selected value
                          value: 1, // Group Print option
                          onChanged: (value) {
                            if (value != null) {
                              controller.switchPrinterLayout(value);
                            }
                          },
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        title:
                            Text('List Print'.tr, style: bodyStyle.copyWith()),
                        trailing: Radio<int>(
                          fillColor: WidgetStateProperty.all(primaryColor),
                          activeColor: secondColor,
                          groupValue: controller.groupValueState,
                          value: 0,
                          onChanged: (value) {
                            if (value != null) {
                              controller.switchPrinterLayout(value);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              verticalGap(10),
              //? Header Selection:
              InkWell(
                onTap: () => showMultiSelectDialog(context, "header"),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: white,
                    border: Border.all(color: isWindows ? white : primaryColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select Headers".tr,
                        style: titleStyle.copyWith(
                            fontSize: 16, color: primaryColor),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
              verticalGap(10),
              // //? Footer Selection:
              // InkWell(
              //   onTap: () => showMultiSelectDialog(context, "footer"),
              //   child: Container(
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              //     decoration: BoxDecoration(
              //       color: white,
              //       border: Border.all(color: isWindows ? white : primaryColor),
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Text(
              //           "Select Footers".tr,
              //           style: titleStyle.copyWith(
              //               fontSize: 16, color: primaryColor),
              //         ),
              //         Icon(
              //           Icons.arrow_drop_down,
              //           color: primaryColor,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // verticalGap(10),
              //? Column Selection:
              InkWell(
                onTap: () => showMultiSelectDialog(context, "column"),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: white,
                    border: Border.all(color: isWindows ? white : primaryColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select Columns".tr,
                        style: titleStyle.copyWith(
                            fontSize: 16, color: primaryColor),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
              verticalGap(10),
              Container(
                height: 45,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: white,
                  border: Border.all(color: isWindows ? white : primaryColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Auto Print".tr,
                      style: titleStyle.copyWith(fontSize: 16.sp),
                    ),
                    Checkbox(
                        value: myServices.systemSharedPreferences
                                .getBool("auto_print") ??
                            controller.autoPrint,
                        onChanged: (val) {
                          controller.autoPrintChange(val);
                        })
                  ],
                ),
              ),
              verticalGap(10),
              //? Color:
              Container(
                height: 45,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: white,
                  border: Border.all(color: isWindows ? white : primaryColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Color".tr,
                      style: titleStyle.copyWith(fontSize: 16.sp),
                    ),
                    InkWell(
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                "Pick a color",
                                style: titleStyle,
                              ),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: controller.currentColor,
                                  enableAlpha: false,
                                  onColorChanged: (Color color) async {
                                    controller.currentColor = color;
                                    await controller
                                        .saveColor(controller.currentColor);
                                    controller.update();
                                  },
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: Text(
                                    "Select",
                                    style: bodyStyle,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        width: 60,
                        decoration: BoxDecoration(
                            color: Color(myServices.sharedPreferences
                                    .getInt('selected_color') ??
                                // ignore: deprecated_member_use
                                primaryColor.value)),
                      ),
                    )
                  ],
                ),
              ),
              verticalGap(),
              customButtonGlobal(() async {
                controller.printInvoice(
                  {
                    "Customer Name": "دلخوش سعدون",
                    "Organizer Name": "Dilkhosh Saadon",
                    "Total Price": "1500",
                    "Number Of Items": "12",
                    "Customer Phone": "07510407010",
                    "Customer Address": "Duhok Domiz",
                    "Invoice number": "1564",
                    "Date": "15/12/2024",
                    "Discount": "5000",
                    "Taxes": "0",
                    "Payment": "Cash"
                  },
                  {
                    "#": List.generate(2, (index) => "${index + 1}"),
                    "Code": [
                      "A01",
                      "B02",
                    ],
                    "Name": [
                      "Product 1",
                      "Product 2",
                    ],
                    "QTY": List.generate(2, (index) => "${(index + 1) * 10}"),
                    "Price":
                        List.generate(2, (index) => "${(index + 1) * 5}.0"),
                    "Total Price":
                        List.generate(2, (index) => "${(index + 1) * 50}.0"),
                    "Type": List.generate(
                        2,
                        (index) =>
                            "Type ${String.fromCharCode(65 + (index % 26))}"),
                  },
                  "",
                );
              }, "Test", Icons.print, buttonColor, white, null, 45),
            ],
          );
        });
  }

  void showMultiSelectDialog(BuildContext context, String field) {
    Get.put(InvoiceController());
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              field == "header"
                  ? "Select Headers".tr
                  : field == "footer"
                      ? "Select Footers".tr
                      : "Select Columns".tr,
              style: titleStyle),
          content: SizedBox(
            width: double.maxFinite,
            child: GetBuilder<InvoiceController>(builder: (controller) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: field == "header"
                    ? controller.headersTitle.length
                    : field == "footer"
                        ? controller.footersTitle.length
                        : controller.tablesTileTitle.length,
                itemBuilder: (BuildContext context, index) {
                  return CheckboxListTile(
                    title: Text(
                      field == "header"
                          ? controller.headersTitle[index].tr
                          : field == "footer"
                              ? controller.footersTitle[index].tr
                              : controller.tablesTileTitle[index].tr,
                      style: titleStyle,
                    ),
                    value: field == "header"
                        ? controller.headersState[index]
                        : field == "footer"
                            ? controller.footersState[index]
                            : controller.tablesTileState[index],
                    onChanged: field == "header"
                        ? (value) {
                            controller.setHeadersTitleState(index, value!);
                            controller.headerListHeight();
                          }
                        : field == "footer"
                            ? (value) {
                                controller.setFootersTitleState(index, value!);
                                controller.footerListHeight();
                              }
                            : (value) {
                                controller.setTablesTileState(index, value!);
                              },
                  );
                },
              );
            }),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close".tr, style: titleStyle),
            ),
          ],
        );
      },
    );
  }
}
