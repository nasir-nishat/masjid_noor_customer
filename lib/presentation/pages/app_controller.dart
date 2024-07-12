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

  RxBool isLoading = false.obs;
  BuildContext? globalContext;

  void setGlobalContext(BuildContext context) {
    globalContext = context;
  }

  void showErrorDialog(String message) {
    if (globalContext != null) {
      showDialog(
        context: globalContext!,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Go Home'),
              ),
            ],
          );
        },
      );
    }
  }

  void showLoading() {
    isLoading.value = true;
    Future.delayed(const Duration(seconds: 10), () {
      isLoading.value = false;
    });
  }

  void hideLoading() {
    isLoading.value = false;
  }
}
