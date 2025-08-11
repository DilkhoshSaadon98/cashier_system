import 'package:cashier_system/view/clients/widgets/add_users_account_dialog.dart';
import 'package:flutter/material.dart';
import 'package:cashier_system/controller/clients_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/dialogs/show_form_dialog.dart';
import 'package:cashier_system/core/functions/date_picker.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/buttons/screen_action_buttons.dart';
import 'package:cashier_system/core/shared/custom_divider.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/custom_text_field_widget.dart';
import 'package:cashier_system/core/shared/drop_downs/drop_down_menu.dart';
import 'package:cashier_system/core/shared/drop_downs/sort_drop_down.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ClientActionWidget extends StatelessWidget {
  final bool isMobile;
  const ClientActionWidget({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    Color backColor = isMobile ? white : primaryColor;
    Color textColor = isMobile ? primaryColor : white;
    Get.put(ClientsController());
    return GetBuilder<ClientsController>(builder: (controller) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView(
            children: [
              if (!isMobile) ...[
                const CustomHeaderScreen(
                  imagePath: AppImageAsset.addAccount,
                  title: TextRoutes.clientsAccounts,
                ),
                verticalGap(),
              ],

              DropDownMenu(
                contentColor: backColor,
                fieldColor: textColor,
                selectedValue: controller.selectedSection,
                items: const [
                  TextRoutes.customers,
                  TextRoutes.suppliers,
                ],
                onChanged: (value) {
                  controller.changeAccountSection(value!);
                },
              ),
              verticalGap(5),
              verticalGap(),
              Text(
                TextRoutes.sortBy.tr,
                style: titleStyle.copyWith(color: textColor),
              ),
              verticalGap(5),
              SortDropdown(
                selectedValue: controller.selectedSortField,
                items: controller.accountSortFields,
                onChanged: controller.changeSortField,
                contentColor: isMobile ? backColor : textColor,
                fieldColor: buttonColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.sortAscending
                        ? TextRoutes.sortAsc.tr
                        : TextRoutes.sortDesc.tr,
                    style: bodyStyle.copyWith(color: textColor),
                  ),
                  IconButton(
                    icon: Icon(
                      controller.sortAscending
                          ? FontAwesomeIcons.arrowDownAZ
                          : FontAwesomeIcons.arrowDownZA,
                      color: textColor,
                    ),
                    onPressed: controller.toggleSortOrder,
                    tooltip: controller.sortAscending
                        ? TextRoutes.sortAsc.tr
                        : TextRoutes.sortDesc.tr,
                  ),
                ],
              ),
              customDivider(textColor),
              Text(
                TextRoutes.searchBy.tr,
                style: titleStyle.copyWith(color: textColor),
              ),
              verticalGap(5),
              CustomTextFieldWidget(
                  fieldColor: backColor,
                  borderColor: textColor,
                  controller: controller.nameController,
                  hinttext: TextRoutes.customerName,
                  labeltext: TextRoutes.customerName,
                  iconData: Icons.person,
                  valid: (value) {
                    return validInput(value!, 0, 100, '');
                  },
                  isNumber: false),
              verticalGap(10),
              CustomTextFieldWidget(
                  fieldColor: backColor,
                  borderColor: textColor,
                  controller: controller.phoneController,
                  hinttext: TextRoutes.phoneNumber,
                  labeltext: TextRoutes.phoneNumber,
                  iconData: Icons.person,
                  valid: (value) {
                    return validInput(value!, 0, 100, '');
                  },
                  isNumber: true),
              verticalGap(10),
              CustomTextFieldWidget(
                  fieldColor: backColor,
                  borderColor: textColor,
                  controller: controller.addressController,
                  hinttext: TextRoutes.address,
                  labeltext: TextRoutes.address,
                  iconData: Icons.person,
                  valid: (value) {
                    return validInput(value!, 0, 100, '');
                  },
                  isNumber: false),
              verticalGap(10),
              Text(
                TextRoutes.userId.tr,
                style: bodyStyle.copyWith(color: textColor),
              ),
              verticalGap(10),
              CustomTextFieldWidget(
                  fieldColor: backColor,
                  borderColor: textColor,
                  controller: controller.fromNoController,
                  hinttext: TextRoutes.fromUserId,
                  labeltext: TextRoutes.fromUserId,
                  iconData: Icons.numbers,
                  valid: (value) {
                    return validInput(value!, 0, 100, 'number');
                  },
                  isNumber: true),
              verticalGap(10),
              CustomTextFieldWidget(
                  fieldColor: backColor,
                  borderColor: textColor,
                  controller: controller.toNoController,
                  hinttext: TextRoutes.toUserId,
                  labeltext: TextRoutes.toUserId,
                  iconData: Icons.numbers,
                  valid: (value) {
                    return validInput(value!, 0, 100, 'number');
                  },
                  isNumber: true),
              verticalGap(10),
              Text(
                TextRoutes.date.tr,
                style: bodyStyle.copyWith(color: textColor),
              ),
              verticalGap(10),
              CustomTextFieldWidget(
                  fieldColor: backColor,
                  borderColor: textColor,
                  controller: controller.fromDateController,
                  hinttext: TextRoutes.fromDate,
                  labeltext: TextRoutes.fromDate,
                  iconData: Icons.date_range,
                  readOnly: true,
                  onTap: () {
                    selectDate(context, controller.fromDateController);
                  },
                  valid: (value) {
                    return validInput(value!, 0, 100, '');
                  },
                  isNumber: true),
              verticalGap(10),
              CustomTextFieldWidget(
                  fieldColor: backColor,
                  borderColor: textColor,
                  controller: controller.toDateController,
                  hinttext: TextRoutes.toDate,
                  labeltext: TextRoutes.toDate,
                  iconData: Icons.date_range,
                  readOnly: true,
                  onTap: () {
                    selectDate(context, controller.toDateController);
                  },
                  valid: (value) {
                    return validInput(value!, 0, 100, '');
                  },
                  isNumber: true),
              verticalGap(60)
              //   customerActionWidget(controller, context)
            ],
          ),
          screenActionButtonWidget(
            context,
            backColor: backColor,
            onPressedAdd: () {
              controller.selectedSection == TextRoutes.customers
                  ? showFormDialog(context,
                      isUpdate: false,
                      addText: TextRoutes.addNewCustomer,
                      editText: TextRoutes.editAccount,
                      child: AddUsersAccountDialog(
                        isUpdate: false,
                        data: controller.addCustomerFields,
                        formState: controller.formState,
                        onPressed: () {
                          controller.addCustomerData(context);
                        },
                      ))
                  : showFormDialog(context,
                      isUpdate: false,
                      addText: TextRoutes.addNewSupplier,
                      editText: TextRoutes.editAccount,
                      child: AddUsersAccountDialog(
                        isUpdate: false,
                        data: controller.addSupplierFields,
                        formState: controller.formState,
                        onPressed: () {
                          controller.addSupplierData(context);
                        },
                      ));
            },
            onPressedClear: () {
              controller.clearSearchFields();
            },
            onPressedSearch: () {
              controller.onSearchData(true)();
            },
          )
        ],
      );
    });
  }
}
