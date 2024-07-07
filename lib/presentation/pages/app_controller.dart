import 'package:get/get.dart';

class AppController extends GetxController {
  static AppController get to {
    if (!Get.isRegistered<AppController>()) {
      Get.lazyPut<AppController>(() => AppController());
      return Get.find<AppController>();
    }
    return Get.find<AppController>();
  }

  RxString userEmail = ''.obs;
}
