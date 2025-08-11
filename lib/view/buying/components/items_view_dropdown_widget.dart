import 'package:cashier_system/controller/buying/buying_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/screen_routes.dart';
import 'package:cashier_system/data/model/locale/custom_selected_list_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ItemsViewDropdownWidget extends StatelessWidget {
  final String hinttext;
  TextEditingController? nameController;
  TextEditingController? idController;
  TextEditingController? controllerType;
  TextEditingController? controllerPrice;
  TextEditingController? controllerTotalPrice, controllerDiscountTotalPrice;
  final String? Function(String?) valid;
  List<CustomSelectedListItems>? data;
  final int? passedIndex;
  final bool isNumber;
  void Function()? onTap;
  void Function(String)? onChanged;
  ItemsViewDropdownWidget(
      {super.key,
      required this.hinttext,
      this.nameController,
      this.idController,
      this.controllerType,
      this.controllerPrice,
      this.controllerTotalPrice,
      this.controllerDiscountTotalPrice,
      required this.valid,
      required this.isNumber,
      this.onTap,
      this.onChanged,
      this.data,
      this.passedIndex});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: isNumber ? idController : nameController,
      textAlign: TextAlign.center,
      style: bodyStyle,
      validator: valid,
      onChanged: onChanged,
      onTap: onTap != null
          ? () {
              showDropDownList(context, data!, nameController!, idController!,
                  controllerPrice!,
                  discountTotalPrice: controllerDiscountTotalPrice!,
                  totalPrice: controllerTotalPrice,
                  passedIndex: passedIndex);
            }
          : null,
      decoration: InputDecoration(
          errorStyle: bodyStyle.copyWith(color: Colors.red),
          hintText: hinttext.tr,
          hintStyle: bodyStyle,
          border: InputBorder.none),
    );
  }

  void showDropDownList(
    context,
    List<CustomSelectedListItems> listData,
    TextEditingController controllerName,
    TextEditingController controllerId,
    TextEditingController controllerPrice, {
    int? passedIndex,
    TextEditingController? totalPrice,
    TextEditingController? discountTotalPrice,
  }) {
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
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(constRadius)),
                      child: IconButton(
                          onPressed: () {
                            Get.toNamed(AppRoute.itemsScreen);
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.add,
                            color: white,
                          )),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
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
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          filteredList[index].name,
                          style: titleStyle,
                        ),
                        leading: Text(filteredList[index].value ?? '',
                            style: titleStyle),
                        subtitle:
                            Text(filteredList[index].desc!, style: bodyStyle),
                        trailing: Text(filteredList[index].price.toString(),
                            style: titleStyle),
                        onTap: () {
                          controllerName.text = filteredList[index].name;
                          controllerId.text = filteredList[index].value!;

                          controllerPrice.text =
                              filteredList[index].price.toString();

                          if (controllerPrice.text.isNotEmpty &&
                              passedIndex != null) {
                            BuyingController buyingController =
                                Get.put(BuyingController());
                            buyingController.onItemSelected(
                                controllerPrice,
                                controllerTotalPrice!,
                                controllerDiscountTotalPrice!,
                                passedIndex);
                          }
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
