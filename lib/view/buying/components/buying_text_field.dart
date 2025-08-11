import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/data/model/locale/custom_selected_list_items.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextFormFieldBuying extends StatelessWidget {
  final String hinttext;
  TextEditingController? nameController;
  TextEditingController? idController;
  final String? Function(String?) valid;
  List<CustomSelectedListItems>? data;
  final bool isNumber;
  void Function()? onTap;
  void Function(String)? onChanged;
  CustomTextFormFieldBuying(
      {super.key,
      required this.hinttext,
      this.nameController,
      this.idController,
      required this.valid,
      required this.isNumber,
      this.onTap,
      this.onChanged,
      this.data});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: nameController,
      textAlign: TextAlign.center,
      style: titleStyle,
      validator: valid,
      onChanged: onChanged,
      onTap: onTap != null
          ? () {
              showDropDownList(context, data!, idController!, nameController!);
            }
          : null,
      decoration: InputDecoration(
          errorStyle: bodyStyle.copyWith(color: Colors.red),
          hintText: hinttext,
          hintStyle: bodyStyle,
          border: InputBorder.none),
    );
  }

  void showDropDownList(
      context,
      List<CustomSelectedListItems> listData,
      TextEditingController controllerName,
      TextEditingController controllerId) {
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
                            'Search by Name, Description, Code, or Price',
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
