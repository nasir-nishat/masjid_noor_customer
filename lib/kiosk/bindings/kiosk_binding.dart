import 'package:get/get.dart';
import 'package:masjid_noor_customer/kiosk/views/controllers/kiosk_controller.dart';
import 'package:masjid_noor_customer/presentation/pages/order/order_controller.dart';
import 'package:masjid_noor_customer/presentation/pages/product/product_controller.dart';

class KioskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KioskController>(() => KioskController());
    Get.lazyPut<ProductController>(() => ProductController());
    Get.lazyPut<OrderController>(() => OrderController());
  }
}
