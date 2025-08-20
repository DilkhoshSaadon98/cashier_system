import 'package:cashier_system/controller/items/units_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/dialogs/show_form_dialog.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/view/units/widgets/units_dialog_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget unitsCardWidget(
    UnitsController controller, int index, BuildContext context) {
  var dataItem = controller.unitsData[index];
  // final int itemsCount = dataItem.itemsCount ?? 0;
  // final String? imagePath =
  //     myServices.sharedPreferences.getString("image_path");
  // final String imageFilePath = "$imagePath/${dataItem.categoriesImage}";
  return GestureDetector(
    onTap: () {
      controller.baseUnitName.text = dataItem.unitBaseName!;
      controller.unitFactor.text = dataItem.factor.toString();
      showFormDialog(context,
          addText: TextRoutes.addUnits,
          editText: TextRoutes.editUnits,
          isUpdate: true,
          child: const UnitsDialogFormWidget(
            isUpdate: true,
          ));
    },
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primaryColor.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              dataItem.unitBaseName!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: titleStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: black,
              ),
            ),
            verticalGap(6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                " ${TextRoutes.unitsConvert.tr}:${dataItem.factor}",
                style: bodyStyle.copyWith(
                  fontSize: 14,
                  color: primaryColor,
                ),
              ),
            ),
            Text(
              dataItem.unitCreateDate!,
              style: bodyStyle,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  tooltip: TextRoutes.edit.tr,
                  onPressed: () {
                    controller.baseUnitName.text = dataItem.unitBaseName!;
                    controller.unitFactor.text = dataItem.factor.toString();
                    showFormDialog(context,
                        addText: TextRoutes.addUnits,
                        editText: TextRoutes.editUnits,
                        isUpdate: true,
                        child: const UnitsDialogFormWidget(
                          isUpdate: true,
                        ));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
