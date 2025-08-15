import 'package:cashier_system/controller/items/units_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/buttons/custom_button_widget.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnitsDialogFormWidget extends StatelessWidget {
  final bool isUpdate;
  const UnitsDialogFormWidget({super.key, required this.isUpdate});

  @override
  Widget build(BuildContext context) {
    Get.put(UnitsController());
    return GetBuilder<UnitsController>(builder: (controller) {
      return Container(
        alignment: Alignment.center,
        width: 400,
        height: 500,
        child: Form(
          key: controller.formState,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Base Unit
              CustomTextFieldWidget(
                controller: controller.baseUnitName,
                hinttext: TextRoutes.baseUnitExample,
                labeltext: TextRoutes.unitName,
                iconData: Icons.type_specimen_outlined,
                isNumber: false,
                valid: (value) {
                  return validInput(value!, 0, 20, "");
                },
                borderColor: primaryColor,
                fieldColor: white,
              ),
              verticalGap(),
              CustomTextFieldWidget(
                controller: controller.unitFactor,
                hinttext: TextRoutes.unitsConvert,
                labeltext: TextRoutes.unitsConvert,
                iconData: Icons.numbers,
                isNumber: true,
                valid: (value) {
                  return validInput(value!, 0, 20, "real", required: false);
                },
                borderColor: primaryColor,
                fieldColor: white,
              ),

              verticalGap(),

              customButtonWidget(() {
                !isUpdate
                    ? controller.addUnitData()
                    : controller.updateUnitData();
              }, TextRoutes.submit,
                  color: primaryColor, textColor: white, iconData: Icons.save),
            ],
          ),
        ),
      );
    });
  }
}
