
import 'package:cashier_system/controller/items/units_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/dialogs/show_form_dialog.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/responsive/divide_screen_widget.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_search_widget.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/buttons/custom_buttton_global.dart';
import 'package:cashier_system/view/units/widgets/custom_show_units.dart';
import 'package:cashier_system/view/units/widgets/units_dialog_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnitsScreenWindows extends StatelessWidget {
  const UnitsScreenWindows({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UnitsController());
    return Scaffold(
      body: GetBuilder<UnitsController>(builder: (controller) {
        return DivideScreenWidget(
          //! View UNits
          showWidget: ListView(
            children: [
              customAppBarTitle(TextRoutes.viewUnits),
              const CustomShowUnits(),
            ],
          ),
          actionWidget: ListView(
            children: [
              //! Custom Header:
              const CustomHeaderScreen(
                imagePath: AppImageAsset.unitsViewSvg,
                showBackButton: true,
                title: TextRoutes.viewUnits,
              ),
              verticalGap(),

              customButtonGlobal(() async {
                showFormDialog(context,
                    addText: TextRoutes.addUnits,
                    editText: TextRoutes.editUnits,
                    isUpdate: false,
                    child: const UnitsDialogFormWidget(
                      isUpdate: false,
                    ));
              }, TextRoutes.addUnits, Icons.add_box_outlined, white,
                  primaryColor),
              verticalGap(),
              CustomSearchField(
                borderColor: white,
                hinttext: TextRoutes.searchInCatagories,
                iconData: Icons.search,
                mycontroller: controller.search,
                onChanged: (val) {
                  controller.onSearchItems();
                },
                isNumber: false,
                labeltext: TextRoutes.search,
                valid: (value) {
                  return validInput(value!, 3, 100, '');
                },
              )
            ],
          ),
        );
      }),
    );
  }
}
