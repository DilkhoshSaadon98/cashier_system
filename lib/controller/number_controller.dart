import 'package:get/get.dart';

class NumberController extends GetxController {
  int selectedNumber = 0;

  void updateNumber(int number) { 
    selectedNumber = number;
    update();
  }
}
