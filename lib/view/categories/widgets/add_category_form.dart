import 'package:cashier_system/controller/catagories/catagories_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/functions/validinput.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/responsive/responsive_builder.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/core/shared/custom_text_field_widget.dart';
import 'package:cashier_system/view/items/widget/upload_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class AddCategoryForm extends StatelessWidget {
  final bool isUpdate;
  const AddCategoryForm({
    required this.isUpdate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GetBuilder<CatagoriesController>(
          init: CatagoriesController(),
          autoRemove: false,
          builder: (controller) {
            return Form(
              key: controller.formState,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      children: [
                        GetBuilder<CatagoriesController>(builder: (controller) {
                          return UploadImage(
                              file: controller.file,
                              onRemove: () {
                                controller.removeFile();
                              },
                              onTap: () {
                                controller.choseFile();
                              });
                        }),
                        verticalGap(20),
                        CustomTextFieldWidget(
                          hinttext: TextRoutes.categoriesName,
                          labeltext: TextRoutes.categoriesName,
                          iconData: Icons.category,
                          controller: controller.catagoriesName,
                          valid: (value) => validInput(value ?? '', 0, 100, "",
                              required: true),
                          fieldColor: white,
                          borderColor: primaryColor,
                          isNumber: false,
                        )
                      ],
                    ),
                    verticalGap(15),
                    dialogButtonWidget(
                      context,
                      () {
                        isUpdate
                            ? controller.updateCategories(
                                controller.catagoriesId!.text, context)
                            : controller.addCategories(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

void showAddCategoryForm(BuildContext context, bool isUpdate) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(constRadius),
          side: const BorderSide(
            color: primaryColor,
            width: .5,
          ),
        ),
        title: Center(
          child: Text(
            !isUpdate
                ? TextRoutes.addCategories.tr.toUpperCase()
                : TextRoutes.editCategories.tr.toUpperCase(),
            style: titleStyle,
          ),
        ),
        content: AddCategoryForm(
          isUpdate: isUpdate,
        ),
      );
    },
  );
}

Widget dialogButtonWidget(BuildContext context, void Function()? onPressed) {
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: ResponsiveBuilder.isMobile(context)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: _buildButtons(
                context,
                onPressed,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: _buildButtons(
                context,
                onPressed,
              ),
            ));
}

List<Widget> _buildButtons(
  BuildContext context,
  void Function()? onPressed,
) {
  return [
    SizedBox(
      width: 130,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.cancel),
        label: Text(
          TextRoutes.cancel.tr,
          overflow: TextOverflow.clip,
          style: bodyStyle.copyWith(color: white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
      ),
    ),
    !ResponsiveBuilder.isMobile(context)
        ? const SizedBox(
            width: 5,
          )
        : verticalGap(5),
    SizedBox(
      width: 130,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.check),
        label: Text(
          TextRoutes.submit.tr,
          overflow: TextOverflow.clip,
          style: bodyStyle.copyWith(color: white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
    ),
  ];
}
