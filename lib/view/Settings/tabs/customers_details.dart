import 'package:cashier_system/controller/setting/setting_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/view/Settings/widgets/custom_dropdown_setting.dart';
import 'package:cashier_system/view/Settings/widgets/custom_textfield_setting.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomersDetails extends StatelessWidget {
  const CustomersDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(builder: (controller) {
      return Scaffold(
        appBar: customAppBarTitle("Customer Details"),
        body: SingleChildScrollView(
          child: SizedBox(
            width: Get.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 500,
                  child: Column(
                    children: [
                      customSizedBox(30),
                      CustomDropDownSetting(
                        contrllerId: controller.userIdController,
                        contrllerName: controller.userNameController,
                        iconData: Icons.person_search,
                        title: "Search Users",
                        color: primaryColor,
                        listData: controller.dropDownListUsers,
                      ),
                      customSizedBox(),
                      CustomTextFieldSetting("User Names",
                          controller.userNameController, "", Icons.person),
                      CustomTextFieldSetting("Phone Number 1",
                          controller.userPhone1Controller, "", Icons.phone),
                      CustomTextFieldSetting("Phone Number 2",
                          controller.userPhone2Controller, "", Icons.phone),
                      CustomTextFieldSetting(
                          "Address",
                          controller.userAddressController,
                          "",
                          Icons.gps_fixed),
                      CustomTextFieldSetting("E-mail",
                          controller.userEmailController, "email", Icons.email),
                      CustomTextFieldSetting(
                          "Note",
                          controller.userNoteController,
                          "",
                          Icons.info_outlined),
                      Container(
                        width: 500,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "User Role",
                                style: titleStyle.copyWith(fontSize: 20),
                              ),
                            ),
                            Expanded(
                                flex: 2,
                                child: CustomDropDownSetting(
                                  contrllerId: controller.userRoleIdController,
                                  contrllerName: controller.userRoleController,
                                  iconData: Icons.verified_user_sharp,
                                  title: "User Role",
                                  color: primaryColor,
                                  listData: [
                                    SelectedListItem(
                                        name: "Admin", value: "Admin"),
                                    SelectedListItem(
                                        name: "Customer", value: "Customer"),
                                    SelectedListItem(
                                        name: "Suppliers", value: "Suppliers"),
                                  ],
                                ))
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          customButtonGlobal(() {
                            controller.userIdController.text.isEmpty
                                ? controller.addUsers()
                                : controller.editUsers();
                          }, "Save Changes", Icons.save, primaryColor, white,
                              220),
                          const SizedBox(
                            width: 30,
                          ),
                          customButtonGlobal(() {
                            controller.deleteUser();
                          }, "Remove User", Icons.delete, Colors.red, white,
                              220),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
