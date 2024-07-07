import 'package:get/get.dart';

class CartController extends GetxController {
  static CartController get to {
    if (!Get.isRegistered<CartController>()) {
      Get.lazyPut<CartController>(() => CartController());
    }
    return Get.find<CartController>();
  }
}
