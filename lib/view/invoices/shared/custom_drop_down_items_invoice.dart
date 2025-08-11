import 'package:cashier_system/controller/printer/invoice_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/data/model/locale/custom_selected_list_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class CustomDropDownItemsInvoice extends StatelessWidget {
  final String hinttext;
  TextEditingController? nameController;
  TextEditingController? priceController;
  TextEditingController? barcodeController;
  TextEditingController? codeController;
  final String? Function(String?) valid;
  List<CustomSelectedListItems>? data;
  final bool isNumber;
  void Function()? onTap;
  void Function(String)? onChanged;
  Color? color;
  CustomDropDownItemsInvoice(
      {super.key,
      required this.hinttext,
      this.nameController,
      this.priceController,
      this.barcodeController,
      this.codeController,
      required this.valid,
      required this.isNumber,
      this.onTap,
      this.onChanged,
      this.color,
      this.data});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: nameController,
      textAlign: TextAlign.start,
      style: titleStyle.copyWith(color: color ?? primaryColor),
      validator: valid,
      onChanged: onChanged,
      onTap: onTap != null
          ? () {
              showDropDownList(context, data!, nameController!,
                  priceController!, codeController!, barcodeController!);
            }
          : null,
      decoration: InputDecoration(
          fillColor: fieldColor,
          filled: true,
          prefixIcon: Icon(
            Icons.search,
            color: color ?? primaryColor,
          ),
          errorStyle: bodyStyle.copyWith(color: Colors.red),
          hintText: hinttext.tr,
          hintStyle: bodyStyle.copyWith(color: color ?? primaryColor),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: color ?? primaryColor)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: secondColor)),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: color ?? primaryColor))),
    );
  }

  void showDropDownList(
    context,
    List<CustomSelectedListItems> listData,
    TextEditingController controllerName,
    TextEditingController controllerPrice,
    TextEditingController codeController,
    TextEditingController barcodeController,
  ) {
    showModalBottomSheet(
      context: context,
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
      builder: (context) {
        TextEditingController searchController = TextEditingController();
        List<CustomSelectedListItems> filteredList = listData;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            void filterList(String query) {
              setState(() {
                filteredList = listData.where((item) {
                  final nameLower = item.name.toLowerCase();
                  final descLower = item.desc!.toLowerCase();
                  final valueLower = item.value?.toLowerCase() ?? '';
                  final price = item.price ?? '';
                  final searchLower = query.toLowerCase();
                  return nameLower.contains(searchLower) ||
                      valueLower.contains(searchLower) ||
                      descLower.contains(searchLower) ||
                      price.contains(searchLower);
                }).toList();
              });
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Focus(
                    autofocus: true,
                    child: TextField(
                      style: titleStyle,
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText:
                            'Search by Name, Description, Code, or Price'.tr,
                        labelStyle: bodyStyle,
                        prefixIcon: const Icon(
                          Icons.search,
                          color: primaryColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onChanged: filterList,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          filteredList[index].desc ?? "",
                          style: titleStyle,
                        ),
                        subtitle: Text(filteredList[index].value ?? "",
                            style: bodyStyle),
                        trailing:
                            Text(filteredList[index].type!, style: titleStyle),
                        onTap: () {
                          controllerName.text = filteredList[index].desc!;
                          controllerPrice.text = filteredList[index].price!;
                          barcodeController.text = filteredList[index].type!;
                          codeController.text = filteredList[index].value!;
                          InvoiceController invoiceController = Get.find();
                          invoiceController.update();
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
