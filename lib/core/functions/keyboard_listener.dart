import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget customKeyboardListener({
  required FocusNode focusNode,
  required LogicalKeyboardKey logicalKeyboardKeys,
  required void Function() onTap,
  required Widget child,
}) {
  return KeyboardListener(
    focusNode: focusNode,
    autofocus: true,
    onKeyEvent: (event) {
      
      if (event is KeyDownEvent) {
        if (logicalKeyboardKeys == event.logicalKey) {
          onTap();
        }
      } else if (event is KeyUpEvent) {}
    },
    child: child,
  );
}
