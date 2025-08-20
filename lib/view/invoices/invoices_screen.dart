// import 'package:cashier_system/core/responsive/screen_builder.dart';
// import 'package:cashier_system/view/invoices/mobile/invoice_screen_mobile.dart';
// import 'package:cashier_system/view/invoices/windows/invoices_screen_windows.dart';
// import 'package:flutter/material.dart';

// class InvoicesScreen extends StatelessWidget {
//   const InvoicesScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const ScreenBuilder(
//       mobile: InvoiceScreenMobile(),
//       windows: InvoicesScreenWindows(),
//     );
//   }
// }
import 'package:cashier_system/controller/items/items_definition_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/constant/screen_routes.dart';
import 'package:cashier_system/core/dialogs/show_form_dialog.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/responsive/divide_screen_widget.dart';
import 'package:cashier_system/core/responsive/screen_builder.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:cashier_system/core/shared/custom_header_screen.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:cashier_system/view/categories/widgets/add_category_form.dart';
import 'package:cashier_system/view/items/widget/custom_add_items.dart';
import 'package:cashier_system/view/units/widgets/units_dialog_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class InvoicesScreen extends StatelessWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map> data = [
      {
        'title': TextRoutes.saleInvoice,
        'image': AppImageAsset.saleInvoicesSvg,
        'on_tap': () {
          Get.toNamed(AppRoute.saleInvoiceScreen);
        }
      },
      {
        'title': TextRoutes.purchaseInvoice,
        'image': AppImageAsset.purchaseInvoicesSvg,
        'on_tap': () {
        }
      },
      {
        'title': TextRoutes.transactionInvoice,
        'image': AppImageAsset.transactionInvoicesSvg,
        'on_tap': () {
       
        }
      },
      {
        'title': TextRoutes.barcodeInvoice,
        'image': AppImageAsset.barcodeInvoicesSvg,
        'on_tap': () {
         
        }
      },
    ];
    Get.put(ItemsDefinitionController());
    return Scaffold(
      backgroundColor: white,
      body: ScreenBuilder(
        windows: DivideScreenWidget(
          showWidget: Center(
            child: SizedBox(
              width: 600.w,
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  return customItemsCard(data[index]);
                },
              ),
            ),
          ),
          actionWidget: const Column(
            children: [
              CustomHeaderScreen(
                imagePath: AppImageAsset.invoicesSvg,
                title: TextRoutes.invoices,
              )
            ],
          ),
        ),
        mobile: Scaffold(
          appBar: customAppBarTitle(TextRoutes.items, true),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SizedBox(
                width: 500.w,
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  itemBuilder: (context, index) {
                    return customItemsCard(data[index]);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget customItemsCard(Map data) {
    return InkWell(
      onTap: data['on_tap'],
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(12.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                data['image'],
                semanticsLabel: 'Icon',
                // ignore: deprecated_member_use
                color: white,
                width: 75,
                height: 75,
              ),
              verticalGap(),
              Text(
                data['title'].toString().tr,
                textAlign: TextAlign.center,
                style: titleStyle.copyWith(
                  color: white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
