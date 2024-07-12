import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  static AppController get to {
    if (!Get.isRegistered<AppController>()) {
      Get.lazyPut<AppController>(() => AppController());
      return Get.find<AppController>();
    }
    return Get.find<AppController>();
  }

  RxBool globalLoading = false.obs;

  void showGlobalLoading() {
    globalLoading.value = true;
    Future.delayed(const Duration(seconds: 10), () {
      globalLoading.value = false;
    });
  }

  void hideGlobalLoading() {
    globalLoading.value = false;
  }
}
