import 'package:get/get.dart';

String? validInput(String val, int min, int max, String type,
    {bool required = true}) {
  if (required && val.isEmpty) {
    return "Field can't be empty".tr;
  }

  if (val.isNotEmpty) {
    if (val.length < min) {
      return "Field can't be less than $min".tr;
    }

    if (val.length > max) {
      return "Field can't be more than $max".tr;
    }

    if (type == "username" && !GetUtils.isUsername(val)) {
      return "Username not valid. Try with a correct username".tr;
    }
    if (type == "code" && !GetUtils.isUsername(val)) {
      return "code not valid. Try with a correct code".tr;
    }

    if (type == "text" && !GetUtils.isWord(val)) {
      return "Not a valid text".tr;
    }

    if (type == "email" && !GetUtils.isEmail(val)) {
      return "E-mail not valid".tr;
    }

    if (type == "number" && !GetUtils.isNumericOnly(val)) {
      return "Number required (e.g., 1, 2, 3...)".tr;
    }
    if (type == "realNumber" && !GetUtils.isNum(val)) {
      return "Number required (e.g.,0.1 ,0.5 , 1, 2, 3...)".tr;
    }
    if (type == "real" && !GetUtils.isNum(val)) {
      return "Number required (e.g.,0.1 ,0.5 , 1, 2, 3...)".tr;
    }

    if (type == "phone" && !GetUtils.isPhoneNumber(val)) {
      return "Mobile number not valid".tr;
    }
  }

  return null; // Return null if no validation errors
}
