import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
import 'package:masjid_noor_customer/mgr/dependency/supabase_dep.dart';
import 'package:masjid_noor_customer/mgr/models/user_md.dart';
import 'package:masjid_noor_customer/mgr/services/api_service.dart';
import 'package:masjid_noor_customer/navigation/router.dart';
import 'package:masjid_noor_customer/presentation/pages/app_controller.dart';

class UserController extends GetxController {
  static UserController get to {
    if (!Get.isRegistered<UserController>()) {
      Get.lazyPut<UserController>(() => UserController());
    }
    return Get.find<UserController>();
  }

  RxBool isLoading = false.obs;
  final _logger = Logger('UserController');
  Rx<UserMd> user = UserMd(email: '', phoneNumber: '').obs;

  Future<bool> fetchUser() async {
    AppController.to.showGlobalLoading();
    final userBox = AuthenticationNotifier().usermd;

    UserMd? currentUser = userBox;
    try {
      UserMd? cUser = currentUser != null
          ? await ApiService().getUser(currentUser.userId!)
          : null;

      if (cUser != null) {
        _logger.info(cUser.toJson());
        AuthenticationNotifier.instance.usermd = cUser;
        user.value = cUser;
        _logger.info(user.toJson());
        update();
        return true;
      } else {
        currentUser = null;
        AuthenticationNotifier().usermd = null;
        user = UserMd(email: '', phoneNumber: '').obs;
        AuthenticationNotifier.instance.logout();
      }

      update();
      return false;
    } catch (e) {
      debugPrint('Error: $e');
      update();
      return false;
    } finally {
      _logger.info(currentUser?.email);
      AppController.to.hideGlobalLoading();
      update();
    }
  }

  void updatePhoneNumber(String phoneNumber) async {
    await ApiService().updateUserPhoneNumber(phoneNumber);
    user.update((val) {
      AuthenticationNotifier.instance.usermd!.phoneNumber = phoneNumber;
      final userBox = Hive.box<UserMd>('user_box');
      UserMd hiveUser = userBox.values.toList().first;
      hiveUser.phoneNumber = phoneNumber;
      userBox.put('user', hiveUser);
      val!.phoneNumber = phoneNumber;
    });
    update();
  }
}
