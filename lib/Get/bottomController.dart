import 'package:get/get.dart';

class BottomController extends GetxController {
  RxInt current = 0.obs;

  change(int value) {
    current.value = value;
  }
}
