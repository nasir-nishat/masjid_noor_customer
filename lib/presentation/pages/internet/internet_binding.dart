import 'package:get/get.dart';
import 'package:masjid_noor_customer/presentation/pages/app_controller.dart';
import 'package:masjid_noor_customer/presentation/pages/cart/cart_controller.dart';
import 'package:masjid_noor_customer/presentation/pages/order/order_controller.dart';
import 'package:masjid_noor_customer/presentation/pages/prayer/prayer_time_controller.dart';
import 'package:masjid_noor_customer/presentation/pages/product/product_controller.dart';
import 'package:masjid_noor_customer/presentation/pages/product/search_product_controller.dart';
import 'package:masjid_noor_customer/presentation/pages/user/phone_verify_controller.dart';
import 'package:masjid_noor_customer/presentation/pages/user/user_controller.dart';
import 'internet_controller.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    FlutterNativeSplash.remove();
    Get.lazyPut<ConnectivityController>(() => ConnectivityController());
    Get.lazyPut<PrayerTimesController>(() => PrayerTimesController());
    Get.lazyPut<UserController>(() => UserController());
    // Get.lazyPut<PhoneVerificationController>(() => PhoneVerificationController());
    Get.lazyPut<ProductController>(() => ProductController());
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<OrderController>(() => OrderController());
    Get.lazyPut<SearchProductController>(() => SearchProductController());
    Get.lazyPut<AppController>(() => AppController());
  }
}
