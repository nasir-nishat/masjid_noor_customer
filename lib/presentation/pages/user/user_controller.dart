import 'package:get/get.dart';
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

  late UserMd user;

  @override
  void onInit() {
    super.onInit();
    final savedUser = AuthenticationNotifier.instance.getUser();
    if (savedUser != null) {
      user = savedUser;
    } else {
      user = UserMd(email: "", phoneNumber: "", createdAt: DateTime.now());
    }
  }

  void updatePhoneNumber(String phoneNumber) async {
    await ApiService().updateUserPhoneNumber(phoneNumber);
    user.phoneNumber = phoneNumber;
    update();
  }
}
