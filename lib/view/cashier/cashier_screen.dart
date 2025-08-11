import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/screen_routes.dart';
import 'package:cashier_system/core/responsive/divide_screen_widget.dart';
import 'package:cashier_system/core/responsive/screen_builder.dart';
import 'package:cashier_system/core/dialogs/custom_snack_bar.dart';
import 'package:cashier_system/view/cashier/mobile/cashier_screen_mobile.dart';
import 'package:cashier_system/view/cashier/windows/view/cashier_view_section_screen.dart';
import 'package:cashier_system/view/cashier/windows/action/cashier_action_side.dart';
import 'package:cashier_system/view/cashier/windows/action/components/payment_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';

// ignore: must_be_immutable
class CashierScreen extends StatelessWidget {
  CashierScreen({super.key});

  String numberBuffer = '';

  late bool visible;

  CashierController controller = Get.put(CashierController());

  @override
  Widget build(BuildContext context) {
    Get.put(CashierController());
    return GetBuilder<CashierController>(builder: (controller) {
      return Scaffold(
        backgroundColor: primaryColor,
        body: VisibilityDetector(
          key: const Key('visible-detector-key'),
          onVisibilityChanged: (VisibilityInfo info) {
            visible = info.visibleFraction > 0;
          },
          child: BarcodeKeyboardListener(
            bufferDuration: const Duration(milliseconds: 10),
            onBarcodeScanned: (barcode) async {
              if (barcode.isNotEmpty) {
                controller.isBarcodeScanning = true;
                controller.update();

                await controller.addItemsToCart(
                  "_",
                  controller.myServices.systemSharedPreferences
                      .getString('cart_number')!,
                  barcode: barcode,
                );
                controller.myServices.systemSharedPreferences
                    .setBool("start_new_cart", false);
              } else {
                controller.isBarcodeScanning = false;
                controller.update();
              }
            },
            child: Focus(
              autofocus: true,
              focusNode: controller.focusNode,
              onKeyEvent: (node, event) {
                if (event is KeyDownEvent) {
                  handleKeyPress(event);
                }
                return KeyEventResult.ignored;
              },
              child: const ScreenBuilder(
                windows: DivideScreenWidget(
                  showWidget: CashierViewSectionScreen(),
                  actionWidget: CashierActionSide(),
                ),
                mobile: CashierScreenMobile(),
              ),
            ),
          ),
        ),
      );
    });
  }

  void handleKeyPress(KeyEvent event) {
    String keyLabel = event.logicalKey.keyLabel;

    if (keyLabel.length == 1) {
      numberBuffer += keyLabel;
    } else if (event.logicalKey.keyId >= LogicalKeyboardKey.numpad0.keyId &&
        event.logicalKey.keyId <= LogicalKeyboardKey.numpad9.keyId) {
      numberBuffer += keyLabel.substring(keyLabel.length - 1);
    }

    handleSpecialKeys(event);
    //?Back Button:
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      Get.offAndToNamed(AppRoute.homeScreen);
      numberBuffer = '';
    }
    //? Payment Button:
    if (event.logicalKey == LogicalKeyboardKey.enter &&
        !controller.isBarcodeScanning) {
      customPaymentDialog();
      numberBuffer = '';
      controller.isBarcodeScanning = false;
    }


  }

  void handleSpecialKeys(KeyEvent event) {
    // Detect if Control is pressed
    // ignore: deprecated_member_use
    bool isControlPressed = RawKeyboard.instance.keysPressed
            .contains(LogicalKeyboardKey.controlLeft) ||
        // ignore: deprecated_member_use
        RawKeyboard.instance.keysPressed
            .contains(LogicalKeyboardKey.controlRight);
    // Detect if Tab is pressed
    bool isTabPressed =
        // ignore: deprecated_member_use
        RawKeyboard.instance.keysPressed.contains(LogicalKeyboardKey.tab);

    for (var button in controller.buttonsDetails) {
      if (isControlPressed &&
          button['keyboard'] != null &&
          button['keyboard'] is List<LogicalKeyboardKey> &&
          button['keyboard'].contains(event.logicalKey)) {
        button['function'](button['title']);
        numberBuffer = '';
        break;
      }
    }

    if (isTabPressed && numberBuffer.isNotEmpty) {
      int? pressedNumber = int.tryParse(numberBuffer);
      if (pressedNumber != null &&
          pressedNumber > 0 &&
          pressedNumber <= controller.cartsNumbers.length) {
        controller.navigateToCart(pressedNumber - 1);
      } else {
        customSnackBar("Fail", "Cart Not Found");
      }
      numberBuffer = '';
    }
  }
}
