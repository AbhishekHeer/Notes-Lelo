import 'package:get/get.dart';

class ButtonColorController extends GetxController {
  RxBool color = false.obs;

  change(bool torf) {
    if (torf == true) {
      color.value = false;
    } else {
      color.value = true;
    }
  }
}
