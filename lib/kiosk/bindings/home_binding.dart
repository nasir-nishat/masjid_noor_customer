// lib/app/bindings/home_binding.dart
import 'package:get/get.dart';
import 'package:masjid_noor_customer/kiosk/views/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
