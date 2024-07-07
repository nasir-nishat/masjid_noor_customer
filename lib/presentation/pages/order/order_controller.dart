import 'package:get/get.dart';

class OrderController extends GetxController {
  static OrderController get to {
    if (!Get.isRegistered<OrderController>()) {
      Get.lazyPut<OrderController>(() => OrderController());
    }
    return Get.find<OrderController>();
  }

  var orderList = [].obs;
}
