import 'package:get/get.dart';

validInput(String val, int min, int max, String type) {
  if (val.isEmpty) {
    return "Field can't be empty".tr;
  }

  if (val.length < min) {
    return "Field can't less than ".tr + min.toString();
  }

  if (val.length > max) {
    return "Field can't more than ".tr + max.toString();
  }
  if (type == "username") {
    if (!GetUtils.isUsername(val)) {
      return "username not valid try with correct username".tr;
    }
  }
  if (type == "text") {
    if (!GetUtils.isWord(val)) {
      return "Not valid text".tr;
    }
  }
  if (type == "email") {
    if (!GetUtils.isEmail(val)) {
      return "E-mail not valid".tr;
    }
  }
  if (type == "number") {
    if (!GetUtils.isNumericOnly(val)) {
      return "Number Required 1 , 2 , 3...".tr;
    }
  }

  if (type == "phone") {
    if (!GetUtils.isPhoneNumber(val)) {
      return "Mobile number not valid".tr;
    }
  }
}
