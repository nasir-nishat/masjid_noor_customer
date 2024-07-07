import 'package:get/get.dart';

class ProductController extends GetxController {
  static ProductController get to {
    if (!Get.isRegistered<ProductController>()) {
      Get.lazyPut<ProductController>(() => ProductController());
    }
    return Get.find<ProductController>();
  }
}
