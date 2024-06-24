import 'package:cashier_system/controller/cashier/cashier_controller.dart';
import 'package:cashier_system/core/constant/routes.dart';
import 'package:cashier_system/core/responsive/responsive_builder.dart';
import 'package:cashier_system/core/shared/custom_snack_bar.dart';
import 'package:cashier_system/view/cashier/mobile/cashier_screen_mobile.dart';
import 'package:cashier_system/view/cashier/windows/left_side/cashier_left_side_screen.dart';
import 'package:cashier_system/view/cashier/windows/left_side/components/show_drop_down_items_dialog.dart';
import 'package:cashier_system/view/cashier/windows/right_side/cashier_right_side.dart';
import 'package:cashier_system/view/cashier/windows/right_side/components/payment_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CashierScreen extends StatefulWidget {
  const CashierScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CashierScreenState createState() => _CashierScreenState();
}

class _CashierScreenState extends State<CashierScreen> {
  String numberBuffer = '';
  String mainKeyboardBuffer = '';
  String numpadBuffer = '';
  CashierController controller = Get.put(CashierController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Focus(
        autofocus: true,
        focusNode: controller.focusNode,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent) {
            LogicalKeyboardKey key = event.logicalKey;

            //! Checking for Control key press using RawKeyboard
            // ignore: deprecated_member_use
            bool isControlPressed = RawKeyboard.instance.keysPressed
                    .contains(LogicalKeyboardKey.controlLeft) ||
                // ignore: deprecated_member_use
                RawKeyboard.instance.keysPressed
                    .contains(LogicalKeyboardKey.controlRight);
            // ignore: deprecated_member_use
            bool isTabPressed = RawKeyboard.instance.keysPressed
                .contains(LogicalKeyboardKey.tab);
            if (event.logicalKey.keyLabel.length == 1) {
              numberBuffer += event.logicalKey.keyLabel;
            } else if (event.logicalKey.keyId >=
                    LogicalKeyboardKey.numpad0.keyId &&
                event.logicalKey.keyId <= LogicalKeyboardKey.numpad9.keyId) {
              numberBuffer += event.logicalKey.keyLabel
                  .substring(event.logicalKey.keyLabel.length - 1);
            }
            //! Handling number buffer when Control key is pressed
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

            //! Handling specific button functions
            for (var button in controller.buttonsDetails) {
              if (isControlPressed &&
                  button['keyboard'] != null &&
                  button['keyboard'] is List<LogicalKeyboardKey> &&
                  button['keyboard'].contains(key)) {
                button['function'](button['title']);
                numberBuffer = '';
                break;
              }
            }

            //! Handling Escape key
            if (key == LogicalKeyboardKey.escape) {
              Get.offAndToNamed(AppRoute.homeScreen);
              numberBuffer = '';
            }

            //! Handling Enter key
            if (key == LogicalKeyboardKey.enter) {
              customPaymentDialog();
              numberBuffer = '';
            }
            if (key == LogicalKeyboardKey.keyS) {
              showDropDownList(
                context,
                controller.dropDownList,
                controller.dropDownID!,
                controller.dropDownName!,
              );
              numberBuffer = '';
            }
          }
          return KeyEventResult.ignored;
        },
        child: ResponsiveBuilder(
          windows: Row(
            children: [
              CashierLeftSideScreen(),
              CashierRightSideScreen(),
            ],
          ),
          mobile: CashierScreenMobile(),
        ),
      ),
    );
  }
}
