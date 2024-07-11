import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:masjid_noor_customer/mgr/models/user_md.dart';
import 'package:masjid_noor_customer/mgr/services/api_service.dart';
import 'package:masjid_noor_customer/navigation/router.dart';

class UserController extends GetxController {
  static UserController get to {
    if (!Get.isRegistered<UserController>()) {
      Get.lazyPut<UserController>(() => UserController());
    }
    return Get.find<UserController>();
  }

  Rx<UserMd> user = UserMd(phoneNumber: '', email: '').obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }

  fetchUser() async {
    isLoading.value = true;
    final userBox = Hive.box<UserMd>('user_box');
    UserMd hiveUser = userBox.values.toList().first;
    String userId = hiveUser.userId ?? '';

    if (userId.isEmpty) {
      await ApiService().getUser(userId).then((value) {
        user.value = value!;
      });
    } else {
      user.value = hiveUser;
    }
    isLoading.value = false;
    update();
  }

  void updatePhoneNumber(String phoneNumber) async {
    await ApiService().updateUserPhoneNumber(phoneNumber);
    update();
  }
}
