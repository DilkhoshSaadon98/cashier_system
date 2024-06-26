import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/data/model/locale/custom_selected_list_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class CustomDropDownSearchUsers extends GetView<CashierController> {
  final String? title;
  final IconData? iconData;
  final List<CustomSelectedListUsers> listData;
  Color? color;
  TextEditingController? contrllerName;
  TextEditingController? contrllerId;

  CustomDropDownSearchUsers(
      {super.key,
      this.title,
      required this.listData,
      this.color,
      this.contrllerName,
      this.contrllerId,
      this.iconData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        // controller: contrllerName,
        cursorColor: color ?? white,
        onTap: () {
          showDropDownList(context, listData, contrllerName!, contrllerId!);
        },
        style: titleStyle.copyWith(
            color: color ?? white, fontWeight: FontWeight.w100, fontSize: 15),
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          label: Text(
            title!,
            style: titleStyle.copyWith(
                color: color ?? white,
                fontWeight: FontWeight.w100,
                fontSize: 10.sp),
          ),
          hintText: title,
          prefixIcon: Icon(
            iconData,
            color: color ?? white,
          ),
          suffixIcon: Icon(
            Icons.arrow_drop_down,
            color: color ?? white,
          ),
          focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: secondColor, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: thirdColor, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.greenAccent, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: color ?? white, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(5))),
        ),
      ),
    );
  }

  void showDropDownList(
      context,
      List<CustomSelectedListUsers> listData,
      TextEditingController controllerName,
      TextEditingController controllerId) {
    CashierController controller = Get.put(CashierController());
    showModalBottomSheet(
      context: context,
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
      builder: (context) {
        TextEditingController searchController = TextEditingController();
        List<CustomSelectedListUsers> filteredList = listData;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            void filterList(String query) {
              setState(() {
                filteredList = listData.where((item) {
                  final nameLower = item.name.toLowerCase();
                  final phone = item.phone ?? '';
                  final id = item.id ?? '';
                  final addres = item.address ?? '';
                  final searchLower = query.toLowerCase();
                  return nameLower.contains(searchLower) ||
                      id.contains(searchLower) ||
                      phone.contains(searchLower) ||
                      addres.contains(searchLower);
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
                        labelText: 'Search by Name, Phone, Id, or address',
                        labelStyle: bodyStyle,
                        prefixIcon: Icon(
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
                        leading: Text(filteredList[index].id ?? '',
                            style: titleStyle),
                        subtitle:
                            Text(filteredList[index].phone!, style: bodyStyle),
                        trailing: Text(filteredList[index].address.toString(),
                            style: titleStyle),
                        onTap: () {
                          controllerName.text = filteredList[index].name;
                          controllerId.text = filteredList[index].id!;
                          controller.cartOwnerNameUpdate(controllerName.text );
                          Navigator.pop(context);
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
