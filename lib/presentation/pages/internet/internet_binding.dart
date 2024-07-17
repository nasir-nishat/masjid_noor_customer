import 'package:get/get.dart';import 'package:masjid_noor_customer/presentation/pages/app_controller.dart';import 'package:masjid_noor_customer/presentation/pages/cart/cart_controller.dart';import 'package:masjid_noor_customer/presentation/pages/order/order_controller.dart';import 'package:masjid_noor_customer/presentation/pages/prayer/prayer_time_controller.dart';import 'package:masjid_noor_customer/presentation/pages/product/product_controller.dart';import 'package:masjid_noor_customer/presentation/pages/user/user_controller.dart';import 'internet_controller.dart';class InitialBindings extends Bindings {  @override  void dependencies() {    Get.lazyPut<ConnectivityController>(() => ConnectivityController());    Get.lazyPut<PrayerTimesController>(() => PrayerTimesController());    Get.lazyPut<UserController>(() => UserController());    Get.lazyPut<ProductController>(() => ProductController());    Get.lazyPut<CartController>(() => CartController());    Get.lazyPut<OrderController>(() => OrderController());    Get.lazyPut<AppController>(() => AppController());  }}