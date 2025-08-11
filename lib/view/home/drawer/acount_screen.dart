import 'package:cashier_system/controller/home/account_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/change_direction.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/responsive/screen_builder.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/buttons/custom_buttton_global.dart';
import 'package:cashier_system/core/shared/drop_downs/custom_drop_down_search.dart';
import 'package:cashier_system/core/shared/custom_formfield_global.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/view/home/desktop/home_logo.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AcountScreen extends StatelessWidget {
  const AcountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AccountController());
    return Directionality(
      textDirection: screenDirection(),
      child: Scaffold(
        backgroundColor: white,
        body: SizedBox(
          width: Get.width,
          height: Get.height,
          child: ScreenBuilder(
            windows: Row(
              children: [
                Expanded(
                  child: Scaffold(
                    appBar: customAppBarTitle("Account", true),
                    backgroundColor: white,
                    body: Container(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.all(15),
                      width: Get.width / 2,
                      child:
                          GetBuilder<AccountController>(builder: (controller) {
                        return ListView.builder(
                            itemCount: controller.accountListTitles.length + 1,
                            itemBuilder: (context, index) {
                              return index ==
                                      controller.accountListTitles.length
                                  ? Column(
                                      children: [
                                        verticalGap(),
                                        customButtonGlobal(() async {
                                          await controller.editAdminData();
                                        }, "Save Changes", Icons.save,
                                            buttonColor, white),
                                      ],
                                    )
                                  : index ==
                                          controller.accountListTitles.length -
                                              1
                                      ? CustomDropDownSearch(
                                          contrllerName: controller
                                              .accountListController[index],
                                          contrllerId: controller
                                              .accountListController[index],
                                          color: primaryColor,
                                          iconData: Icons.text_format_rounded,
                                          title: controller
                                              .accountListTitles[index],
                                          listData: [
                                              SelectedListItem(
                                                  name: "Full Access",
                                                  value: "Full Access"),
                                              SelectedListItem(
                                                  name: "Limit Access",
                                                  value: "Limit Access"),
                                            ])
                                      : Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 15),
                                          child: CustomTextFormFieldGlobal(
                                              borderColor: primaryColor,
                                              hinttext: controller
                                                  .accountListTitles[index],
                                              labeltext: controller
                                                  .accountListTitles[index],
                                              iconData:
                                                  Icons.text_format_outlined,
                                              valid: (value) {
                                                return validInput(
                                                    value!, 0, 50, "",
                                                    required:
                                                        index == 1 || index == 3
                                                            ? true
                                                            : false);
                                              },
                                              mycontroller: controller
                                                  .accountListController[index],
                                              isNumber: false),
                                        );
                            });
                      }),
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  color: primaryColor,
                  alignment: Alignment.center,
                  child: buildLogoDesktop(),
                ))
              ],
            ),
            mobile: Scaffold(
              appBar: customAppBarTitle("Account", true),
              body: Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.all(15),
                child: GetBuilder<AccountController>(builder: (controller) {
                  return ListView.builder(
                      itemCount: controller.accountListTitles.length + 1,
                      itemBuilder: (context, index) {
                        return index == controller.accountListTitles.length
                            ? Column(
                                children: [
                                  verticalGap(),
                                  customButtonGlobal(() async {
                                    await controller.editAdminData();
                                  }, "Save Changes", Icons.save, buttonColor,
                                      white),
                                ],
                              )
                            : index == controller.accountListTitles.length - 1
                                ? CustomDropDownSearch(
                                    contrllerName:
                                        controller.accountListController[index],
                                    contrllerId:
                                        controller.accountListController[index],
                                    color: primaryColor,
                                    iconData: Icons.text_format_rounded,
                                    title: controller.accountListTitles[index],
                                    listData: [
                                        SelectedListItem(
                                            name: "Full Access",
                                            value: "Full Access"),
                                        SelectedListItem(
                                            name: "Limit Access",
                                            value: "Limit Access"),
                                      ])
                                : Container(
                                    margin: const EdgeInsets.only(bottom: 15),
                                    child: CustomTextFormFieldGlobal(
                                        borderColor: primaryColor,
                                        hinttext:
                                            controller.accountListTitles[index],
                                        labeltext:
                                            controller.accountListTitles[index],
                                        iconData: Icons.text_format_outlined,
                                        valid: (value) {
                                          return validInput(value!, 0, 50, "",
                                              required: index == 1 || index == 3
                                                  ? true
                                                  : false);
                                        },
                                        mycontroller: controller
                                            .accountListController[index],
                                        isNumber: false),
                                  );
                      });
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
