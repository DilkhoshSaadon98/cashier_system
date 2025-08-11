import 'package:cashier_system/controller/clients_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/dialogs/show_form_dialog.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/buttons/custom_floating_button.dart';
import 'package:cashier_system/data/model/users_model.dart';
import 'package:cashier_system/view/clients/widgets/add_users_account_dialog.dart';
import 'package:cashier_system/view/widgets/tables/table_cell.dart';
import 'package:cashier_system/view/widgets/tables/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomerClientTableWidget extends StatelessWidget {
  final bool? showBackButton;
  const CustomerClientTableWidget({super.key, this.showBackButton});

  @override
  Widget build(BuildContext context) {
    ClientsController controller = Get.put(ClientsController());
    void showDialogBox(UsersModel dataItem) {
      controller.customShowPopupMenu.showPopupMenu(
        context,
        [
          TextRoutes.edit,
        ],
        [
          controller.selectedSection == TextRoutes.customers
              ? () {
                  controller.customerNameController.text = dataItem.usersName;
                  controller.customerPhone1Controller.text =
                      dataItem.usersPhone;
                  controller.customerPhone2Controller.text =
                      dataItem.usersPhone2;
                  controller.customerEmailController.text = dataItem.usersEmail;
                  controller.customerAddressController.text =
                      dataItem.usersAddress;
                  controller.customerNoteController.text = dataItem.usersNote;
                  controller.customerId = dataItem.usersId;
                  showFormDialog(context,
                      isUpdate: true,
                      addText: TextRoutes.addNewCustomer,
                      editText: TextRoutes.editAccount,
                      child: AddUsersAccountDialog(
                        isUpdate: false,
                        data: controller.addCustomerFields,
                        formState: controller.formState,
                        onPressed: () {
                          controller.editCustomerData(context);
                        },
                      ));
                }
              : () {
                  controller.supplierNameController.text = dataItem.usersName;
                  controller.supplierPhone1Controller.text =
                      dataItem.usersPhone;
                  controller.supplierPhone2Controller.text =
                      dataItem.usersPhone2;
                  controller.supplierEmailController.text = dataItem.usersEmail;
                  controller.supplierAddressController.text =
                      dataItem.usersAddress;
                  controller.supplierNoteController.text = dataItem.usersNote;
                  controller.supplierId = dataItem.usersId;
                  showFormDialog(context,
                      isUpdate: true,
                      addText: TextRoutes.addNewSupplier,
                      editText: TextRoutes.editAccount,
                      child: AddUsersAccountDialog(
                        isUpdate: false,
                        data: controller.addSupplierFields,
                        formState: controller.formState,
                        onPressed: () {
                          controller.editSupplierData(context);
                        },
                      ));
                }
        ],
      );
    }

    Widget buildCell(String text, var data) => tableCell(
          text,
          onTap: () {
            showDialogBox(data);
          },
          onSecondaryTap: () {
            showDialogBox(data);
          },
          onTapDown: (value) =>
              controller.customShowPopupMenu.storeTapPosition(value),
        );

    return GetBuilder<ClientsController>(builder: (_) {
      return Scaffold(
        floatingActionButton: customFloatingButton(
            controller.showBackToTopButton, controller.scrollControllers),
        body: Container(
          color: white,
          alignment: Alignment.topCenter,
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo is ScrollUpdateNotification &&
                  scrollInfo.scrollDelta != null &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent &&
                  scrollInfo.scrollDelta! > 0 &&
                  !controller.isLoading &&
                  scrollInfo.metrics.axis == Axis.vertical) {
                controller.fetchCustomersData();
              }
              return false;
            },
            child: TableWidget(
              allSelected: false,
              columns: const [
                " ",
                TextRoutes.code,
                TextRoutes.customerName,
                TextRoutes.phoneNumber,
                TextRoutes.phoneNumber2,
                TextRoutes.address,
                TextRoutes.eMail,
                TextRoutes.accountType,
                TextRoutes.accountCode,
                TextRoutes.date,
              ],
              flexes: const [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2],
              onRowDoubleTap: (index) {},
              onHeaderDoubleTap: (_) {
                //  controller.selectAllRows();
              },
              verticalScrollController: controller.scrollControllers,
              showHeader: true,
              rows: List.generate(controller.customersData.length, (index) {
                final record = controller.customersData[index];
                // final isSelected =
                //     controller.isSelected(transaction.transactionId);

                return [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Checkbox(
                      value: false,
                      onChanged: (checked) {
                        // controller.selectData(
                        //     transaction.transactionId, checked ?? false);
                      },
                    ),
                  ),
                  buildCell(record.usersId.toString(), record),
                  buildCell(record.usersName.toString(), record),
                  buildCell(record.usersPhone, record),
                  buildCell(record.usersPhone2, record),
                  buildCell(record.usersAddress, record),
                  buildCell(record.usersEmail, record),
                  buildCell(record.accountType.tr, record),
                  buildCell(record.accountCode, record),
                  buildCell(record.usersCreateDate, record),
                  const SizedBox(
                    // ignore: dead_code
                    key: false ? ValueKey("selected") : null,
                  ),
                ];
              }),
            ),
          ),
        ),
      );
    });
  }
}
