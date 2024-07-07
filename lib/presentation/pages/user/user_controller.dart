import 'package:get/get.dart';

class UserController extends GetxController {
  static UserController get to {
    if (!Get.isRegistered<UserController>()) {
      Get.lazyPut<UserController>(() => UserController());
    }
    return Get.find<UserController>();
  }
}
